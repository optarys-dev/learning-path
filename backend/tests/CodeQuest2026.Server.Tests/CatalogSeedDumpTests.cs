using CodeQuest2026.Server.Infrastructure.DataSource;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public class CatalogSeedDumpTests
{
    [Fact]
    public void ReadsMultilineTextAndEscapedQuotesWithoutExecutingDumpDdl()
    {
        var dump = """
            CREATE TABLE public.tags (tag_id bigint, name text, slug text);
            ALTER TABLE public.tags OWNER TO postgres;
            INSERT INTO public.tags OVERRIDING SYSTEM VALUE VALUES (1, 'Text; with ''quotes''
            INSERT INTO public.users VALUES (99);
            and more text', 'tag');
            SELECT pg_catalog.setval('public.tags_tag_id_seq', 1, true);
            """;
        var insert = Assert.Single(CatalogSeedDump.Read(dump, new HashSet<string> { "tags" }));
        Assert.Equal("tags", insert.Table);
        Assert.StartsWith("INSERT INTO seed_tags (tag_id, name, slug) VALUES", insert.Sql);
        Assert.Contains("''quotes''", insert.Sql);
        Assert.DoesNotContain("OWNER TO", insert.Sql);
        Assert.DoesNotContain("setval", insert.Sql);
    }

    [Theory]
    [InlineData("INSERT INTO public.users VALUES (1);")]
    [InlineData("INSERT INTO public.tags VALUES (1, 'unfinished")]
    [InlineData("CREATE TABLE public.tags (tag_id bigint);")]
    public void RejectsUnsupportedOrIncompleteData(string dump)
    {
        Assert.Throws<InvalidDataException>(() => CatalogSeedDump.Read(dump, new HashSet<string> { "tags" }));
    }
}
