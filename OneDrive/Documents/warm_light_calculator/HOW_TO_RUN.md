# How to Run Warm Light Calculator

## Quick Start Guide

### Step 1: Navigate to Project Directory
Open PowerShell or Command Prompt and navigate to the project:
```powershell
cd C:\Users\kturn\OneDrive\Documents\warm_light_calculator
```

### Step 2: Install Dependencies
```powershell
flutter pub get
```
This installs the required packages (flutter_tts, shared_preferences).

### Step 3: Check Available Devices
```powershell
flutter devices
```
This shows available devices (emulators, physical devices, web browser).

### Step 4: Run the App

**Option A: Run on Web (Easiest - No emulator needed)**
```powershell
flutter run -d chrome
```

**Option B: Run on Android Emulator**
```powershell
flutter run -d android
```
*(Requires Android Studio with an emulator set up)*

**Option C: Run on Connected Device**
```powershell
flutter run
```
*(With your Android/iOS device connected via USB with debugging enabled)*

---

## Troubleshooting

### If Flutter Command Doesn't Work:

1. **Check Flutter Installation:**
   - Open a NEW PowerShell window
   - Run: `flutter doctor`
   - Fix any issues shown

2. **If Flutter Doctor Shows Issues:**
   - Follow the `FLUTTER_SETUP_GUIDE.md` in your Documents folder
   - You may need to reinstall Flutter or fix PATH configuration

3. **If "flutter pub get" Fails:**
   - Make sure you're in the `warm_light_calculator` directory
   - Check that `pubspec.yaml` exists in that folder

### Alternative: Use Android Studio / VS Code

**Android Studio:**
1. Open Android Studio
2. File → Open → Select `warm_light_calculator` folder
3. Wait for indexing
4. Click the green "Run" button or press Shift+F10

**VS Code:**
1. Open VS Code
2. File → Open Folder → Select `warm_light_calculator`
3. Install Flutter extension if not installed
4. Press F5 or click "Run and Debug"

---

## Testing Features

Once the app is running:

1. **Test Calculator:**
   - Try basic operations: 5 + 3 = 8
   - Test division by zero (should show "Error")

2. **Test Tip Calculator:**
   - Enter a number (e.g., 100)
   - Tap 10% button (should show 110)
   - Tap 15% button (should show 115)

3. **Test Memory:**
   - Enter 10, tap M+
   - Enter 5, tap M+
   - Tap MR (should show 15)

4. **Test Settings:**
   - Tap Settings icon (top right)
   - Toggle Text-to-Speech ON
   - Tap buttons (should hear speech)
   - Toggle High Contrast Mode ON
   - Choose Dark or Light style

5. **Test Copy to Clipboard:**
   - Calculate something
   - Long-press the display
   - Should show "Copied to clipboard"

---

## Next Steps After Testing

Once you've tested and everything works:

1. **Build for Production:**
   ```powershell
   flutter build appbundle  # For Android
   flutter build ios        # For iOS (requires Mac)
   ```

2. **See `DEPLOYMENT_NOTES.md` for full deployment instructions**

---

## Common Issues

**Issue: "No devices found"**
- Solution: Start an Android emulator or connect a physical device
- For web: Just use `flutter run -d chrome`

**Issue: "Error: Unable to locate Android SDK"**
- Solution: Install Android Studio and set up Android SDK
- Or use web: `flutter run -d chrome`

**Issue: Dependencies won't install**
- Solution: Check internet connection
- Try: `flutter pub cache repair` then `flutter pub get`

---

**Need Help?** Check the error message and try the troubleshooting steps above!

