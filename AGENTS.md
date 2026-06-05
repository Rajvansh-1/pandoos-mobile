# PANDOOS MOBILE — SINGLE SOURCE OF TRUTH
# Read this ENTIRE file before doing ANYTHING in this codebase.
# This is the law. Every decision flows from this document.

---

## 🐼 WHAT IS PANDOOS MOBILE?

Pandoos Mobile is the Flutter-based iOS + Android music streaming app that is part of the
larger Pandoos Music ecosystem. It uses YouTube Music as its audio backend (via InnerTube private
API routed through Vercel Edge Functions), Supabase as its cloud backend (auth, playlists,
cross-device sync), and shares the EXACT SAME backend infrastructure as the Web + Desktop app.

### The Pandoos Ecosystem (3 Repos, 1 Backend)

| Repo | Location | Stack | Status |
|---|---|---|---|
| Web + Desktop | `pandoos/` (SIBLING REPO) | Vite + React + Electron | ✅ Active |
| **Mobile** | `pandoos-mobile/` (THIS REPO) | Flutter + Dart | 🚧 Building |
| Android Legacy | `pandoos-android/` (SEPARATE) | Kotlin + SimpMusic fork | 🔴 Abandoned |

> ⚠️ ALL THREE REPOS SHARE THE SAME SUPABASE PROJECT AND VERCEL EDGE FUNCTIONS.
> Never create a separate backend. The backend is universal.

---

## 📁 REPO SETUP — HOW THIS REPO WAS CREATED

```
# This is a BRAND NEW Flutter repo — not a fork of anything.
# Created from scratch:
flutter create pandoos_mobile --org com.pandoos --platforms android,ios
cd pandoos_mobile

# Renamed root folder to pandoos-mobile for consistency
# Location: C:\Users\rajva\OneDrive\Desktop\pandoos-mobile\
```

### Why A New Repo (Not Forking Anything)
- Forking SimpMusic, InnerTune, or any other app introduces GPL licensing obligations,
  spaghetti code, and 100 bugs per 1 edit. We build clean.
- The Panda Emotion Engine, PandaMood system, and the entire UI are original.
- We STUDY open-source apps for patterns but write every line ourselves.
- The only "borrowed" concept is the InnerTube API protocol (a reverse-engineered
  YouTube API — not copyrightable).

---

## 🗂️ COMPLETE PROJECT STRUCTURE

