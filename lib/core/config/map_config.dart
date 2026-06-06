import 'package:flutter/foundation.dart';

/// Google Maps configuration.
///
/// ⚠️ SECURITY: API keys are NOT stored in this file.
/// They must be set via native platform config files:
///   - Android: `android/app/src/main/AndroidManifest.xml`
///   - iOS: `ios/Runner/AppDelegate.swift`
///
/// ## Quick Setup Checklist
///
/// [ ] 1. Get API key at https://console.cloud.google.com
/// [ ] 2. Enable Maps SDK for Android (if testing on Android)
/// [ ] 3. Enable Maps SDK for iOS (if testing on iOS)
/// [ ] 4. Enable billing for the project
/// [ ] 5. Restrict the API key to your app:
///       - Android: Add package name + SHA-1 fingerprint
///       - iOS: Add bundle ID
/// [ ] 6. Replace the placeholder keys in:
///       - `android/app/src/main/AndroidManifest.xml`
///       - `ios/Runner/AppDelegate.swift`
/// [ ] 7. Use an emulator with Google Play Services
///
/// ## Verification
///
/// After configuration, clean and rebuild:
///   flutter clean
///   flutter pub get
///   flutter run
///
class MapConfig {
  MapConfig._();

  /// Whether the API key placeholder has been replaced in the config files.
  ///
  /// The placeholder string that ships with the repo.
  static const String _placeholderKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

  /// Checks at compile time if the known placeholder string is still in use.
  ///
  /// Note: This can only detect the default placeholder — if a developer
  /// sets a different invalid key, this check won't catch it.
  ///
  /// For a full list of configured API keys, check:
  ///   - Android: `android/app/src/main/AndroidManifest.xml`
  ///   - iOS: `ios/Runner/AppDelegate.swift`
  static bool get isApiKeyConfigured {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidApiKey != _placeholderKey;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosApiKey != _placeholderKey;
    }
    return false;
  }

  /// The API key for Android (read from AndroidManifest.xml natively).
  /// ⚠️ Set this via your platform config, NOT hardcoded here.
  static const String _androidApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

  /// The API key for iOS (set in AppDelegate.swift).
  /// ⚠️ Set this via your platform config, NOT hardcoded here.
  static const String _iosApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

  /// Human-readable error message for the most likely cause.
  static String get troubleshootingGuide {
    final buffer = StringBuffer();
    buffer.writeln('Google Maps not loading.');
    buffer.writeln('');
    buffer.writeln('Most common causes:');
    buffer.writeln('• API key not set or still a placeholder');
    buffer.writeln('• API key restrictions (package name / SHA-1 / bundle ID)');
    buffer.writeln('• Billing not enabled on Google Cloud project');
    buffer.writeln('• Maps SDK not enabled in Google Cloud Console');
    buffer.writeln('• Emulator without Google Play Services');
    buffer.writeln('');
    buffer.writeln('See: lib/core/config/map_config.dart');
    return buffer.toString();
  }
}
