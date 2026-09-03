Set-Location $PSScriptRoot
$folder = (Get-Location).Path

Write-Host "Watching: $folder"
Write-Host "Target branch: main"
Write-Host "Press Ctrl+C to stop."

& git -C $folder checkout main
& git -C $folder pull origin main --rebase

while ($true) {
    Start-Sleep -Seconds 5

    $status = & git -C $folder status --porcelain 2>$null

    if ($status) {
        & git -C $folder add -A

        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        & git -C $folder commit -m "auto: $timestamp"

        & git -C $folder pull origin main --rebase

        if ($LASTEXITCODE -ne 0) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Pull/rebase failed. Resolve conflict manually." -ForegroundColor Red
            break
        }

        & git -C $folder push origin main

        if ($LASTEXITCODE -eq 0) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Pushed to main" -ForegroundColor Green
        } else {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Push failed" -ForegroundColor Red
        }
    }
}