```
pandoos-mobile/
├── AGENTS.md                          ← YOU ARE HERE. Read before anything.
├── pubspec.yaml                       ← All Flutter dependencies
├── analysis_options.yaml              ← Strict Dart linting rules
├── .env.example                       ← All required environment variables
│
├── android/
│   ├── app/
│   │   └── src/main/
│   │       └── AndroidManifest.xml   ← CRITICAL: foreground service config
│   └── build.gradle
│
├── ios/
│   ├── Runner/
│   │   └── Info.plist                ← CRITICAL: Background Modes (Audio)
│   └── Podfile
│
├── assets/
│   ├── rive/
│   │   └── panda.riv                 ← The Panda character (Rive file)
│   ├── fonts/
│   │   ├── ClashDisplay-Bold.ttf     ← Display headings
│   │   ├── PlusJakartaSans-*.ttf     ← Section headers
│   │   └── Inter-*.ttf               ← Body text
│   ├── images/
│   │   ├── logo.png
│   │   └── panda_placeholder.png
│   └── lottie/
│       └── loading.json              ← Loading states
│
└── lib/
    ├── main.dart                     ← Entry point. Calls bootstrap only.
    ├── bootstrap.dart                ← Initializes ALL services before runApp()
    │
    └── src/
        ├── core/                     ← Shared across ALL features
        │   ├── audio/
        │   │   ├── audio_handler.dart         ← THE HEART: just_audio + audio_service
        │   │   ├── audio_service_provider.dart← Riverpod provider for AudioHandler
        │   │   ├── queue_manager.dart         ← ConcatenatingAudioSource wrapper
        │   │   └── stream_resolver.dart       ← YouTube stream URL resolution chain
        │   │
        │   ├── panda/
        │   │   ├── panda_controller.dart      ← Rive state machine controller
        │   │   ├── panda_emotion_engine.dart  ← Mood inference from 5 signals
        │   │   ├── fft_isolate.dart           ← Background FFT amplitude analysis
        │   │   ├── bpm_detector.dart          ← BPM detection from audio stream
        │   │   └── panda_state.dart           ← Mood enum + PandaState model
        │   │
        │   ├── theme/
        │   │   ├── pandoos_theme.dart         ← ThemeData, light+dark (always dark)
        │   │   ├── pandoos_colors.dart        ← Static + dynamic color system
        │   │   ├── pandoos_typography.dart    ← All TextStyle definitions
        │   │   ├── pandoos_shadows.dart       ← Elevation + glow shadows
        │   │   ├── pandoos_gradients.dart     ← Reusable gradient definitions
        │   │   └── dynamic_theme_provider.dart← palette_generator → AnimatedTheme
        │   │
        │   ├── router/
        │   │   ├── app_router.dart            ← go_router config + all routes
        │   │   └── route_names.dart           ← All route name constants
        │   │
        │   ├── network/
        │   │   ├── dio_client.dart            ← Dio + interceptors + retry
        │   │   ├── api_endpoints.dart         ← All Vercel Edge Function URLs
        │   │   └── connectivity_service.dart  ← Online/offline detection
        │   │
        │   ├── supabase/
        │   │   ├── supabase_client.dart       ← Supabase init + singleton
        │   │   └── supabase_realtime.dart     ← Realtime subscription manager
        │   │
        │   ├── errors/
        │   │   ├── pandoos_exception.dart     ← All app-level exception types
        │   │   └── error_handler.dart         ← Global error boundary
        │   │
        │   └── widgets/                       ← Shared UI atoms
        │       ├── panda_widget.dart          ← RiveAnimation widget wrapper
        │       ├── glass_card.dart            ← Glassmorphism card component
        │       ├── neon_button.dart           ← Primary CTA button with glow
        │       ├── mini_player.dart           ← Persistent bottom mini player
        │       ├── album_art_hero.dart        ← Hero-animated album artwork
        │       ├── vinyl_record.dart          ← Spinning vinyl animation
        │       ├── waveform_bar.dart          ← Real-time amplitude visualizer
        │       ├── shimmer_loader.dart        ← Loading skeleton states
        │       └── pandoos_app_bar.dart       ← Custom app bar with blur
        │
        └── features/                          ← Feature-sliced modules
            │                                  ← Each feature is self-contained.
            │                                  ← data/ + domain/ + presentation/
            │
            ├── home/                          ← Home feed screen
            │   ├── data/
            │   │   ├── home_repository.dart
            │   │   └── home_data_source.dart
            │   ├── domain/
            │   │   ├── home_state.dart
            │   │   └── get_home_feed_usecase.dart
            │   └── presentation/
            │       ├── home_screen.dart
            │       ├── mood_rail_widget.dart   ← PandaMood Rail
            │       ├── continue_listening_banner.dart
            │       ├── featured_section.dart
            │       └── home_notifier.dart
            │
            ├── player/                        ← Full-screen Now Playing
            │   ├── data/
            │   │   ├── player_repository.dart
            │   │   └── progress_sync_service.dart ← Writes to now_playing table
            │   ├── domain/
            │   │   ├── player_state.dart
            │   │   ├── play_track_usecase.dart
            │   │   └── update_queue_usecase.dart
            │   └── presentation/
            │       ├── now_playing_screen.dart    ← Full-screen player
            │       ├── panda_player_view.dart     ← Panda + beat visualizer
            │       ├── vinyl_player_view.dart     ← Vinyl alternative player
            │       ├── lyrics_overlay.dart        ← Synced lyrics over player
            │       ├── queue_sheet.dart           ← Bottom sheet queue manager
            │       ├── player_controls.dart       ← Play/pause/skip/seek
            │       └── player_notifier.dart
            │
            ├── search/                        ← Search screen
            │   ├── data/
            │   │   ├── search_repository.dart
            │   │   └── innertube_data_source.dart ← Via Vercel Edge
            │   ├── domain/
            │   │   ├── search_result.dart
            │   │   └── search_tracks_usecase.dart
            │   └── presentation/
            │       ├── search_screen.dart
            │       ├── search_results_list.dart
            │       ├── trending_chips.dart
            │       └── search_notifier.dart
            │
            ├── library/                       ← User library
            │   ├── data/
            │   │   ├── library_repository.dart
            │   │   └── library_data_source.dart   ← Supabase queries
            │   ├── domain/
            │   │   ├── like_track_usecase.dart
            │   │   ├── unlike_track_usecase.dart
            │   │   ├── create_playlist_usecase.dart
            │   │   ├── add_to_playlist_usecase.dart
            │   │   └── get_liked_songs_usecase.dart
            │   └── presentation/
            │       ├── library_screen.dart
            │       ├── liked_songs_screen.dart
            │       ├── playlist_detail_screen.dart
            │       ├── downloads_screen.dart
            │       └── library_notifier.dart
            │
            ├── auth/                          ← Authentication
            │   ├── data/
            │   │   └── auth_repository.dart
            │   ├── domain/
            │   │   ├── pandoos_user.dart
            │   │   ├── sign_in_usecase.dart
            │   │   └── sign_out_usecase.dart
            │   └── presentation/
            │       ├── onboarding_screen.dart
            │       ├── sign_in_screen.dart
            │       └── auth_notifier.dart
            │
            ├── panda_mood/                    ← Panda Emotion + Mood System
            │   ├── data/
            │   │   ├── mood_repository.dart
            │   │   └── behavior_tracker.dart  ← Passive signal collection
            │   ├── domain/
            │   │   ├── mood_state.dart         ← 8 mood enum + energy float
            │   │   ├── infer_mood_usecase.dart ← 5-signal mood engine
            │   │   └── mood_playlist_usecase.dart
            │   └── presentation/
            │       ├── mood_selector_screen.dart
            │       └── mood_notifier.dart
            │
            ├── artist/                        ← Artist pages
            │   ├── data/
            │   │   └── artist_repository.dart
            │   ├── domain/
            │   │   ├── artist.dart
            │   │   ├── follow_artist_usecase.dart
            │   │   └── get_artist_usecase.dart
            │   └── presentation/
            │       ├── artist_screen.dart
            │       └── artist_notifier.dart
            │
            ├── album/                         ← Album pages
            │   ├── data/
            │   │   └── album_repository.dart
            │   ├── domain/
            │   │   └── album.dart
            │   └── presentation/
            │       ├── album_screen.dart
            │       └── album_notifier.dart
            │
            ├── sync/                          ← Cross-device realtime sync
            │   ├── data/
            │   │   └── sync_repository.dart   ← now_playing UPSERT + subscribe
            │   ├── domain/
            │   │   └── now_playing_state.dart
            │   └── presentation/
            │       └── continue_listening_notifier.dart
            │
            ├── lyrics/                        ← Lyrics engine
            │   ├── data/
            │   │   ├── lyrics_repository.dart
            │   │   └── lrclib_data_source.dart← Fetches from lrclib.net
            │   ├── domain/
            │   │   ├── lyrics_line.dart       ← {timestamp, text}
            │   │   └── get_lyrics_usecase.dart
            │   └── presentation/
            │       ├── lyrics_screen.dart
            │       └── lyrics_notifier.dart
            │
            ├── download/                      ← Offline downloads
            │   ├── data/
            │   │   ├── download_repository.dart
            │   │   └── download_manager.dart   ← Hive storage + progress
            │   ├── domain/
            │   │   └── download_track_usecase.dart
            │   └── presentation/
            │       └── download_notifier.dart
            │
            ├── settings/                      ← App settings
            │   └── presentation/
            │       ├── settings_screen.dart
            │       ├── audio_quality_tile.dart
            │       ├── equalizer_screen.dart
            │       ├── sleep_timer_screen.dart
            │       └── theme_settings_tile.dart
            │
            ├── wrapped/                       ← Monthly Pandoos Wrapped
            │   ├── data/
            │   │   └── wrapped_repository.dart
            │   ├── domain/
            │   │   └── generate_wrapped_usecase.dart
            │   └── presentation/
            │       ├── wrapped_screen.dart
            │       └── wrapped_card_widget.dart← Shareable gradient card
            │
            └── profile/                       ← User profile
                ├── data/
                │   └── profile_repository.dart
                └── presentation/
                    ├── profile_screen.dart
                    └── profile_notifier.dart
```

---

## 🔑 ENVIRONMENT VARIABLES

File: `.env` (never commit — add to .gitignore)
Reference: `.env.example`

```env
# Supabase — SAME project as pandoos/ web app
SUPABASE_URL=https://[your-project].supabase.co
SUPABASE_ANON_KEY=[your-anon-key]

# Google OAuth — SAME client ID as web app
GOOGLE_CLIENT_ID=529626065517-rvrjir6ugvkred5ln3vuev30lfnfnsth.apps.googleusercontent.com

# Vercel Edge Functions — SAME deployment as pandoos/ web app
VERCEL_API_BASE_URL=https://[your-deployment].vercel.app

# These NEVER exist in the Flutter app:
# YOUTUBE_API_KEY → server-side only (Vercel Edge)
# UPSTASH_REDIS_*  → server-side only (Vercel Edge)
```

