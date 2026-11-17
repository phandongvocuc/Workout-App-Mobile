# HydroFit — Offline Gym & Fitness Companion

HydroFit is a production-quality, offline-first gym and fitness companion app built for Android with Flutter 3.47 and Material 3.

It requires **no login**, has **no backend or cloud dependencies**, performs **no tracking or analytics**, and persists all your workout plans, schedules, and preferences locally using SQLite and SharedPreferences.

---

## 🌟 Key Features

### 1. Training Tab (Workouts & Exercises)
- **Extensive Exercise Seed Library**: 42+ exercises covering all muscle groups (Chest, Back, Legs, Shoulders, Arms, Core, Full Body) across 4 training styles (Gym, Cardio, Bodyweight, Stretching) and equipment types (Bodyweight, Dumbbell, Barbell, Machine).
- **Interactive Exercise Sheet**: Tap any exercise to view animated form GIF, instructions, target muscle & equipment tags.
- **Built-in Interval/Countdown Timer**: Pure Dart timer with preset chips (15s, 30s, 45s, 60s, 90s) and slider (10s–180s).
- **Background Completion & Fallback Notifications**: If you background the app or switch screens while a timer runs, a high-priority Android notification (`flutter_local_notifications` via `zonedSchedule`) alerts you the moment the exercise ends.
- **External Video Tutorial**: One-tap "Watch on YouTube" launcher using `url_launcher` (external application mode).

### 2. Diet Tab (Nutrition & Meals)
- **25+ Curated Fitness Meals**: Spanning ~190 to ~820 kcal across Breakfast, Lunch, Dinner, and Snacks.
- **Dynamic Calorie Range Filter**: Live `RangeSlider` (100–1000 kcal) plus category filter chips.
- **Nutritional Detail Modal**: Full breakdown with description, total kcal badge, and structured ingredients checklist.

### 3. Schedule Tab (Weekly Workout Alarm & Reminders)
- **Local SQLite Persistence**: Powered by `sqflite` with robust CRUD (`ScheduleRepository`).
- **Clock / Alarm Style Layout**: Grouped by day of the week (Monday through Sunday) with today's indicator.
- **Weekly Repeating Reminders**: Scheduled using `flutter_local_notifications` and `timezone` (`DateTimeComponents.dayOfWeekAndTime`).
- **Auto-Resync**: Automatically resyncs and restores all workout reminders on app launch and device reboot.
- **Permission Awareness**: In-app warning banner if notification permission is denied, with direct navigation to Android system settings.

### 4. Account Tab (Preferences)
- **Appearance**: Seamless switching between Light, Dark, and System theme (persisted in SharedPreferences).
- **Reminder Master Toggle**: Easily enable or disable all workout alarms.
- **Reminder Lead Time**: Configurable lead time before workouts (30 min, 1 hour [default], 6 hours, 12 hours) with automatic schedule resync.
- **About HydroFit**: Offline guarantee with zero remote analytics.

---

## 🚀 How to Run the App

### Prerequisites
- **Flutter**: 3.47.x stable or newer with Dart 3.x
- **Android SDK**: API 34+ (Android SDK 36 supported)
- **Java**: JDK 17+

### Running on Device or Emulator
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Check for connected devices
flutter devices

# 3. Run on your Android device or emulator
flutter run

# 4. Or build debug APK
flutter build apk --debug
```
The output APK will be located at: `build/app/outputs/flutter-apk/app-debug.apk`.

---

## 🏋️ How to Add New Exercises

1. Open `lib/data/seed/exercises.dart`.
2. Add a new `Exercise` entry to `seedExercises`:
```dart
Exercise(
  id: 'chest_incline_pushup',
  name: 'Incline Push-Up',
  muscleGroup: 'Chest',         // Chest, Back, Legs, Shoulders, Arms, Core, Full Body
  exerciseType: 'Bodyweight',   // Gym, Cardio, Bodyweight, Stretching
  equipment: 'Bodyweight',      // Bodyweight, Dumbbell, Barbell, Machine
  gifAssetPath: 'assets/gifs/chest_incline_pushup.gif',
  youtubeUrl: 'https://www.youtube.com/watch?v=...', // optional
  instructions: 'Place hands elevated on a bench or sturdy step. Lower chest and push up.',
),
```

---

## 🥗 How to Add New Meals

1. Open `lib/data/seed/meals.dart`.
2. Add a new `Meal` entry to `seedMeals`:
```dart
Meal(
  id: 'meal_custom_1',
  name: 'Chicken Rice & Greens',
  calories: 520,                // Integer kcal
  category: 'Lunch',            // Breakfast, Lunch, Dinner, Snack
  description: 'Juicy roasted chicken breast with brown rice and steamed broccoli.',
  ingredients: [
    '180g roasted chicken breast',
    '150g brown rice',
    '100g steamed broccoli',
    '1 tsp olive oil',
  ],
),
```

---

## 🖼️ How to Name and Add GIF Files

1. Save your exercise GIF inside the `assets/gifs/` folder.
2. Follow the consistent naming convention:
   ```text
   assets/gifs/{muscleGroup}_{exerciseName}.gif
   ```
   *Examples:*
   - `assets/gifs/chest_pushup.gif`
   - `assets/gifs/back_deadlift.gif`
   - `assets/gifs/legs_squat.gif`
3. Sample bundled GIFs:
   - `push_up.gif`
   - `jumping_jacks.gif`
   - `mountain_climber.gif`
   - `superman.gif`
4. **Graceful Fallback**: If a GIF file is not yet added, HydroFit's `ExerciseImageView` automatically displays an aesthetic target-muscle icon card so the app never throws an image error or crashes.

---

## ⚠️ Known Android Quirks & Configuration

### 1. Core Library Desugaring
- HydroFit uses `java.time` APIs under the hood via the `timezone` package.
- Desugaring is enabled in `android/app/build.gradle.kts`:
  ```kotlin
  compileOptions {
      isCoreLibraryDesugaringEnabled = true
  }
  dependencies {
      coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
  }
  ```

### 2. Android 13+ Notification Permissions (`POST_NOTIFICATIONS`)
- On Android 13 (API 33) and above, notification permission is a runtime permission.
- HydroFit checks this permission gracefully on launch and provides an in-app prompt and direct button to Android System Settings if denied.

### 3. Android 12+ Exact Alarms (`SCHEDULE_EXACT_ALARM`)
- On Android 12+ (API 31+), exact alarms require permission. HydroFit wraps scheduling in a graceful fallback: if exact scheduling fails or permission is revoked by the OS, it falls back to `AndroidScheduleMode.inexactAllowWhileIdle` without crashing.

### 4. Boot Receiver for Alarms
- When an Android device reboots, scheduled alarms in the OS alarm manager are cleared.
- HydroFit registers the `ScheduledNotificationBootReceiver` in `AndroidManifest.xml` and triggers a full resync from the SQLite database upon app initialization.
