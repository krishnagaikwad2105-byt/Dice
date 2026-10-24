import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_strings.dart';

enum AppLanguage {
  english('en', 'English', 'English'),
  hindi('hi', 'हिन्दी', 'Hindi'),
  marathi('mr', 'मराठी', 'Marathi');

  final String code;
  final String nativeName;
  final String englishName;

  const AppLanguage(this.code, this.nativeName, this.englishName);

  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.english;
    for (final lang in AppLanguage.values) {
      if (lang.code == code) return lang;
    }
    return AppLanguage.english; // Strict fallback to English
  }
}

class LocalizationService extends ChangeNotifier {
  static const String _storageKey = 'champal_pani_language_preference';

  static final LocalizationService _instance = LocalizationService._internal();
  static LocalizationService get instance => _instance;

  AppLanguage _currentLanguage = AppLanguage.english;
  bool _initialized = false;

  LocalizationService._internal();

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_storageKey);
      _currentLanguage = AppLanguage.fromCode(savedCode);
    } catch (_) {
      // In case of any storage error, always default safely to English
      _currentLanguage = AppLanguage.english;
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, language.code);
    } catch (_) {}
  }

  String t(String key, [Map<String, String>? params]) {
    return AppStrings.get(_currentLanguage, key, params);
  }
}