⚠️ CRITICAL: Never put YOUTUBE_API_KEY or UPSTASH credentials in Flutter.
They are only in the Vercel Edge Functions in the `pandoos/` repo.
Use `flutter_dotenv` to load .env file.

---

## 🧰 COMPLETE TECH STACK — EVERY PACKAGE

### pubspec.yaml dependencies (complete)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # ── STATE & ARCHITECTURE ──────────────────────────────
  flutter_riverpod: ^2.5.1          # State management + DI
  riverpod_annotation: ^2.3.5       # Code generation for providers
  go_router: ^14.0.0                # Type-safe routing + deep links

  # ── AUDIO ENGINE ─────────────────────────────────────
  just_audio: ^0.9.40               # Audio playback (HLS, progressive, gapless)
  audio_service: ^0.18.15           # Background service + MediaSession
  audio_session: ^0.1.21            # Audio focus (interruptions, Bluetooth)
  just_waveform: ^0.1.3             # Waveform data for Panda sync

  # ── PANDA EMOTION ENGINE ─────────────────────────────
  rive: ^0.13.0                     # Rive character animation state machine
  flutter_animate: ^4.5.0           # Micro-animations (page transitions, UI)
  flutter_haptic_feedback: ^0.2.0   # Rich haptics (success, error, impact)

  # ── BACKEND ───────────────────────────────────────────
  supabase_flutter: ^2.5.0          # Supabase client (auth, DB, realtime, storage)
  google_sign_in: ^6.2.1            # Google OAuth for Supabase auth

  # ── NETWORKING ────────────────────────────────────────
  dio: ^5.4.3                       # HTTP client
  dio_cache_interceptor: ^3.5.0     # Response caching
  dio_smart_retry: ^6.0.0           # Auto retry with backoff
  connectivity_plus: ^6.0.3         # Network status detection
  flutter_dotenv: ^5.1.0            # Environment variables

  # ── LOCAL STORAGE (OFFLINE FIRST) ────────────────────
  hive_flutter: ^1.1.0              # Fast NoSQL cache (metadata, settings)
  isar_flutter_libs: ^3.1.0         # Typed reactive DB (offline tracks, library)
  isar: ^3.1.0                      # Isar ORM
  path_provider: ^2.1.3             # File system paths

  # ── IMAGES & MEDIA ────────────────────────────────────
  cached_network_image: ^3.3.1      # Image caching with placeholder
  flutter_cache_manager: ^3.3.1     # Underlying cache management
  palette_generator: ^0.3.3         # Extract colors from album art → dynamic theme

  # ── UI & DESIGN ────────────────────────────────────────
  shimmer: ^3.0.0                   # Loading skeleton shimmer effect
  glass_kit: ^3.0.0                 # Glassmorphism BackdropFilter helper
  lottie: ^3.1.0                    # Lottie JSON animations (loading states)
  flutter_svg: ^2.0.10+1            # SVG support for icons/assets
  google_fonts: ^6.2.1              # Clash Display, Inter, Plus Jakarta Sans

  # ── LYRICS ────────────────────────────────────────────
  scrollable_positioned_list: ^0.3.8 # Auto-scroll to active lyrics line

  # ── UTILITIES ─────────────────────────────────────────
  freezed_annotation: ^2.4.1       # Immutable data classes
  json_annotation: ^4.9.0          # JSON serialization
  equatable: ^2.0.5                 # Value equality
  collection: ^1.18.0               # Dart collection utilities
  intl: ^0.19.0                     # Date/time formatting for Wrapped
  share_plus: ^9.0.0                # Share Wrapped card as image
  screenshot: ^3.0.0                # Capture Wrapped card as image
  url_launcher: ^6.3.0              # Open URLs
  package_info_plus: ^8.0.0         # App version info
  device_info_plus: ^10.1.0         # Device name for now_playing.device_name

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.9              # Code generation
  riverpod_generator: ^2.4.0        # Riverpod provider codegen
  freezed: ^2.5.2                   # Immutable class codegen
  json_serializable: ^6.8.0         # JSON codegen
  isar_generator: ^3.1.0            # Isar schema codegen
  flutter_lints: ^4.0.0             # Lint rules
  mockito: ^5.4.4                   # Testing mocks
```

---

## 🎵 CORE DATA TYPES (Dart — mirrors web TypeScript types exactly)

### Track (universal entity — matches web's Track interface)
```dart
@freezed
class Track with _$Track {
  const factory Track({
    required String id,           // equals videoId for YouTube
    required String title,
    required String artist,
    required String albumArt,     // thumbnail URL
    required int duration,        // seconds
    required String videoId,      // YouTube video ID — universal key
    String? channelTitle,
    String? artistId,             // YTM browseId
    String? albumId,              // YTM browseId
    String? streamUrl,            // resolved at runtime, never stored in DB
  }) = _Track;
}
```

### PandoosUser (matches web's PandoosUser)
```dart
@freezed
class PandoosUser with _$PandoosUser {
  const factory PandoosUser({
    required String id,           // Supabase auth user UUID
    required String email,
    required String username,
    String? avatarUrl,
    required String createdAt,
  }) = _PandoosUser;
}
```

### PandaState (mobile-specific — drives Rive)
```dart
enum PandaMood {
  happy,
  melancholy,
  hype,
  focused,
  sleepy,
  heartbreak,
  curious,
  neutral,
}

enum PlaybackMood {
  playing,
  paused,
  buffering,
  error,
  idle,
}

