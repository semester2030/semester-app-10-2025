import 'dart:ui';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  static const String _languageKey = 'app_language';
  static const String _textDirectionKey = 'text_direction';
  bool _isChanging = false;

  @override
  Locale build() {
    _loadLanguage();
    return const Locale('ar', 'AE'); // Default locale - Arabic
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey) ?? 'ar';

      if (savedLanguageCode == 'ar') {
        state = const Locale('ar', 'AE');
      } else {
        state = const Locale('en', 'US');
      }
    } catch (e) {
      // Default to Arabic if there's an error
      state = const Locale('ar', 'AE');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    // Prevent multiple simultaneous language changes
    if (_isChanging) return;

    try {
      _isChanging = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      if (languageCode == 'ar') {
        state = const Locale('ar', 'AE');
        await prefs.setString(_textDirectionKey, 'rtl');
      } else {
        state = const Locale('en', 'US');
        await prefs.setString(_textDirectionKey, 'ltr');
      }

      // Small delay to ensure state changes are processed
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      // Handle error silently or show error message
      rethrow;
    } finally {
      _isChanging = false;
    }
  }

  String get currentLanguageCode => state.languageCode;

  bool get isArabic => state.languageCode == 'ar';

  bool get isEnglish => state.languageCode == 'en';

  Future<TextDirection> getTextDirection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final direction = prefs.getString(_textDirectionKey) ?? 'ltr';
      return direction == 'rtl' ? TextDirection.rtl : TextDirection.ltr;
    } catch (e) {
      return TextDirection.ltr;
    }
  }

  TextDirection get textDirection {
    return state.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}

// Separate provider for text direction to avoid circular dependencies
@riverpod
class TextDirectionNotifier extends _$TextDirectionNotifier {
  @override
  TextDirection build() {
    final locale = ref.watch(languageNotifierProvider);
    return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}
