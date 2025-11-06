import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _keyTextToSpeech = 'text_to_speech';
  static const String _keyHighContrast = 'high_contrast';
  static const String _keySoundEffects = 'sound_effects';
  static const String _keyHighContrastMode = 'high_contrast_mode'; // 'dark' or 'light'
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyBackgroundFinish = 'background_finish'; // 'basic', 'matte', 'plastic'
  static const String _keyLanguage = 'language'; // Language code like 'en', 'es', etc.

  bool textToSpeech = false;
  bool highContrast = false;
  bool soundEffects = true;
  String highContrastMode = 'dark'; // 'dark' or 'light'
  bool darkMode = false;
  String backgroundFinish = 'basic'; // 'basic', 'matte', 'plastic'
  String language = 'en'; // Default to English

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    textToSpeech = prefs.getBool(_keyTextToSpeech) ?? false;
    highContrast = prefs.getBool(_keyHighContrast) ?? false;
    soundEffects = prefs.getBool(_keySoundEffects) ?? true;
    highContrastMode = prefs.getString(_keyHighContrastMode) ?? 'dark';
    darkMode = prefs.getBool(_keyDarkMode) ?? false;
    backgroundFinish = prefs.getString(_keyBackgroundFinish) ?? 'basic';
    language = prefs.getString(_keyLanguage) ?? 'en';
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTextToSpeech, textToSpeech);
    await prefs.setBool(_keyHighContrast, highContrast);
    await prefs.setBool(_keySoundEffects, soundEffects);
    await prefs.setString(_keyHighContrastMode, highContrastMode);
    await prefs.setBool(_keyDarkMode, darkMode);
    await prefs.setString(_keyBackgroundFinish, backgroundFinish);
    await prefs.setString(_keyLanguage, language);
  }
}