@freezed
class PandaState with _$PandaState {
  const factory PandaState({
    required PandaMood mood,
    required PlaybackMood playback,
    required double energyLevel,    // 0.0 → 1.0 from FFT
    required double bpm,            // detected BPM
    required double amplitude,      // realtime 0.0 → 1.0
  }) = _PandaState;
}
```

### NowPlayingState (synced to Supabase now_playing table)
```dart
@freezed
class NowPlayingState with _$NowPlayingState {
  const factory NowPlayingState({
    required String userId,
    required String videoId,
    required String title,
    required String artist,
    required String albumArt,
    required bool isPlaying,
    required double progress,   // 0.0 → 1.0
    required String deviceName, // always "Mobile" for this app
    required String updatedAt,
  }) = _NowPlayingState;
}
```

---

## 🗄️ SUPABASE DATABASE SCHEMA (AUTHORITATIVE — DO NOT DEVIATE)

Source of truth for schema: `SUPABASE_SETUP_FINAL.sql` in the `pandoos/` sibling repo.
Use identical table names, column names, and types. This schema is shared across all platforms.

### `liked_songs`
```sql
id        uuid  PK
user_id   text  (Supabase auth user ID)
video_id  text  (YouTube videoId)
title     text
artist    text
album_art text
duration  integer (seconds)
liked_at  timestamptz
UNIQUE(user_id, video_id)
```

### `playlists`
```sql
id          uuid  PK
user_id     text
name        text
description text
cover_url   text
is_public   boolean
track_count integer  (auto-updated by trigger)
created_at  timestamptz
updated_at  timestamptz
```

### `playlist_tracks`
```sql
id          uuid  PK
playlist_id uuid  FK → playlists(id) CASCADE
video_id    text
title       text
artist      text
album_art   text
duration    integer
position    bigint  (ordering — NOT array index)
added_at    timestamptz
```

### `followed_artists`
```sql
id            uuid  PK
user_id       text
artist_id     text  (YTM browseId)
name          text
thumbnail_url text
followed_at   timestamptz
UNIQUE(user_id, artist_id)
```

### `now_playing` ← MOST IMPORTANT TABLE FOR MOBILE
```sql
user_id     text  PK  (one row per user — always UPSERT, never INSERT)
video_id    text
title       text
artist      text
album_art   text
is_playing  boolean
progress    float  (0.0 – 1.0)
device_name text   ("Mobile" for this app | "Web" | "Desktop")
updated_at  timestamptz
```

### Supabase Query Rules
- `user_id` always = `supabase.auth.currentUser!.id`
- `video_id` always = YouTube videoId
- `now_playing` → always UPSERT (onConflict: 'user_id')
- `position` in `playlist_tracks` → bigint, use for ordering, not array index
- RLS is DISABLED — filter by user_id in all queries manually

---

## 🔊 AUDIO ARCHITECTURE (3-Isolate Model — Never Touch This Without Reading)

```
┌─────────────────────────────────────────────────────────────────┐
│  ISOLATE 1: UI (Main Thread)                                     │
│  Flutter widgets, Rive animations, navigation, Riverpod state   │
│  Communicates via: audioHandler.playbackState stream            │
│  Rule: NEVER call AudioHandler methods directly from UI state.   │
│        Always go through PlayerNotifier → AudioHandler.          │
├─────────────────────────────────────────────────────────────────┤
│  ISOLATE 2: Audio Service (Background)                           │
│  Class: PandoosAudioHandler extends BaseAudioHandler             │
│  Contains: just_audio Player, ConcatenatingAudioSource (queue)  │
│  Survives: screen lock, minimize, memory pressure               │
│  Controls: MediaSession, lockscreen, notification, BT headsets  │
│  Android: ForegroundService with FOREGROUND_SERVICE_MEDIA_PLAYBACK│
│  iOS: Background Modes → Audio, AirPlay, Picture in Picture     │
├─────────────────────────────────────────────────────────────────┤
│  ISOLATE 3: FFT Compute (Background)                             │
│  Class: FftIsolate                                               │
│  Input: Raw PCM amplitude from just_audio                        │
│  Output: Stream<double> amplitude (60fps) + Stream<double> bpm   │
│  Consumer: PandaController → sets Rive numeric inputs           │
└─────────────────────────────────────────────────────────────────┘
```

### PandoosAudioHandler — Key Methods (never rename these)
```dart
class PandoosAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  // Core playback
  Future<void> playTrack(Track track);
  Future<void> playFromQueue(int index);
  Future<void> addToQueue(Track track);
  Future<void> removeFromQueue(int index);
  Future<void> clearQueue();
  Future<void> reorderQueue(int oldIndex, int newIndex);

  // Controls (called by lockscreen/notification too)
  @override Future<void> play();
  @override Future<void> pause();
  @override Future<void> skipToNext();
  @override Future<void> skipToPrevious();
  @override Future<void> seek(Duration position);
  @override Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode);
  @override Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode);

  // Streams (UI listens to these — never polls)
  Stream<PlaybackState> get playbackState;
  Stream<MediaItem?> get mediaItem;
  Stream<List<MediaItem>> get queue;
  Stream<double> get position;
}
```

### Stream Resolver Chain (StreamResolver class)
```
playTrack(track) called
       ↓
1. CHECK isar offline DB
   → Hit: return local file URI → <50ms ✅
   → Miss: ↓

2. CHECK Upstash Redis via Vercel Edge (/api/stream?cache=true)
   → Hit: return cached stream URL → <100ms ✅
   → Miss: ↓

3. INNERTUBE EXTRACTION via Vercel Edge (/api/stream)
   → Server-side YouTube stream extraction
   → Cache in Redis (6hr TTL)
   → Return URL → <2s ✅

4. ADAPTIVE QUALITY
   → WiFi detected: 256kbps stream
   → 4G: 128kbps stream
   → 3G/weak: 64kbps + show quality badge

5. PREFETCH ORCHESTRATOR (background, non-blocking)
   → While song plays: fetch URLs for next 2 queue items
   → Pre-buffer first 5s of next song via ConcatenatingAudioSource
   → Result: gapless playback (<100ms gap between songs)
```

---

## 🐼 PANDA EMOTION ENGINE (Complete Specification)

### The Rive File: `assets/rive/panda.riv`

The Panda has ONE artboard with 4 independent animation LAYERS running simultaneously:

```
Layer 1 — BREATHING (always running, loops forever)
  Animations: breathe_slow (sleeping/calm), breathe_normal (default)
  Input type: none (auto-loops)
  Speed: controlled by BPM (slow songs = slow breathing)

Layer 2 — PLAYBACK STATE (switches based on AudioService state)
  Animations: playing_bob, paused_look, buffering_tap, error_scratch, idle_wander
  Input: Boolean "isPlaying", Boolean "isBuffering", Boolean "hasError"
  Transition time: 300ms ease

Layer 3 — ENERGY REACTION (continuous, driven by FFT)
  Animations: energy_idle, energy_medium, energy_high, energy_peak
  Input: Number "energyLevel" (0.0 → 1.0, updated at 60fps)
  Trigger: "beatDrop" (one-shot — fires on amplitude spike > 0.85)
  Effect: body physics scale, ear flap speed, jump on beat drop

Layer 4 — MOOD PERSONALITY (switches based on PandaMood enum)
  Animations (one per mood state):
    happy:      cheeks glow, sparkles float, gentle smile
    melancholy: hugs knees, rain cloud, droopy eyes
    hype:       sunglasses appear, confetti burst, fist pump
    focused:    headphones on, "zone" aura ring, still body
    sleepy:     pajamas, zzz bubbles, half-closed eyes
    heartbreak: holds cracked heart, small tears
    curious:    head tilts 30°, question mark bubble, wide eyes
    neutral:    default resting expression
  Input: Number "moodIndex" (0-7 maps to enum)
  Transition time: 500ms ease + flutter_animate crossfade on mood card
