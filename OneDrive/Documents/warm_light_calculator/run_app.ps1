# Warm Light Calculator - Quick Run Script
# This script helps avoid Flutter configuration loops

Write-Host "Warm Light Calculator - Running App" -ForegroundColor Green
Write-Host ""

# Navigate to project directory
$projectPath = "C:\Users\kturn\OneDrive\Documents\warm_light_calculator"
Set-Location $projectPath

Write-Host "Current directory: $(Get-Location)" -ForegroundColor Cyan
Write-Host ""

# Check if pubspec.yaml exists
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "ERROR: pubspec.yaml not found!" -ForegroundColor Red
    Write-Host "Make sure you're in the correct directory." -ForegroundColor Yellow
    exit 1
}

Write-Host "Step 1: Installing dependencies..." -ForegroundColor Yellow
try {
    $env:FLUTTER_ROOT = $null  # Try to bypass pub upgrade loop
    flutter pub get --no-precompile 2>&1 | Write-Host
} catch {
    Write-Host "Warning: flutter pub get had issues, but continuing..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 2: Checking for devices..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "Step 3: Running app on Chrome..." -ForegroundColor Yellow
Write-Host "If Flutter hangs, press Ctrl+C and try using Android Studio instead." -ForegroundColor Cyan
Write-Host ""

flutter run -d chrome

