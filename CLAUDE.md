# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Build Android APK
flutter build apk

# Build iOS
flutter build ios

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Regenerate l10n files (after editing .arb files)
flutter gen-l10n

# Analyze code
flutter analyze

# Get dependencies
flutter pub get
```

## Architecture

This is a Flutter IPTV player app using the **BLoC pattern** (`flutter_bloc`) for state management and **SQLite** (`sqflite`) for local persistence.

### Layer structure

- **`lib/data/`** — Models and repositories. Repositories query SQLite directly via `DBHelper.instance`.
- **`lib/presentation/`** — UI and BLoC. Each feature (playlists, channels) has its own `bloc/` subdirectory with event/state/bloc files, and a `views/` subdirectory for widgets.
- **`lib/common/`** — Shared utilities: `helpers/db_helper.dart` (singleton DB), `theme/`, `widgets/`, `constants/`.
- **`lib/l10n/`** — Auto-generated localization files. Edit the `.arb` source files in this directory, then run `flutter gen-l10n` to regenerate the `app_localizations*.dart` files.

### Database

The SQLite schema is defined in [`assets/db/init_db.sql`](assets/db/init_db.sql) and applied on first launch. Two tables:
- `playlists` — hierarchical (self-referencing `parent_id`), typed by `PlaylistType` enum (url/files/library)
- `channels` — belong to a playlist, support favorites

`DBHelper` is a singleton at `lib/common/helpers/db_helper.dart`. All repository classes get the database via `DBHelper.instance.database`.

### App startup flow

`SplashScreen` → checks locale (language selection) → checks onboarding completion → `MyHomePage`. The `DEBUG_ALWAYS_SHOW_TUTORIAL` flag in `SplashScreen` is currently `true`, forcing the tutorial on every launch.

### Ads

Google Mobile Ads (`google_mobile_ads`) is integrated but **temporarily disabled** — the import and initialization calls are commented out throughout `main.dart`, `splash_screen.dart`, and related files.

### Localization

Supported languages: en, vi, es, fr, hi, pt, de, zh, ar. Add new strings to all `.arb` files in `lib/l10n/`, then run `flutter gen-l10n`.

### Playlist types

`PlaylistType` enum (in `lib/common/constants/constants.dart`) controls how channels are loaded:
- `url` — M3U playlist from a remote URL
- `files` — uploaded M3U file
- `library` — local video files from the device