```

### Mood Inference Engine (PandaEmotionEngine class)

Reads 5 passive signals. User NEVER manually picks a mood. Ever.

```dart
class PandaEmotionEngine {
  // Signal 1: Time of day
  PandaMood _inferFromTime(DateTime now) {
    final hour = now.hour;
    if (hour >= 6 && hour < 9) return PandaMood.focused;    // Morning
    if (hour >= 9 && hour < 17) return PandaMood.focused;   // Daytime
    if (hour >= 17 && hour < 20) return PandaMood.happy;    // Evening
    if (hour >= 20 && hour < 24) return PandaMood.melancholy; // Night
    return PandaMood.sleepy;                                  // Late night
  }

  // Signal 2: Skip behavior
  // If user skips >3 songs in <10 seconds → PandaMood.curious (searching)

  // Signal 3: Repeat behavior
  // If user repeats same song >2x in session → PandaMood.melancholy (deep resonance)

  // Signal 4: Session energy fingerprint
  // Average BPM of last 5 songs played:
  //   < 80 BPM → melancholy/sleepy
  //   80-110 BPM → happy/focused
  //   > 110 BPM → hype

  // Signal 5: Like velocity
  // >5 likes in 10 minutes → PandaMood.happy (discovery mode)

  // Weighted inference → outputs PandaState
  PandaState inferCurrentState();
}
```

### Rive ↔ Flutter Bridge (PandaController class)
```dart
class PandaController {
  late StateMachineController _riveController;

  // Inputs (updated in real-time)
  late SMINumber energyLevel;    // 0.0 → 1.0 from FFT isolate
  late SMINumber moodIndex;      // 0-7 from PandaEmotionEngine
  late SMIBool isPlaying;        // from AudioService
  late SMIBool isBuffering;      // from AudioService
  late SMIBool hasError;         // from AudioService
  late SMITrigger beatDrop;      // fired when amplitude spikes > 0.85

  // Called 60fps by FFT isolate
  void onAmplitudeUpdate(double amplitude) {
    energyLevel.value = amplitude;
    if (amplitude > 0.85) beatDrop.fire(); // Beat drop reaction
  }

  // Called by PandaEmotionEngine when mood changes
  void onMoodChange(PandaMood mood) {
    moodIndex.value = mood.index.toDouble();
  }
}
```

---

## 🎨 DESIGN SYSTEM (Complete — Every Visual Decision Defined)

### Color System

```dart
// STATIC PALETTE (Pandoos brand — fallback when no album art)
class PandoosColors {
  static const Color background   = Color(0xFF0A0A0F); // Near-black
  static const Color surface      = Color(0xFF13111C); // Dark purple-tinted
  static const Color surfaceHigh  = Color(0xFF1E1A2E); // Cards, elevated surfaces
  static const Color primary      = Color(0xFF9C6ADE); // Pandoos Purple
  static const Color primaryGlow  = Color(0x409C6ADE); // Purple glow (40% opacity)
  static const Color accent       = Color(0xFFFF6B9D); // Pink accent
  static const Color accentGlow   = Color(0x40FF6B9D); // Pink glow
  static const Color text         = Color(0xFFF0EEFF); // Off-white purple tint
  static const Color textMuted    = Color(0xFF8B86A8); // Secondary text
  static const Color textDisabled = Color(0xFF4A4560); // Disabled text
  static const Color error        = Color(0xFFFF5370); // Error red-pink
  static const Color success      = Color(0xFF69F0AE); // Success green
  static const Color divider      = Color(0xFF2A2540); // Subtle dividers
}

// DYNAMIC PALETTE (extracted from current song's album art via palette_generator)
// Updates on every song change with 800ms AnimatedTheme transition
class DynamicPalette {
  final Color dominant;  // Most dominant color → used for background gradient
  final Color vibrant;   // Most vibrant → used for active controls
  final Color muted;     // Muted version → used for surface overlays
  final Color onDynamic; // Readable text color over dominant background
}
```

### Dynamic Theme Rule
- Every screen extracts the current song's album art colors using `palette_generator`
- The dominant color creates a radial gradient overlay on the background (15% opacity max)
- The vibrant color replaces `PandoosColors.primary` for the current song
- Transition: `AnimatedTheme` with 800ms `Curves.easeInOut`
- The Panda's background/glow color also morphs to match
- This is the same behavior as Apple Music's adaptive background — but applied app-wide

### Typography

```dart
class PandoosTypography {
  // Display — track name on Now Playing
  static TextStyle displayLarge = GoogleFonts.clashDisplay(
    fontSize: 32, fontWeight: FontWeight.w700, color: PandoosColors.text,
    letterSpacing: -0.5,
  );

  // Heading — section titles, artist names
  static TextStyle headingLarge = GoogleFonts.plusJakartaSans(
    fontSize: 22, fontWeight: FontWeight.w600, color: PandoosColors.text,
  );
  static TextStyle headingMedium = GoogleFonts.plusJakartaSans(
    fontSize: 18, fontWeight: FontWeight.w600, color: PandoosColors.text,
  );

  // Body — descriptions, metadata, list items
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w400, color: PandoosColors.text,
  );
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, color: PandoosColors.textMuted,
  );
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, color: PandoosColors.textDisabled,
  );

  // Label — buttons, chips, tags
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, color: PandoosColors.text,
    letterSpacing: 0.5,
  );

  // Lyrics — synced lyrics overlay
  static TextStyle lyricsActive = GoogleFonts.plusJakartaSans(
    fontSize: 20, fontWeight: FontWeight.w700, color: PandoosColors.text,
  );
  static TextStyle lyricsInactive = GoogleFonts.plusJakartaSans(
    fontSize: 18, fontWeight: FontWeight.w400, color: PandoosColors.textMuted,
  );
}
```

### Motion Design Rules

Every animation obeys these 3 laws:
1. **Purpose**: No animation exists purely for decoration. Every motion communicates state change.
2. **Physics**: Use spring curves (`Curves.elasticOut`, `Curves.bounceOut`) not linear. Objects have weight.
3. **Restraint**: Maximum 2 simultaneous animations visible at once.

```dart
// STANDARD DURATIONS (use these constants everywhere)
class PandoosDurations {
  static const micro    = Duration(milliseconds: 120);  // Tap feedback
  static const fast     = Duration(milliseconds: 200);  // Button press
  static const normal   = Duration(milliseconds: 300);  // Screen transitions
  static const slow     = Duration(milliseconds: 500);  // Mood transitions
  static const theme    = Duration(milliseconds: 800);  // Album art color morph
  static const panda    = Duration(milliseconds: 0);    // NEVER delay Panda — Rive handles it
}

