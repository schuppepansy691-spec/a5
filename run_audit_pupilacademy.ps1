$baseDir = "d:\antigravity website\pupilacademy"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "    PUPILACADEMY - AUDIT REPORT          " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$allFiles = Get-ChildItem -Path $baseDir -Recurse -File
Write-Host "Total Files: $($allFiles.Count)" -ForegroundColor Yellow

# 1. Check Blog Word Counts
Write-Host "`n--- BLOG WORD COUNT AUDIT (Target: 1200+ words) ---" -ForegroundColor Magenta
$blogFiles = Get-ChildItem -Path "$baseDir\blog" -Filter *.html
foreach ($b in $blogFiles) {
    $content = Get-Content $b.FullName -Raw
    $textOnly = $content -replace '<[^>]+>', ' ' -replace '\s+', ' '
    $words = ($textOnly.Trim().Split(' ') | Where-Object { $_.Length -gt 0 }).Count
    if ($words -ge 1200) {
        Write-Host "  [PASS] $($b.Name) : $words words" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $($b.Name) : $words words (Under 1200 target!)" -ForegroundColor Red
    }
}

# 2. Check Google Tag
Write-Host "`n--- GOOGLE TAG AUDIT (G-0LY0HY7L01) ---" -ForegroundColor Magenta
$htmlAndPhp = Get-ChildItem -Path $baseDir -Recurse -Include *.html,*.php
foreach ($f in $htmlAndPhp) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match "G-0LY0HY7L01") {
        Write-Host "  [PASS] $($f.Name) contains Google Tag" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $($f.Name) MISSING Google Tag!" -ForegroundColor Red
    }
}

# 3. Check Contact Details
Write-Host "`n--- CONTACT DETAILS AUDIT (181 Mercer St & Phone) ---" -ForegroundColor Magenta
foreach ($f in $htmlAndPhp) {
    $content = Get-Content $f.FullName -Raw
    $hasAddress = $content -match "181 Mercer Street"
    $hasPhone = $content -match "888-777-5845"
    if ($hasAddress -and $hasPhone) {
        Write-Host "  [PASS] $($f.Name) has complete contact details" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $($f.Name) MISSING contact details" -ForegroundColor Red
    }
}

# 4. Check Images
Write-Host "`n--- IMAGE ASSETS AUDIT ---" -ForegroundColor Magenta
$images = Get-ChildItem -Path "$baseDir\images"
foreach ($img in $images) {
    Write-Host "  [OK] $($img.Name) ($($img.Length) bytes)" -ForegroundColor Green
}

# 5. Check Strict Exclusions
Write-Host "`n--- STRICT EXCLUSIONS FILTER AUDIT ---" -ForegroundColor Magenta
$forbiddenPatterns = @(
    '\bfinance\b', '\bbanking\b', '\bloan(s)?\b', '\btrading\b', '\bcrypto(currency)?\b',
    '\breal estate\b', '\brealtor\b', '\bcondo(s)?\b', '\bmortgage\b',
    '\bwine\b', '\balcohol\b', '\bchampagne\b', '\bbeer\b', '\bliquor\b'
)
$forbiddenFound = $false
foreach ($f in $htmlAndPhp) {
    $content = Get-Content $f.FullName -Raw
    foreach ($pat in $forbiddenPatterns) {
        if ($content -match $pat) {
            Write-Host "  [ALERT] Forbidden term '$pat' found in $($f.Name)" -ForegroundColor Red
            $forbiddenFound = $true
        }
    }
}
if (-not $forbiddenFound) {
    Write-Host "  [PASS] Clean! 0 forbidden niche terms found across all pages." -ForegroundColor Green
}

# 6. Check Homepage Blog Absence
Write-Host "`n--- HOMEPAGE BLOG ABSENCE AUDIT ---" -ForegroundColor Magenta
$indexContent = Get-Content "$baseDir\index.php" -Raw
if ($indexContent -match "blog-pupil-card" -or $indexContent -match "blog-pupil-grid") {
    Write-Host "  [FAIL] index.php has blog cards!" -ForegroundColor Red
} else {
    Write-Host "  [PASS] index.php has NO blog cards (Clean Homepage Structure)." -ForegroundColor Green
}

# 7. Check Mojibake & Encoding
Write-Host "`n--- MOJIBAKE & ENCODING INTEGRITY AUDIT ---" -ForegroundColor Magenta
$badEncoding = $false
foreach ($f in $htmlAndPhp) {
    $c = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($c -match "[\uD800-\uDBFF][\uDC00-\uDFFF]" -or $c -match "Ã°|Ã¢Å¡|Ã¢â€ ") {
        Write-Host "  [ALERT] Mojibake found in $($f.Name)" -ForegroundColor Red
        $badEncoding = $true
    }
}
if (-not $badEncoding) {
    Write-Host "  [PASS] Clean! 0 mojibake or corrupt encoding characters found." -ForegroundColor Green
}

Write-Host "`nPupilAcademy Audit Completed Successfully." -ForegroundColor Cyan