# Complete Beginner's Guide: Running Your First App

## 🎯 What You're About to Do

You have a calculator app that's ready to run. We need to:
1. Make sure Flutter (the tool that builds apps) is working
2. Install the app's dependencies (extra code it needs)
3. Run the app on your computer

---

## 📋 Step 1: Check if Flutter is Working

### What is Flutter?
Flutter is a tool that turns your code into an app that runs on phones and computers.

### How to Check:
1. Open PowerShell:
   - Press `Windows Key`
   - Type "PowerShell"
   - Click "Windows PowerShell"

2. Type this and press Enter:
   ```powershell
   flutter doctor
   ```

3. What you might see:
   - ✅ **Good**: Lists things with checkmarks ✅
   - ❌ **Bad**: Shows errors or tries to update forever
   
   **If it gets stuck or shows errors**, you need to fix Flutter first (see Step 2).

---

## 🔧 Step 2: Fix Flutter (Only if Step 1 Failed)

### If Flutter Doctor is Stuck or Broken:

**Option A: Reinstall Flutter (Recommended)**
1. Download Flutter:
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Click "Download Flutter SDK"
   - Download the ZIP file

2. Extract it:
   - Right-click the ZIP file
   - Click "Extract All"
   - Extract to `C:\src\flutter` (create the `src` folder if needed)

3. Add Flutter to your PATH:
   - Press `Windows Key` and type "Environment Variables"
   - Click "Edit the system environment variables"
   - Click "Environment Variables" button
   - Under "User variables", find "Path" and click "Edit"
   - Click "New"
   - Type: `C:\src\flutter\bin` (or wherever you extracted Flutter)
   - Click "OK" on all windows
   - **Close and reopen PowerShell** (important!)

4. Test again:
   - Open new PowerShell
   - Type: `flutter doctor`
   - Should work now!

**Option B: Use Android Studio Instead**
If fixing Flutter is too complicated, just use Android Studio:
1. Download Android Studio: https://developer.android.com/studio
2. Install it
3. Open Android Studio
4. File → Open → Find your `warm_light_calculator` folder
5. Click the green play button ▶️

---

## 🚀 Step 3: Run Your App

### Method 1: Command Line (If Flutter Works)

1. **Open PowerShell** (Windows Key → type "PowerShell")

2. **Navigate to your project:**
   ```powershell
   cd C:\Users\kturn\OneDrive\Documents\warm_light_calculator
   ```
   (Press Enter after typing this)

3. **Install dependencies:**
   ```powershell
   flutter pub get
   ```
   (Wait for it to finish - might take 1-2 minutes the first time)

4. **Run the app in your web browser:**
   ```powershell
   flutter run -d chrome
   ```
   (This opens Chrome with your calculator app)

### Method 2: Android Studio (Easier if Command Line Doesn't Work)

1. **Open Android Studio**
   - If you don't have it: Download from https://developer.android.com/studio

2. **Open Your Project:**
   - Click "File" → "Open"
   - Navigate to: `C:\Users\kturn\OneDrive\Documents\warm_light_calculator`
   - Click "OK"

3. **Wait for Setup:**
   - Android Studio will download things (first time only)
   - Wait until it says "Indexing" or "Syncing" is done
   - This might take 5-10 minutes the first time

4. **Run the App:**
   - Look for a green play button ▶️ at the top
   - Click it
   - Choose "Chrome" from the device list
   - Your app should open!

---

## ❓ Troubleshooting

### "flutter: command not found"
**Problem:** Your computer doesn't know where Flutter is.

**Solution:** 
- You need to add Flutter to your PATH (see Step 2, Option A)
- Or use Android Studio instead

### "flutter pub get" takes forever or loops
**Problem:** Flutter is trying to update itself but failing.

**Solution:**
- Use Android Studio instead (Method 2)
- Or try fixing Flutter installation (Step 2)

### "No devices found"
**Problem:** No device to run on.

**Solution for Web:**
- Just use: `flutter run -d chrome`
- Make sure Chrome is installed

**Solution for Phone:**
- Connect your Android phone via USB
- Enable "Developer Options" and "USB Debugging" on your phone
- Then run: `flutter run`

### "Error: Unable to locate Android SDK"
**Problem:** Android development tools aren't set up.

**Solutions:**
- For web: Just use `flutter run -d chrome` (doesn't need Android)
- For Android: Install Android Studio (it includes the SDK)

### App doesn't look right
**Problem:** App might not have loaded properly.

**Solution:**
- Close the app
- Run `flutter clean` in PowerShell (in project folder)
- Then run `flutter pub get`
- Then run the app again

---

## ✅ Success Checklist

When everything works, you should see:

1. **Browser Opens:** Chrome opens automatically
2. **Calculator App:** You see a warm-colored calculator
3. **It Works:** You can tap buttons and they respond
4. **Settings Work:** Tap the settings icon (⚙️) in top right

---

## 🎓 What Each Command Does

- `flutter doctor` = Check if Flutter is set up correctly
- `cd [folder]` = Change to that folder
- `flutter pub get` = Download code your app needs
- `flutter run -d chrome` = Build and run app in Chrome browser
- `flutter clean` = Clean up old build files
- `flutter devices` = Show what devices you can run on

---

## 🆘 Still Stuck?

If nothing works:

1. **Use Android Studio** - It's the easiest way
2. **Check YouTube** - Search "Flutter Windows setup tutorial"
3. **Flutter Docs** - https://docs.flutter.dev/get-started/install/windows

Remember: This is your first app! It's normal for setup to take time. Once it's working, future apps will be much easier! 🎉

---

## 📱 What to Test Once It's Running

1. ✅ Can you tap numbers? (Try: 1, 2, 3)
2. ✅ Can you do math? (Try: 5 + 3 = 8)
3. ✅ Do tip buttons work? (Enter 100, tap 10%)
4. ✅ Do memory buttons work? (Enter 5, tap M+, tap MR)
5. ✅ Do settings work? (Tap ⚙️, toggle things on/off)
6. ✅ Does copy work? (Calculate something, long-press display)

If all these work, your app is ready! 🎊