// STANDARD CURVES
class PandoosCurves {
  static const standard = Curves.easeInOut;
  static const spring   = Curves.elasticOut;       // Button scale feedback
  static const bounce   = Curves.bounceOut;         // Panda jump landing
  static const smooth   = Curves.fastOutSlowIn;    // Page transitions
}
```

### Key UI Component Specs

**Mini Player** (always visible at bottom when a song is loaded)
- Height: 72dp
- Background: `surfaceHigh` + 40% backdrop blur (glassmorphism)
- Left: Album art (48x48, rounded 8dp) + Panda microstate (12x12 overlay in corner)
- Center: Track title (marquee if too long) + artist name
- Right: Like button + Play/Pause button
- Progress: Thin 2dp line at very top of mini player
- Tap: Hero animation expands to full Now Playing screen

**Now Playing Screen** (full screen)
- Background: Album art blurred (sigma: 40) + dark overlay (60%) + dynamic color gradient
- Center: Panda Player OR Vinyl Player (user toggleable via tap)
- Panda Player: Panda fills 60% of screen height, reacting live to audio
- Vinyl Player: Spinning vinyl record (CSS-equivalent transform animation), album art on disc
- Controls: play/pause (64dp), skip (44dp), prev (44dp), shuffle, repeat
- Progress bar: custom with thumb dot, shows buffered region in lighter color
- Lyrics toggle: bottom button opens lyrics overlay as a frosted glass sheet

**PandaMood Rail** (top of Home screen)
- 6 horizontally scrollable "Mood Cards" (84x84dp each)
- Each card: panda emoji illustration + mood label underneath
- Active mood: purple glow border + scale 1.05 + Panda switches personality
- Mood labels: "Late Night", "Beast Mode", "Missing Someone", "Rainy Day", "Morning Rise", "Deep Focus"
- Tap: Mood activates → queue fills with matching songs → Panda changes

**Glass Card** (used everywhere for playlist/album tiles)
- Background: `surfaceHigh` at 60% opacity + BackdropFilter blur (sigma: 12)
- Border: 1dp solid white at 8% opacity
- Radius: 16dp
- Shadow: 0 8dp 32dp black at 24%

---

## 🔮 FEATURES — COMPLETE FUNCTIONAL SPECIFICATION

### 1. Search
- Full-text search via Vercel Edge `/api/search` → InnerTube
- Search results: Songs, Artists, Albums, Playlists (tabbed)
- Search history stored in Hive (last 20 queries)
- Trending searches: fetched from InnerTube trending endpoint
- Tap result: immediate play OR add to queue OR long-press context menu
- Offline search: searches local Hive cache (liked songs + downloaded)

### 2. Now Playing — Panda Mode
- Full-screen panda that physically reacts to the music (see Panda Engine section)
- Album art as background (blurred, dark overlay)
- Panda occupies center 60% of screen
- Beat drops trigger full-body Panda jump (via Rive trigger input)
- Double-tap Panda: randomizes mood manually (with haptic feedback)
- Swipe up from Panda: lyrics overlay slides up

### 3. Now Playing — Vinyl Mode
- Toggle from Panda Mode via top-right icon
- Spinning vinyl record with album art texture on disc face
- Rotation speed: BPM-synced (100 BPM = 1 full rotation per beat)
- Pause: vinyl slows with realistic deceleration animation
- Play: vinyl accelerates with spring ease
- Album art floats behind vinyl (slightly larger, blurred)

### 4. Synced Lyrics
- Source: lrclib.net (free, no API key)
- Fetch endpoint: `/api/track?artist={artist}&title={title}&duration={duration}`
- Fallback: plain unsynced lyrics if no synced version found
- Display: scrollable list, active line highlighted + scaled 1.1 + white color
- Auto-scroll: `ScrollablePositionedList` jumps to active line smoothly
- Karaoke mode: word-by-word highlight (if LRC format supports it)
- Lyrics overlay: 80% frosted glass sheet over Now Playing
- Works in both Panda and Vinyl player modes

### 5. Queue Manager
- Accessible via swipe-up gesture from Now Playing controls area
- Shows: current song (highlighted), upcoming queue, history (previous songs)
- Drag to reorder: `ReorderableListView`
- Swipe to remove: dismissible tiles
- "Add to queue" available from: search results, library, artist pages, album pages
- Smart Queue mode: auto-inserts bridge tracks between mood-mismatched songs (can disable)

### 6. Liked Songs (Heart System)
- Heart button: on Now Playing, mini player, search results, list tiles
- Tap: immediately writes to `liked_songs` Supabase table
- Optimistic update: UI updates instantly, Supabase confirms in background
- If offline: queued to sync when connection restored
- Heart state synced across ALL platforms via Supabase (Web, Desktop, Mobile all show same liked state)
- Haptic feedback: `HapticFeedback.mediumImpact()` on like, `HapticFeedback.lightImpact()` on unlike

### 7. Playlists
- Create playlist: name + optional description + auto-generated cover (mosaic of first 4 tracks)
- Add to playlist: from any long-press context menu
- Playlist detail: tracklist + cover art + play button + shuffle + edit
- Drag to reorder tracks within playlist (updates `position` bigint in DB)
- Delete playlist: swipe on playlist list OR edit screen
- Public playlists: `is_public = true` → future sharing feature

### 8. Downloads (Offline)
- Download button: on any track, playlist, or album
- Storage: Supabase Storage → download to device via `flutter_cache_manager`
- Progress: real-time download progress in notification + in-app badge
- Storage management: settings screen shows storage used, delete individual downloads
- Offline indicator: badge on downloaded tracks ("Available Offline")
- Offline mode: app detects no internet → plays only from downloads
- Max download quality: user-configurable in settings

### 9. Cross-Device Continue Listening
- Trigger: App opens → checks `now_playing` table for user's last row
- If `updated_at` < 30 minutes ago AND `device_name` ≠ "Mobile":
  → Show banner: "🐼 Continue from {title} at {progress}% on {device}?"
- Banner auto-dismisses after 8 seconds
- Tap: resolves stream URL → starts from exact `progress` position
- Real-time sync: while playing, update `now_playing` every 5 seconds (debounced)
- Updates broadcast to Web + Desktop via Supabase Realtime (they see "playing on Mobile")

### 10. PandaMood Rail
- 6 mood cards on home screen (horizontal scroll)
- Tap mood → Panda switches personality → queue rebuilds with mood-matched songs
- Mood → BPM/energy mapping:
  - Late Night: 60-80 BPM, low energy, melancholy/ambient
  - Beast Mode: 120-160 BPM, high energy, hype
  - Missing Someone: 70-90 BPM, medium energy, melancholy/heartbreak
  - Rainy Day: 65-85 BPM, low energy, melancholy/focused
  - Morning Rise: 95-120 BPM, medium-high energy, happy
  - Deep Focus: 80-100 BPM, medium energy, focused/instrumental
- Active mood persists until: song skip behavior changes it, or user taps another mood

### 11. Artist Pages
- Fetch via InnerTube artist browse endpoint
- Shows: profile image, monthly listeners, top songs, albums, similar artists
- Follow button: writes to `followed_artists` table
- Followed state synced across platforms
- "Radio" button: starts artist-seeded autoplay via InnerTube radio endpoint

### 12. Album Pages
- Fetch via InnerTube album browse endpoint
- Shows: album art (large), release year, tracklist with track numbers and durations
- "Play All" and "Shuffle" buttons
- Long-press track: add to queue, add to playlist, download, share

### 13. Home Feed
- Section 1: "Good morning/evening/night, {name}" greeting
- Section 2: PandaMood Rail (6 mood cards)
- Section 3: Continue Listening banner (if applicable)
- Section 4: Recently played (last 10 unique tracks, from Hive cache)
- Section 5: Liked songs quick access (first 4 as tiles)
- Section 6: "Because you liked {artist}" — InnerTube related artist radio
- Section 7: Your playlists (horizontal scroll)
- Home feed does NOT require internet if user has recently played tracks (Hive offline)

### 14. Sleep Timer
- Settings → Sleep Timer
- Options: 15min, 30min, 45min, 60min, end of current song
- When timer fires: volume fades to 0 over 2 minutes → audio stops
- Panda switches to pajama mode (sleepy PandaMood) as timer counts down
- Wind-down: in last 10 minutes, recommendation engine shifts to lower BPM tracks

### 15. Monthly Wrapped (Pandoos Wrapped)
- Generated on the 1st of each month from `liked_songs` + `now_playing` history
- Stats shown:
  - Total minutes listened this month
  - Top 3 songs + how many times replayed
  - Top 3 artists
  - Your peak listening day + hour
  - Average BPM of your listening sessions
  - Mood distribution (% time in each Panda mood)
  - Emotional insight (e.g., "You were 🐼💜 melancholy on Tuesday nights")
- Visual: gradient card with Panda in mood pose + stats in beautiful typography
- Share: screenshot of card → `share_plus` → saves as PNG or shares directly

### 16. Settings
- Audio Quality: WiFi quality (128/256kbps), Mobile data quality (64/128/256kbps)
- Equalizer: 5-band EQ (just_audio supports custom audio effects via platform channel)
- Crossfade: 0-12 second crossfade between songs
- Normalize Volume: on/off
- Sleep Timer: set timer
- Panda Personality: lock to specific mood vs. auto-detect
- Vinyl vs. Panda Player: default player mode preference
- Download Quality: quality for offline downloads
- Clear Cache: clear Hive + cached images
- Account: profile picture, username, sign out
- About: version, licenses

### 17. Listening Aura (Phase 2 Feature)
- Opt-in social feature
- When two Pandoos users play the same song simultaneously:
  → A tiny ghost Panda (12dp) appears in corner of their Now Playing screen
  → Color of ghost Panda matches other user's current mood color
- Powered by Supabase Realtime: subscribe to `now_playing` WHERE video_id = currentVideoId AND user_id != currentUserId
- Privacy: aura only visible between users who mutually follow each other (future)

---

## 🔗 BACKEND API INTEGRATION

All backend calls go through the Vercel Edge Functions in the `pandoos/` sibling repo.
The Flutter app NEVER calls YouTube APIs directly.

### Vercel Edge Endpoints (defined in `api_endpoints.dart`)

```dart
class ApiEndpoints {
  static const String base = 'https://pandoos.vercel.app';

