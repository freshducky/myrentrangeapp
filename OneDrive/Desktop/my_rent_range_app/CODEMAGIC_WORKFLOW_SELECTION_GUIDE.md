# Codemagic Workflow Selection Guide

## 🚨 CRITICAL: Select the Correct Workflow

### Current Problem
Your builds are using a **UI-based workflow** instead of the **YAML workflow**, which is why:
- ❌ Wrong Bundle ID appears (`com.freshducky.warmlightcalculator`)
- ❌ No code signing step runs
- ❌ App Store distribution isn't configured

### Solution: Select YAML Workflow

#### Step 1: Navigate to Workflow Editor
1. Go to Codemagic → Your App → **Workflow Editor**
2. Look for a dropdown or tab that says **"Switch to YAML configuration"** or **"YAML"**

#### Step 2: Select the Correct Workflow
1. In the workflow dropdown, select: **"flutter-ios-workflow"**
2. OR look for: **"Flutter iOS Workflow"**
3. Make sure it's selected as the active workflow

#### Step 3: Verify YAML is Active
The build should show these steps when using YAML:
- ✅ Preparing build machine
- ✅ Fetching app sources
- ✅ Installing SDKs
- ✅ **Set up code signing identities** ← THIS STEP MUST APPEAR
- ✅ Installing dependencies
- ✅ Install Flutter dependencies
- ✅ Verify code signing configuration
- ✅ Flutter build ipa
- ✅ Publishing

#### Step 4: If YAML Workflow Not Available
If you don't see the workflow dropdown:

1. **Check Codemagic Settings:**
   - Go to **Settings** → **Repository settings**
   - Ensure **"Use YAML configuration"** is enabled
   - Or disable UI workflow configuration

2. **Alternative: Use Workflow Editor:**
   - Go to **Workflow Editor** tab
   - Click **"Switch to YAML configuration"** button
   - This should switch from UI workflow to YAML workflow

3. **Verify YAML File:**
   - Ensure `codemagic.yaml` exists in repository root
   - Check that it's committed and pushed to `main` branch

### Expected Build Log (When Correct)

When using the YAML workflow, you should see:
```
== Fetch iOS code signing files from Apple Developer Portal ==
> app-store-connect fetch-signing-files com.freshducky.myrentrange --create --type IOS_APP_STORE
```

NOT:
```
> app-store-connect fetch-signing-files ... --type IOS_APP_DEVELOPMENT
```

### Verification Checklist

Before starting a new build, verify:
- [ ] YAML workflow is selected (not UI workflow)
- [ ] Workflow name is "flutter-ios-workflow" or "Flutter iOS Workflow"
- [ ] "Set up code signing identities" step will appear in build
- [ ] `codemagic.yaml` is committed to repository
- [ ] Latest commit includes the correct YAML configuration

### If Still Not Working

1. **Delete UI Workflow:**
   - If a UI workflow exists, delete it
   - Force Codemagic to use only YAML

2. **Check Branch:**
   - Ensure you're building from `main` branch
   - Verify `codemagic.yaml` exists in that branch

3. **Contact Support:**
   - Provide build ID to Codemagic support
   - Ask them to verify YAML workflow is being used

