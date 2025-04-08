import 'package:shared_preferences/shared_preferences.dart';

// class LanguageValidationController {
//   static String? _setLang;
//
//   static String? get setLang => _setLang;
//
//   static Future<void> setLanguage(String lang) async {
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     await sharedPreferences.setString('set_language', lang);
//     _setLang = lang;
//   }
//
//   static Future<void> getLanguage() async {
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     _setLang = sharedPreferences.getString('set_language');
//   }
// }

class LanguageValidationController {
  static String? _setLang;
  static String? get setLang => _setLang;
  static const String defaultLanguage = 'en';

  static Future<void> setLanguage(String lang) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('set_language', lang);
    _setLang = lang;
  }

  static Future<void> getLanguage() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get language with English as default if none is set
    _setLang = sharedPreferences.getString('set_language') ?? defaultLanguage;
  }

  // Initialize default language if none exists
  static Future<void> initializeLanguage() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey('set_language')) {
      await setLanguage(defaultLanguage);
    }
  }
}