  // Stream resolution — MOST CRITICAL ENDPOINT
  // GET /api/stream?videoId={videoId}&quality={64|128|256}
  static String stream(String videoId, int quality) =>
    '$base/api/stream?videoId=$videoId&quality=$quality';

  // Search
  // GET /api/search?q={query}&type={songs|artists|albums|playlists}
  static String search(String query, String type) =>
    '$base/api/search?q=${Uri.encodeComponent(query)}&type=$type';

  // Track metadata (for lyrics lookup)
  // GET /api/track?videoId={videoId}
  static String track(String videoId) => '$base/api/track?videoId=$videoId';

  // Artist browse
  // GET /api/artist?browseId={artistBrowseId}
  static String artist(String browseId) => '$base/api/artist?browseId=$browseId';

  // Album browse
  // GET /api/album?browseId={albumBrowseId}
  static String album(String browseId) => '$base/api/album?browseId=$browseId';

  // Trending / Home feed
  // GET /api/trending
  static String get trending => '$base/api/trending';

  // Lyrics (proxied LRCLIB)
  // GET /api/lyrics?title={title}&artist={artist}&duration={seconds}
  static String lyrics(String title, String artist, int duration) =>
    '$base/api/lyrics?title=${Uri.encodeComponent(title)}&artist=${Uri.encodeComponent(artist)}&duration=$duration';
}
```

---

## 🚀 BOOTSTRAP SEQUENCE (critical — order matters)

```dart
// bootstrap.dart — runs before runApp()
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load environment variables FIRST
  await dotenv.load(fileName: '.env');

  // 2. Initialize Hive (fast cache — needed by audio handler)
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('search_history');
  await Hive.openBox('now_playing_cache');

  // 3. Initialize Isar (typed DB — offline library)
  await initIsar(); // opens Track, Playlist, LyricLine schemas

  // 4. Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    realtimeClientOptions: const RealtimeClientOptions(logLevel: RealtimeLogLevel.info),
  );

  // 5. Initialize Audio Service (MUST be before runApp)
  await AudioService.init(
    builder: () => PandoosAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.pandoos.music.audio',
      androidNotificationChannelName: 'Pandoos Music',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: false, // Keep service alive
    ),
  );

  // 6. Run app
  runApp(const ProviderScope(child: PandoosApp()));
}
```

---

## 📱 PLATFORM CONFIGURATION

### Android — AndroidManifest.xml (critical)
```xml
<!-- Required permissions -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
  android:maxSdkVersion="28" />

<!-- Audio service -->
<service android:name="com.ryanheise.audioservice.AudioService"
  android:foregroundServiceType="mediaPlayback"
  android:exported="true">
  <intent-filter>
    <action android:name="android.media.browse.MediaBrowserService" />
  </intent-filter>
</service>

<!-- Media button receiver -->
<receiver android:name="com.ryanheise.audioservice.MediaButtonReceiver"
  android:exported="true">
  <intent-filter>
    <action android:name="android.intent.action.MEDIA_BUTTON" />
  </intent-filter>
</receiver>
```

### iOS — Info.plist (critical)
```xml
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

---

## ⚠️ CRITICAL RULES — ABSOLUTE LAW

1. **Audio engine is sacred.** Never put audio logic in the UI layer. AudioHandler is ONLY
   touched by PlayerNotifier. UI reads streams, never calls AudioHandler directly.

2. **Never call YouTube APIs from Flutter.** All InnerTube calls go through Vercel Edge Functions.
   The YOUTUBE_API_KEY must never appear in Flutter code or assets.

