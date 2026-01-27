# Splash Screen - Session Verification Setup

## ✅ What Was Fixed

### Issue
The app crashed with:
```
"You must initialize the supabase instance before calling Supabase.instance"
```

The splash screen was trying to access Supabase before it was initialized.

### Solution
Added Supabase initialization in `main.dart` before the app starts.

---

## 📁 Files Modified

1. **[lib/main.dart](lib/main.dart)**
   - Added `Supabase.initialize()` before running the app
   - Made `main()` async with `WidgetsFlutterBinding.ensureInitialized()`

2. **[lib/core/constants/app_config.dart](lib/core/constants/app_config.dart)**
   - Updated default Supabase values with placeholders

3. **[.env](.env)**
   - Updated with placeholder Supabase credentials

---

## 🚀 How to Run

### Option 1: With Environment Variables (Recommended)
```bash
flutter run -d chrome --dart-define-from-file=.env
```

### Option 2: Simple Run (Uses defaults from app_config.dart)
```bash
flutter run -d chrome
```

---

## ⚙️ Configure Real Supabase Credentials

1. Go to your Supabase project: https://app.supabase.com
2. Navigate to: **Settings** → **API**
3. Copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`

4. Edit [`.env`](.env):
```env
SUPABASE_URL=https://your-actual-project.supabase.co
SUPABASE_ANON_KEY=your-actual-anon-key-here
```

5. Run with environment variables:
```bash
flutter run -d chrome --dart-define-from-file=.env
```

---

## 🧪 What the Splash Screen Does

1. **Shows logo and loading** for 1 second minimum
2. **Checks for existing session**:
   - If valid session exists → Redirects to `/dashboard`
   - If no session or expired → Redirects to `/login`
3. **Validates token expiration** using Supabase session

---

## 🔐 Session Verification Flow

```
App Start → Splash Screen
            ↓
    Check Supabase Session
            ↓
    ┌───────┴───────┐
    ↓               ↓
Valid Session    No Session
    ↓               ↓
/dashboard      /login
```

---

## 📝 Testing Without Real Supabase

The app will now start successfully even with placeholder credentials. However:

- ❌ Login/Register won't work (needs real Supabase project)
- ✅ Navigation and UI will work
- ✅ App won't crash on startup

To fully test authentication, you **must** configure real Supabase credentials.

---

## 🎯 Next Steps

1. ✅ App now initializes Supabase correctly
2. ⚠️ Configure real Supabase credentials to test auth
3. ⚠️ Create a dashboard screen to handle `/dashboard` route
4. ⚠️ Test full flow: Splash → Login → Dashboard

---

## 🐛 Troubleshooting

**Still getting initialization error?**
- Make sure you restart the app completely (stop and run again)
- Clear Flutter cache: `flutter clean && flutter pub get`

**Login not working?**
- Verify Supabase credentials in `.env`
- Check that you're running with: `--dart-define-from-file=.env`
