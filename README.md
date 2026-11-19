# Wake Word Translator

A Flutter voice translator: speak in one language, get the translation on screen and read aloud in another.

## Overview

The app listens to the microphone (push-to-talk), transcribes speech on the device with `speech_to_text`, translates the text with the `translator` package (Google Translate), and reads the result aloud with `flutter_tts`. The default direction is English to Turkish, and the two languages can be swapped.

The project is named after a "hey translator" wake word, and the repository includes Picovoice Porcupine model files and a setup guide. In the current code, however, the wake-word flow is **not connected**: `porcupine_flutter` is declared in `pubspec.yaml`, but nothing under `lib/` imports or calls it. Translation is started with the microphone button.

## Features

- Push-to-talk speech recognition (listens up to 10 seconds, stops after a 2 second pause, partial results shown live)
- Text translation between 12 languages: English, Turkish, Spanish, French, German, Italian, Portuguese, Russian, Japanese, Korean, Chinese, Arabic
- Text-to-speech playback of the translation, with a replay action
- Source/target language selectors and a swap button
- State indicator for the pipeline (idle, listening, translating, speaking, error) and runtime microphone permission request
- Dark Material 3 UI with animations and glass-style cards

## Tech stack

| Area | Package |
| --- | --- |
| Framework | Flutter, Dart SDK `^3.8.1` |
| State management | `provider` `^6.1.2` |
| Speech to text | `speech_to_text` `^6.6.0` |
| Translation | `translator` `^1.0.3+1` |
| Text to speech | `flutter_tts` `^3.8.5` |
| Permissions | `permission_handler` `^11.3.1` |
| UI and animation | `flutter_animate` `^4.5.0`, `glassmorphism` `^3.0.0`, `google_fonts` `^6.2.1`, `flutter_staggered_animations` `^1.1.1`, `flutter_svg` `^2.0.10+1`, `lottie` `^3.1.2` |
| Configuration | `flutter_dotenv` `^5.0.2` (the `.env` file is loaded at startup; no keys are read from it yet) |
| Wake word (not wired in) | `porcupine_flutter` `^3.0.2` |

## Project structure

```
wake_word_translator/
  lib/
    main.dart                      # entry point, dark theme, Provider setup
    screens/home_screen.dart       # main screen
    services/translation_service.dart  # speech -> translate -> TTS pipeline and app state
    widgets/                       # mic button, language selector, translation card, status indicator
  assets/audio/                    # Porcupine model files (see notes)
  PORCUPINE_SETUP.md               # Porcupine setup guide (in Turkish)
  android/ ios/ macos/ linux/ windows/ web/
```

`widgets/` contains both plain and `modern_*` variants; the home screen uses the `modern_*` ones.

## Getting started

### Prerequisites

- Flutter SDK with Dart `3.8.1` or newer
- An Android or iOS device or emulator with a microphone and internet access (translation uses an online service)

### Run

```bash
git clone https://github.com/AyqutEfe/WakeWord.git
cd WakeWord/wake_word_translator
```

`pubspec.yaml` lists `.env` as an asset, so create an empty file first (the file is not committed):

```bash
touch .env      # on Windows: type nul > .env
flutter pub get
flutter run
```

Grant the microphone permission when prompted, pick the languages, tap the microphone button and speak.

### Platform permissions

Android declares `RECORD_AUDIO`, `INTERNET`, `ACCESS_NETWORK_STATE`, `WAKE_LOCK`, `FOREGROUND_SERVICE` and `FOREGROUND_SERVICE_MICROPHONE` in `android/app/src/main/AndroidManifest.xml`.

## Wake word status

[`PORCUPINE_SETUP.md`](wake_word_translator/PORCUPINE_SETUP.md) describes enabling the "hey translator" wake word with a Picovoice access key. That guide refers to an `_accessKey` constant in `translation_service.dart`, which does not exist in the current source, so it describes an integration that is not present in this version. Hands-free activation is the natural next step; it would need a Porcupine manager that starts speech recognition when the keyword is detected.

## Notes

- The default `test/widget_test.dart` is the Flutter counter template and does not match the app.
- The Android application id is still the placeholder `com.example.wake_word_translator`.
