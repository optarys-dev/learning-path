param(
    [string]$OutputPath = 'artifacts/course-metadata-public.json',
    [int]$MaxCourses = 72,
    [int]$DelayMilliseconds = 800
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$seedPath = Join-Path $root 'Infrastructure/DataSource/Migrations/20260915051101_InitialCreate.cs'
$seed = Get-Content -LiteralPath $seedPath -Raw -Encoding UTF8
$entries = [regex]::Matches($seed, "\('(?<slug>[^']+)', '[^']*', '(?<url>https://cursos\.devtalles\.com/courses/[^']+)'", 'IgnoreCase')
if ($entries.Count -ne 72) { throw "Expected 72 catalog URLs, found $($entries.Count)." }

function Convert-HtmlText([string]$html) {
    $value = [regex]::Replace($html, '<br\s*/?>|</p>|</li>', "`n", 'IgnoreCase')
    $value = [regex]::Replace($value, '<[^>]+>', ' ')
    $value = [Net.WebUtility]::HtmlDecode($value)
    $lines = $value -split "\r?\n" | ForEach-Object { [regex]::Replace($_.Trim(), '\s+', ' ') } | Where-Object { $_ }
    return ($lines -join "`n").Trim()
}

function Extract-Section([string]$html, [string]$heading) {
    $escaped = [regex]::Escape($heading)
    $pattern = "<h3[^>]*>\s*(?:<[^>]+>\s*)*$escaped\s*</h3>\s*<div class=`"[^`"]*spec-inner-text[^`"]*`"[^>]*>(?<body>.*?)</div>"
    $match = [regex]::Match($html, $pattern, 'IgnoreCase, Singleline')
    if ($match.Success) { return $match.Groups['body'].Value }
    return $null
}

function Extract-ListAfterHeading([string]$html, [string]$headingPattern) {
    $pattern = "<h3[^>]*>\s*$headingPattern[^<]*</h3>\s*<ul[^>]*>(?<list>.*?)</ul>"
    $match = [regex]::Match($html, $pattern, 'IgnoreCase, Singleline')
    if (-not $match.Success) { return @() }
    return @([regex]::Matches($match.Groups['list'].Value, '<li[^>]*>(.*?)</li>', 'IgnoreCase, Singleline') |
        ForEach-Object { Convert-HtmlText $_.Groups[1].Value } | Where-Object { $_ })
}

$robots = (Invoke-WebRequest -Uri 'https://cursos.devtalles.com/robots.txt' -UseBasicParsing -TimeoutSec 20).Content
if ($robots -match '(?im)^Disallow:\s*/courses/?\s*$') { throw 'robots.txt disallows course pages.' }

$results = [System.Collections.Generic.List[object]]::new()
$selected = @($entries | Select-Object -First $MaxCourses)
foreach ($entry in $selected) {
    $slug = $entry.Groups['slug'].Value
    $url = $entry.Groups['url'].Value
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30
        $html = $response.Content
        $titleMatch = [regex]::Match($html, '<title>(?<value>.*?)</title>', 'IgnoreCase, Singleline')
        $descriptionMatch = [regex]::Match($html, '<meta\s+name="description"\s+content="(?<value>[^"]*)"', 'IgnoreCase')
        $description = if ($descriptionMatch.Success) { [Net.WebUtility]::HtmlDecode($descriptionMatch.Groups['value'].Value).Trim() } else { $null }
        $chapters = @([regex]::Matches($html, '<h3\s+class="course-curriculum__chapter-title"[^>]*>(?<value>.*?)</h3>', 'IgnoreCase, Singleline') |
            ForEach-Object { Convert-HtmlText $_.Groups['value'].Value } | Where-Object { $_ })
        $prerequisiteBody = Extract-Section $html 'Requisitos previos'
        $prerequisites = [string[]]@()
        if ($prerequisiteBody) {
            # Additional notices sometimes follow the prerequisite list in a table.
            $prerequisiteBody = ($prerequisiteBody -split '(?i)<table\b', 2)[0]
            $prerequisites = [string[]]@((Convert-HtmlText $prerequisiteBody) -split "`n" |
                ForEach-Object { $_ -replace '^[\s\-\u2022]+' , '' } | Where-Object { $_ })
        }
        $outcomes = @(Extract-ListAfterHeading $html 'Resultados al finalizar')
        $durationMatch = [regex]::Match($html, '(?<number>\d+(?:[.,]\d+)?)\s*(?<unit>horas?|minutos?)\s+de contenido en video', 'IgnoreCase')
        $duration = $null
        if ($durationMatch.Success) {
            $number = [double]::Parse($durationMatch.Groups['number'].Value.Replace(',', '.'), [Globalization.CultureInfo]::InvariantCulture)
            $duration = if ($durationMatch.Groups['unit'].Value.StartsWith('hora', [StringComparison]::OrdinalIgnoreCase)) {
                [int][Math]::Round($number * 60)
            } else { [int][Math]::Round($number) }
        }
        $results.Add([pscustomobject]@{
            slug = $slug
            sourceUrl = $url
            fetchedAtUtc = [DateTime]::UtcNow.ToString('o')
            status = 'ok'
            pageTitle = if ($titleMatch.Success) { [Net.WebUtility]::HtmlDecode($titleMatch.Groups['value'].Value).Trim() } else { $null }
            description = $description
            syllabusSections = $chapters
            prerequisites = @($prerequisites)
            learningOutcomes = $outcomes
            durationMinutes = $duration
        })
        Write-Host "${slug}: $($chapters.Count) sections, $($prerequisites.Count) prerequisites"
    }
    catch {
        $results.Add([pscustomobject]@{
            slug = $slug
            sourceUrl = $url
            fetchedAtUtc = [DateTime]::UtcNow.ToString('o')
            status = 'error'
            error = $_.Exception.Message
        })
        Write-Warning "${slug}: $($_.Exception.Message)"
    }
    if ($DelayMilliseconds -gt 0) { Start-Sleep -Milliseconds $DelayMilliseconds }
}

$target = if ([IO.Path]::IsPathRooted($OutputPath)) { $OutputPath } else { Join-Path $root $OutputPath }
$directory = Split-Path $target -Parent
New-Item -ItemType Directory -Force -Path $directory | Out-Null
$results | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $target -Encoding UTF8
Write-Host "Saved $($results.Count) records to $target"
