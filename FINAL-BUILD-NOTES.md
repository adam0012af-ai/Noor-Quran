# Build notes for Codex / Android builder

Project: Noor Quran
Package: com.noor.quran
Version: 1.0.0 (10)
Min SDK: 23
Target/Compile SDK: 35

Build command: `./gradlew assembleDebug` (or assembleRelease with your signing config).

Before publishing a release APK/AAB:
1. Configure a release signing keystore; do not change applicationId if update compatibility is required.
2. Test Qibla on a physical phone with location and magnetic sensors.
3. Test notification channels: sound, vibration, silent, quiet-hours and reboot restore.
4. Test at least one online reciter and offline playback after download.
5. Preserve UTF-8 encoding for Arabic source files and assets.
