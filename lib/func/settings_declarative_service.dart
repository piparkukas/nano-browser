import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class BrowserSettings {
  static bool useDarkTheme = false;
  static bool jsEnabled = true;
  static String searchEngine = "google";
  static bool doNotTrack = false;
  static String addressBarPosition = "top";
  static bool useMaterialYou = false;

  static ValueNotifier<bool> themeNotifier = ValueNotifier(useDarkTheme);
  static ValueNotifier<bool> materialYouNotifier = ValueNotifier(useMaterialYou);

  static Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useDarkTheme = prefs.getBool('useDarkTheme') ?? false;
    jsEnabled = prefs.getBool('jsEnabled') ?? true;
    searchEngine = prefs.getString('searchEngine') ?? 'google';
    doNotTrack = prefs.getBool('doNotTrack') ?? false;
    addressBarPosition = prefs.getString('addressBarPosition') ?? 'top';
    useMaterialYou = prefs.getBool('useMaterialYou') ?? true;
    themeNotifier.value = useDarkTheme;
    materialYouNotifier.value = useMaterialYou;
  }

  static Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useDarkTheme', useDarkTheme);
    await prefs.setBool('jsEnabled', jsEnabled);
    await prefs.setString('searchEngine', searchEngine);
    await prefs.setBool('doNotTrack', doNotTrack);
    await prefs.setString('addressBarPosition', addressBarPosition);
    await prefs.setBool('useMaterialYou', useMaterialYou);
  }

  static String get searchEngineUrl {
    switch (searchEngine) {
      case "yandex":
        return "https://yandex.ru/search/?text=";
      case "startpage":
        return "https://www.startpage.com/search?q=";
      case "duckduckgo":
        return "https://duckduckgo.com/?q=";
      case "google":
      default:
        return "https://www.google.com/search?q=";
    }
  }

  static Future<void> clearCookieCache() async {
    await CookieManager.instance().deleteAllCookies();
    await WebStorageManager.instance().deleteAllData();
  }
}
