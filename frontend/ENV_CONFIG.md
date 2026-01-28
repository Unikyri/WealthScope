# Environment Configuration Guide

## 🎯 Option 1: Direct Edit (Quickest for Hackathon)

The fastest approach for hackathon development:

1. Open [`lib/core/constants/app_config.dart`](lib/core/constants/app_config.dart)
2. Change the `defaultValue` of the constants:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://wealthscope-production.up.railway.app', // 👈 Update this
);
```

✅ **Advantage**: No additional setup required  
⚠️ **Disadvantage**: Cannot easily switch between environments

---

## 🚀 Option 2: Use Environment Variables (Recommended)

### Step 1: Configure the `.env` file

1. Copy [`.env.example`](.env.example) → `.env` (already done)
2. Edit [`.env`](.env) with your actual values:

```env
API_BASE_URL=https://wealthscope-production.up.railway.app
SUPABASE_URL=https://jdgnyhxoagatsdlnbrjo.supabase.co
SUPABASE_ANON_KEY=your-actual-key-here
ENVIRONMENT=development
```

### Step 2: Run with Environment Variables

**For Development:**
```bash
flutter run --dart-define-from-file=.env
```

**For Production:**
```bash
flutter run --dart-define-from-file=.env.production
```

**For Web:**
```bash
flutter run -d chrome --dart-define-from-file=.env
```

### Step 3: (Optional) Configure VS Code

Create or update `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "WealthScope (Dev)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define-from-file=.env"
      ]
    },
    {
      "name": "WealthScope (Prod)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define-from-file=.env.production"
      ]
    }
  ]
}
```

---

## 📝 Current Configuration

Default values are in [`app_config.dart`](lib/core/constants/app_config.dart):

- **API Base URL**: `https://wealthscope-production.up.railway.app` (Railway deployment)
- **Supabase URL**: `https://jdgnyhxoagatsdlnbrjo.supabase.co`
- **Supabase Anon Key**: Configured in `.env`
- **Environment**: `development`

### Available Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `API_BASE_URL` | Backend API endpoint | `https://wealthscope-production.up.railway.app` |
| `SUPABASE_URL` | Supabase project URL | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Supabase public key | `eyJhbGci...` |
| `ENVIRONMENT` | Current environment | `development`, `staging`, `production` |
| `ENABLE_DEBUG_LOGS` | Enable debug logging | `true` / `false` |
| `ENABLE_API_LOGS` | Log API requests | `true` / `false` |
| `DEFAULT_CURRENCY` | Default currency | `USD`, `EUR`, etc. |
| `API_TIMEOUT_SECONDS` | Request timeout | `30` |

---

## 🔒 Security

⚠️ **NEVER** commit the `.env` file with real keys  
✅ The `.gitignore` is already configured to ignore it  
🔑 Only use `SUPABASE_ANON_KEY` in frontend (never use `service_role` key)

---

## 🐛 Troubleshooting

### Variables not loading?

1. Make sure you're using `--dart-define-from-file=.env` when running
2. Check that `.env` file exists in the project root
3. Verify no syntax errors in `.env` (no quotes needed for values)
4. Restart the app completely (hot reload won't update env vars)

### Still seeing placeholder values?

Check the `defaultValue` in [`app_config.dart`](lib/core/constants/app_config.dart) - these are used when env vars aren't provided.

---

## 🎯 Quick Start

For immediate use during hackathon:

1. **Verify `.env` is configured** (already done ✅)
2. **Update default values in `app_config.dart`** (recommended for quick testing)
3. **Or run with:** `flutter run --dart-define-from-file=.env`

The app will work with either approach!