3. **now_playing table is always UPSERT.** Never INSERT into now_playing.
   Always use: `supabase.from('now_playing').upsert({...}, onConflict: 'user_id')`

4. **Supabase schema matches `SUPABASE_SETUP_FINAL.sql` exactly.** Column names,
   table names, and data types must match the authoritative schema in the `pandoos/` repo.

5. **user_id = Supabase auth user UUID** in every DB table. Never use anything else.

6. **video_id = YouTube videoId.** This is the universal cross-platform song identifier.
   This is what links liked songs, playlists, and now_playing across ALL platforms.

7. **device_name = "Mobile"** when this app writes to the `now_playing` table.

8. **position in playlist_tracks is a bigint.** Use it for ordering. Do NOT use array index.

9. **The Panda Rive controller runs on the main thread** but is wrapped in RepaintBoundary.
   Never trigger Riverpod state rebuilds from inside the Rive callback — use a Stream instead.

10. **No mood picker UI.** The app NEVER shows a "how are you feeling?" dropdown.
    Mood is always inferred passively by PandaEmotionEngine.

11. **Offline first.** Every feature that can work offline MUST work offline.
    Hive cache is the source of truth for recently played, settings, and search history.
    Supabase is the source of truth for liked songs, playlists, and sync — but always check
    local cache first.

12. **Dynamic theme ALWAYS transitions with AnimatedTheme at 800ms.** Never hard-switch colors.
    The color morph is a core part of the premium feel.

13. **No forking. No copying open-source code directly.** Study patterns, write original code.

14. **RLS is disabled on Supabase.** All queries MUST manually filter by `user_id`.

15. **Stream URLs are volatile.** Never store stream URLs in Supabase or Isar.
    They expire after ~6 hours. Only store video_id. Always re-resolve stream URLs at playback time.

---

## 🛠️ DEVELOPMENT WORKFLOW

### Running the App
```powershell
# Navigate to this repo
cd C:\Users\rajva\OneDrive\Desktop\pandoos-mobile

# Get dependencies
flutter pub get

# Generate code (Riverpod, Freezed, Isar)
dart run build_runner build --delete-conflicting-outputs

# Run on Android (connected device or emulator)
flutter run

# Run on iOS (requires macOS + Xcode)
flutter run -d ios

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Build iOS IPA (for App Store / TestFlight)
flutter build ipa --release
```

### Code Generation (run after every model change)
```powershell
dart run build_runner build --delete-conflicting-outputs
# Generates: *.g.dart (JSON), *.freezed.dart (immutable models), *.isar.dart (DB schemas)
```

### Testing
```powershell
flutter test                          # Unit tests
flutter test integration_test/        # Integration tests (requires device)
flutter analyze                       # Static analysis
```

---

## 📦 KEY NPM SCRIPTS (for reference — runs from `pandoos/` sibling repo)

These are the Vercel Edge Functions that the Flutter app calls:
```
pandoos/api/stream.ts     ← Stream URL resolver (InnerTube + Redis cache)
pandoos/api/search.ts     ← YouTube Music search
pandoos/api/lyrics.ts     ← LRCLIB proxy
pandoos/api/artist.ts     ← Artist browse
pandoos/api/album.ts      ← Album browse
pandoos/api/trending.ts   ← Trending feed
```
Do NOT duplicate these in this repo. Call the deployed Vercel URL.

---

## 🗺️ EXECUTION PHASES

### Phase 1 — Audio Foundation (Weeks 1-2)
Goal: A song plays. Lockscreen works. Notifications work.
- Flutter project created with all packages installed
- AndroidManifest + Info.plist configured correctly
- PandoosAudioHandler implemented (play/pause/skip/seek)
- StreamResolver chain working (Vercel Edge → just_audio)
- Audio confirmed working on real Android AND iOS device
- Lockscreen controls verified on both platforms

### Phase 2 — Core Loop (Weeks 3-5)
Goal: Full search → play → queue → like loop working.
- Supabase auth (Google OAuth) working
- Search screen calling `/api/search` Edge Function
- Now Playing screen (minimal — no Panda yet)
- Mini player persisting across navigation
- Like button writing to `liked_songs` table
- Queue manager (add, remove, reorder)
- Home screen with basic sections

### Phase 3 — The Panda (Weeks 6-8)
Goal: Panda is alive and reacting. This is what makes it Pandoos.
- Rive file created (panda.riv with 4-layer state machine)
- PandaController connecting Rive to AudioService streams
- FFT isolate computing amplitude from audio stream
- BPM detector running in background
- PandaEmotionEngine inferring mood from 5 passive signals
- Full-screen Panda player showing beat-reactive animation
- Vinyl player alternative (tap to toggle)
- Dynamic theme (palette_generator → AnimatedTheme)

### Phase 4 — Features + Polish (Weeks 9-11)
Goal: Premium feel. Every pixel and interaction is intentional.
- Synced lyrics (LRCLIB + ScrollablePositionedList)
- PandaMood rail on home screen
- Cross-device continue listening (Supabase Realtime)
- Gapless playback (ConcatenatingAudioSource prefetch)
- Crossfade setting
- Downloads / offline mode
- Sleep timer + wind-down mode
- Monthly Wrapped screen
- Artist + album pages
- Haptic feedback on all interactions
- Shared element hero transitions (mini → full player)

### Phase 5 — Launch (Week 12)
- Crash reporting (Sentry)
- Performance profiling (no jank at 60fps on mid-range Android)
- Accessibility (screen reader, font scaling)
- Google Play internal test track
- TestFlight iOS beta
- App Store + Play Store metadata, screenshots, preview video

---

## 📁 FILES TO READ BEFORE MAJOR CHANGES

| Task | Read First |
|---|---|
| Any audio change | `core/audio/audio_handler.dart` |
| Any Panda change | `core/panda/panda_controller.dart` + `core/panda/panda_emotion_engine.dart` |
| Any DB change | `SUPABASE_SETUP_FINAL.sql` in `pandoos/` sibling repo |
| Adding a feature | Match existing feature folder pattern exactly |
| Adding a service | Check if one exists in `core/` first |
| Type definitions | `Track`, `PandoosUser`, `PandaState` — never redefine these |
| Supabase queries | `user_id` filter is MANDATORY on every query |
| Stream URL | Never cache — always resolve fresh via `StreamResolver` |

---

## 🔗 RELATED REPOS

| Repo | Path | Purpose |
|---|---|---|
| Web + Desktop | `C:\Users\rajva\OneDrive\Desktop\pandoos\` | Vite + React + Electron app |
| Mobile (this repo) | `C:\Users\rajva\OneDrive\Desktop\pandoos-mobile\` | Flutter iOS + Android |
| Shared backend | `pandoos/api/` + Supabase project | All platforms share this |

---

*Last updated: June 2026 — This document is the law. Update it when the architecture changes.*
