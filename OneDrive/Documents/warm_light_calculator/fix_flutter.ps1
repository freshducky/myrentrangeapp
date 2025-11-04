# Fix Flutter Configuration Script
Write-Host "Fixing Flutter Configuration..." -ForegroundColor Green
Write-Host ""

# Set Flutter root path
$flutterPath = "C:\Users\kturn\OneDrive\Develop\flutter_windows_3.35.4-stable\flutter"
$env:FLUTTER_ROOT = $flutterPath

Write-Host "Set FLUTTER_ROOT to: $flutterPath" -ForegroundColor Cyan
Write-Host ""

# Try to run flutter doctor with the correct path
Write-Host "Testing Flutter..." -ForegroundColor Yellow
& "$flutterPath\bin\flutter.bat" doctor

Write-Host ""
Write-Host "If that worked, now try:" -ForegroundColor Green
Write-Host "  cd C:\Users\kturn\OneDrive\Documents\warm_light_calculator" -ForegroundColor Cyan
Write-Host "  flutter pub get" -ForegroundColor Cyan
Write-Host "  flutter run -d chrome" -ForegroundColor Cyan

