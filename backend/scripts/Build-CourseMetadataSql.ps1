param(
    [string]$InputPath = 'Infrastructure/DataSource/CourseMetadata.Public.json',
    [string]$OutputPath = 'artifacts/ImportCourseMetadata.sql'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$source = if ([IO.Path]::IsPathRooted($InputPath)) { $InputPath } else { Join-Path $root $InputPath }
$target = if ([IO.Path]::IsPathRooted($OutputPath)) { $OutputPath } else { Join-Path $root $OutputPath }
$records = Get-Content -LiteralPath $source -Raw -Encoding UTF8 | ConvertFrom-Json
if ($records.Count -ne 72) { throw "Expected 72 records, found $($records.Count)." }
if (@($records | Where-Object { $_.status -ne 'ok' -or -not $_.description -or $_.syllabusSections.Count -eq 0 }).Count -gt 0) {
    throw 'The scrape contains incomplete records.'
}

function Sql-Literal([string]$value) { return "'" + $value.Replace("'", "''") + "'" }
function Sql-TextArray($values) {
    $items = @($values | Where-Object { $_ -is [string] -and $_.Trim() })
    if ($items.Count -eq 0) { return 'ARRAY[]::text[]' }
    return 'ARRAY[' + (($items | ForEach-Object { Sql-Literal $_ }) -join ', ') + ']::text[]'
}

$sql = [System.Text.StringBuilder]::new()
[void]$sql.AppendLine('-- Review this generated script before applying it to PostgreSQL.')
[void]$sql.AppendLine('-- Only untouched inferred seed rows are updated; manually revised rows are skipped.')
[void]$sql.AppendLine('BEGIN;')
[void]$sql.AppendLine('CREATE TEMP TABLE imported_course_metadata_ids (course_id bigint PRIMARY KEY) ON COMMIT DROP;')
foreach ($record in $records) {
    if ($record.sourceUrl -notlike 'https://cursos.devtalles.com/courses/*') { throw "Invalid source URL: $($record.slug)" }
    if ($record.durationMinutes -isnot [int] -or $record.durationMinutes -le 0) { throw "Invalid duration: $($record.slug)" }
    $slug = Sql-Literal $record.slug
    $description = Sql-Literal $record.description
    $syllabus = Sql-Literal ($record.syllabusSections -join "`n")
    $outcomes = Sql-TextArray $record.learningOutcomes
    $prerequisites = Sql-TextArray $record.prerequisites
    $url = Sql-Literal $record.sourceUrl
    [void]$sql.AppendLine("-- $($record.slug)")
    [void]$sql.AppendLine("WITH changed AS (")
    [void]$sql.AppendLine("  UPDATE courses SET")
    [void]$sql.AppendLine("    description = $description,")
    [void]$sql.AppendLine("    syllabus = $syllabus,")
    [void]$sql.AppendLine("    learning_outcomes = $outcomes,")
    [void]$sql.AppendLine("    skills_taught = ARRAY[]::text[],")
    [void]$sql.AppendLine("    prerequisites = $prerequisites,")
    [void]$sql.AppendLine("    target_audience = ARRAY[]::text[],")
    [void]$sql.AppendLine("    duration_minutes = $($record.durationMinutes),")
    [void]$sql.AppendLine("    metadata_source_url = $url,")
    [void]$sql.AppendLine("    metadata_origin = 'public-page-scrape-v1',")
    [void]$sql.AppendLine("    metadata_verified_at = NULL,")
    [void]$sql.AppendLine("    updated_at = NOW()")
    [void]$sql.AppendLine("  WHERE slug = $slug")
    [void]$sql.AppendLine("    AND metadata_origin = 'inferred-seed-v1'")
    [void]$sql.AppendLine("    AND metadata_source_url IS NULL AND metadata_verified_at IS NULL")
    [void]$sql.AppendLine("    AND description LIKE 'Propuesta inicial de aprendizaje para%'")
    [void]$sql.AppendLine("  RETURNING course_id")
    [void]$sql.AppendLine(") INSERT INTO imported_course_metadata_ids SELECT course_id FROM changed ON CONFLICT DO NOTHING;")
}
[void]$sql.AppendLine('DELETE FROM course_embeddings WHERE course_id IN (SELECT course_id FROM imported_course_metadata_ids);')
[void]$sql.AppendLine('SELECT COUNT(*) AS imported_courses FROM imported_course_metadata_ids;')
[void]$sql.AppendLine('COMMIT;')
$directory = Split-Path $target -Parent
New-Item -ItemType Directory -Force -Path $directory | Out-Null
$sql.ToString() | Set-Content -LiteralPath $target -Encoding UTF8
Write-Host "Generated $($records.Count) guarded updates in $target"
