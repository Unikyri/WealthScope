# Environment Variables - Quick Reference

## ✅ Configuration Complete

Your WealthScope Flutter app is now configured with:

### Backend Connection
- **API URL**: `https://wealthscope-production.up.railway.app`
- **Environment**: `development`

### Supabase Database
- **Project**: `jdgnyhxoagatsdlnbrjo.supabase.co`
- **Auth**: Configured with anon key

---

## 🚀 How to Run

### Option A: Direct Run (Uses defaults from app_config.dart)
```bash
flutter run
```

### Option B: With Environment File (Recommended)
```bash
flutter run --dart-define-from-file=.env
```

### For Specific Devices
```bash
# Android
flutter run -d android --dart-define-from-file=.env

# iOS
flutter run -d ios --dart-define-from-file=.env

# Web
flutter run -d chrome --dart-define-from-file=.env

# Windows
flutter run -d windows --dart-define-from-file=.env
```

---

## 📁 Files Updated

| File | Description | Status |
|------|-------------|--------|
| `.env` | Actual credentials (gitignored) | ✅ Configured |
| `.env.example` | Template for team | ✅ Updated |
| `lib/core/constants/app_config.dart` | Default values | ✅ Updated |
| `ENV_CONFIG.md` | Full documentation | ✅ Created |

---

## 🔑 Environment Variables Available

```env
# Backend
API_BASE_URL=https://wealthscope-production.up.railway.app

# Supabase
SUPABASE_URL=https://jdgnyhxoagatsdlnbrjo.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...

# App Config
ENVIRONMENT=development
ENABLE_DEBUG_LOGS=true
ENABLE_API_LOGS=true
DEFAULT_CURRENCY=USD
API_TIMEOUT_SECONDS=30
```

---

## 🎯 Next Steps

1. **Run the app**: `flutter run`
2. **Test authentication**: Login/register should work with backend
3. **Test API calls**: Asset fetching should connect to Railway backend
4. **Check logs**: Debug logs are enabled for troubleshooting

---

## 🔒 Security Notes

- ✅ `.env` is in `.gitignore`
- ✅ Using `SUPABASE_ANON_KEY` (safe for frontend)
- ⚠️ Never use `SUPABASE_SERVICE_KEY` in mobile app
- ⚠️ Never commit `.env` with real credentials

---

## 📞 Connection Test

The app will connect to:
1. **Auth**: Supabase Auth at `jdgnyhxoagatsdlnbrjo.supabase.co`
2. **API**: Backend API at `wealthscope-production.up.railway.app`
3. **Database**: Supabase PostgreSQL (via backend)

All connections are configured and ready! 🚀
