using System.Text.RegularExpressions;

namespace CodeQuest2026.Server.Infrastructure.DataSource;

/// <summary>Reads INSERT data from the checked-in pg_dump files; never executes their DDL.</summary>
public static class CatalogSeedDump
{
    // Column order in the supplied dumps, independent of the physical order created by EF.
    public static readonly IReadOnlyDictionary<string, string[]> Columns = new Dictionary<string, string[]>
    {
        ["categories"] = ["category_id", "name", "slug"],
        ["tags"] = ["tag_id", "name", "slug"],
        ["courses"] = ["course_id", "slug", "title", "course_url", "image_url", "image_alt", "level", "topics",
            "is_active", "source_verified_at", "created_at", "updated_at", "description", "duration_minutes", "language",
            "learning_outcomes", "metadata_source_url", "metadata_verified_at", "prerequisites", "skills_taught",
            "syllabus", "target_audience", "metadata_origin"],
        ["course_categories"] = ["course_id", "category_id"],
        ["course_tags"] = ["course_id", "tag_id"],
        ["course_embeddings"] = ["course_id", "embedding", "model", "dimensions", "content_hash", "generated_at"]
    };

    public static IReadOnlyList<(string Table, string Sql)> Read(string dump, IReadOnlySet<string> allowedTables)
    {
        var inserts = new List<(string Table, string Sql)>();
        var startPattern = new Regex(@"^INSERT INTO public\.(\w+)(?: OVERRIDING SYSTEM VALUE)? VALUES ", RegexOptions.Multiline);
        var offset = 0;
        while (startPattern.Match(dump, offset) is { Success: true } match)
        {
            var table = match.Groups[1].Value;
            if (!allowedTables.Contains(table) || !Columns.TryGetValue(table, out var columns))
                throw new InvalidDataException($"Unexpected seed table: {table}.");

            var start = match.Index + match.Length;
            var quoted = false;
            var end = start;
            for (; end < dump.Length; end++)
            {
                if (dump[end] == '\'')
                {
                    if (quoted && end + 1 < dump.Length && dump[end + 1] == '\'') { end++; continue; }
                    quoted = !quoted;
                }
                if (!quoted && dump[end] == ';') break;
            }
            if (end == dump.Length) throw new InvalidDataException($"Incomplete INSERT for {table}.");
            inserts.Add((table, $"INSERT INTO seed_{table} ({string.Join(", ", columns)}) VALUES {dump[start..end]};"));
            offset = end + 1;
        }
        if (inserts.Count == 0) throw new InvalidDataException("The seed dump contains no supported INSERT statements.");
        return inserts;
    }
}
