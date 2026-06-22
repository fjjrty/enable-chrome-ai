$ErrorActionPreference = "Stop"

function Log-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Log-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Log-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Log-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Stop-Chrome {
    Log-Info "Stopping Chrome processes..."

    Get-Process -Name "chrome" -ErrorAction SilentlyContinue |
        Stop-Process -Force -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 2
    Log-Success "Chrome processes stopped"
}

function Set-GlicEligible {
    param($Object)

    if ($null -eq $Object) {
        return
    }

    if ($Object -is [System.Collections.IDictionary]) {
        if ($Object.Contains("is_glic_eligible")) {
            $Object["is_glic_eligible"] = $true
        }

        foreach ($key in @($Object.Keys)) {
            Set-GlicEligible -Object $Object[$key]
        }
    }
    elseif ($Object -is [System.Collections.IEnumerable] -and -not ($Object -is [string])) {
        foreach ($item in $Object) {
            Set-GlicEligible -Object $item
        }
    }
    elseif ($Object.PSObject.Properties.Count -gt 0) {
        foreach ($prop in $Object.PSObject.Properties) {
            if ($prop.Name -eq "is_glic_eligible") {
                $prop.Value = $true
            }
            else {
                Set-GlicEligible -Object $prop.Value
            }
        }
    }
}

function Patch-LocalState {
    param([string]$Path)

    Log-Info "Processing: $Path"

    if (-not (Test-Path $Path)) {
        Log-Warn "File not found, skip: $Path"
        return
    }

    $backupPath = "$Path.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item -Path $Path -Destination $backupPath -Force
    Log-Info "Backup created: $backupPath"

    $jsonText = Get-Content -Path $Path -Raw -Encoding UTF8
    $json = $jsonText | ConvertFrom-Json

    $json | Add-Member -NotePropertyName "variations_country" -NotePropertyValue "us" -Force
    $json | Add-Member -NotePropertyName "variations_permanent_consistency_country" -NotePropertyValue @("1", "us") -Force

    Set-GlicEligible -Object $json

    $newJson = $json | ConvertTo-Json -Depth 100 -Compress
    Set-Content -Path $Path -Value $newJson -Encoding UTF8

    Log-Success "Patched: $Path"
}

function Main {
    Write-Host ""
    Write-Host "=========================================="
    Write-Host "     Enable Chrome AI - Windows"
    Write-Host "=========================================="
    Write-Host ""

    $chromePaths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State",
        "$env:LOCALAPPDATA\Google\Chrome Beta\User Data\Local State",
        "$env:LOCALAPPDATA\Google\Chrome Dev\User Data\Local State",
        "$env:LOCALAPPDATA\Google\Chrome SxS\User Data\Local State"
    )

    $foundPaths = @()

    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            $foundPaths += $path
        }
    }

    if ($foundPaths.Count -eq 0) {
        Log-Error "No Chrome Local State file found"
        Log-Info "Please install Chrome and run it at least once"
        exit 1
    }

    Log-Info "Found $($foundPaths.Count) Chrome Local State file(s)"

    Stop-Chrome

    foreach ($path in $foundPaths) {
        Patch-LocalState -Path $path
    }

    Write-Host ""
    Write-Host "=========================================="
    Log-Success "All changes completed"
    Write-Host "=========================================="
    Write-Host ""

    $restart = Read-Host "Restart Chrome now? [y/N]"

    if ($restart -match "^[Yy]$") {
        Start-Process "chrome.exe"
        Log-Success "Chrome restarted"
    }

    Log-Info "If needed, restore from the .backup file"
}

Main
