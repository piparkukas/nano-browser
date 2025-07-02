// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `search or enter address`
  String get home_search_or_enter_address {
    return Intl.message(
      'search or enter address',
      name: 'home_search_or_enter_address',
      desc: '',
      args: [],
    );
  }

  /// `paste from clipboard`
  String get home_paste_from_clipboard {
    return Intl.message(
      'paste from clipboard',
      name: 'home_paste_from_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Error loading news: `
  String get home_error_loading_news {
    return Intl.message(
      'Error loading news: ',
      name: 'home_error_loading_news',
      desc: '',
      args: [],
    );
  }

  /// `No news available`
  String get home_no_news_available {
    return Intl.message(
      'No news available',
      name: 'home_no_news_available',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get menu_item_button_history {
    return Intl.message(
      'History',
      name: 'menu_item_button_history',
      desc: '',
      args: [],
    );
  }

  /// `Downloads`
  String get menu_item_button_downloads {
    return Intl.message(
      'Downloads',
      name: 'menu_item_button_downloads',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get menu_item_button_favorites {
    return Intl.message(
      'Favorites',
      name: 'menu_item_button_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get menu_item_button_settings {
    return Intl.message(
      'Settings',
      name: 'menu_item_button_settings',
      desc: '',
      args: [],
    );
  }

  /// `Clear all`
  String get history_clear_all {
    return Intl.message(
      'Clear all',
      name: 'history_clear_all',
      desc: '',
      args: [],
    );
  }

  /// `History is empty`
  String get histoy_is_empty {
    return Intl.message(
      'History is empty',
      name: 'histoy_is_empty',
      desc: '',
      args: [],
    );
  }

  /// `URL has copied to clipboard!`
  String get history_url_has_copied_to_clipboard {
    return Intl.message(
      'URL has copied to clipboard!',
      name: 'history_url_has_copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Item has been deleted from history!`
  String get history_item_has_been_deleted {
    return Intl.message(
      'Item has been deleted from history!',
      name: 'history_item_has_been_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Deleting browsing data`
  String get history_alert_dialog_title {
    return Intl.message(
      'Deleting browsing data',
      name: 'history_alert_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your browsing data? This action cannot be undone.`
  String get history_alert_dialog_content {
    return Intl.message(
      'Are you sure you want to delete your browsing data? This action cannot be undone.',
      name: 'history_alert_dialog_content',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get history_alert_dialog_cancel {
    return Intl.message(
      'Cancel',
      name: 'history_alert_dialog_cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get history_alert_dialog_acception {
    return Intl.message(
      'OK',
      name: 'history_alert_dialog_acception',
      desc: '',
      args: [],
    );
  }

  /// `Add to favorites`
  String get search_add_to_favs {
    return Intl.message(
      'Add to favorites',
      name: 'search_add_to_favs',
      desc: '',
      args: [],
    );
  }

  /// `Name this page for saving`
  String get search_name_this_page {
    return Intl.message(
      'Name this page for saving',
      name: 'search_name_this_page',
      desc: '',
      args: [],
    );
  }

  /// `Added to favorites`
  String get search_added_to_favs {
    return Intl.message(
      'Added to favorites',
      name: 'search_added_to_favs',
      desc: '',
      args: [],
    );
  }

  /// `Deleting favorites data`
  String get favs_alert_dialog_title {
    return Intl.message(
      'Deleting favorites data',
      name: 'favs_alert_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your favorites data? This action cannot be undone.`
  String get favs_alert_dialog_content {
    return Intl.message(
      'Are you sure you want to delete your favorites data? This action cannot be undone.',
      name: 'favs_alert_dialog_content',
      desc: '',
      args: [],
    );
  }

  /// `No favorites added yet`
  String get favs_no_favs_found {
    return Intl.message(
      'No favorites added yet',
      name: 'favs_no_favs_found',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get settings_general_tab {
    return Intl.message(
      'General',
      name: 'settings_general_tab',
      desc: '',
      args: [],
    );
  }

  /// `JavaScript Mode`
  String get settings_general_js_mode {
    return Intl.message(
      'JavaScript Mode',
      name: 'settings_general_js_mode',
      desc: '',
      args: [],
    );
  }

  /// `unrestricted`
  String get settings_general_js_unrestricted {
    return Intl.message(
      'unrestricted',
      name: 'settings_general_js_unrestricted',
      desc: '',
      args: [],
    );
  }

  /// `disabled`
  String get settings_general_js_disabled {
    return Intl.message(
      'disabled',
      name: 'settings_general_js_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Search engine`
  String get settings_general_search_engine {
    return Intl.message(
      'Search engine',
      name: 'settings_general_search_engine',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get settings_appearance_tab {
    return Intl.message(
      'Appearance',
      name: 'settings_appearance_tab',
      desc: '',
      args: [],
    );
  }

  /// `Use dark theme across app`
  String get settings_appearance_use_dark_theme {
    return Intl.message(
      'Use dark theme across app',
      name: 'settings_appearance_use_dark_theme',
      desc: '',
      args: [],
    );
  }

  /// `Use MaterialYou color scheme`
  String get settings_appearance_use_MY_theme {
    return Intl.message(
      'Use MaterialYou color scheme',
      name: 'settings_appearance_use_MY_theme',
      desc: '',
      args: [],
    );
  }

  /// `MaterialYou available`
  String get settings_appearance_MY_available {
    return Intl.message(
      'MaterialYou available',
      name: 'settings_appearance_MY_available',
      desc: '',
      args: [],
    );
  }

  /// `MaterialYou not available for your device`
  String get settings_appearance_MY_not_available {
    return Intl.message(
      'MaterialYou not available for your device',
      name: 'settings_appearance_MY_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Address bar position`
  String get settings_appearance_adressbar_position {
    return Intl.message(
      'Address bar position',
      name: 'settings_appearance_adressbar_position',
      desc: '',
      args: [],
    );
  }

  /// `top`
  String get settings_appearance_adressbar_pos_top {
    return Intl.message(
      'top',
      name: 'settings_appearance_adressbar_pos_top',
      desc: '',
      args: [],
    );
  }

  /// `bottom`
  String get setings_appearance_adressbar_pos_bottom {
    return Intl.message(
      'bottom',
      name: 'setings_appearance_adressbar_pos_bottom',
      desc: '',
      args: [],
    );
  }

  /// `Item has been deleted from favorites!`
  String get favs_item_has_been_deleted {
    return Intl.message(
      'Item has been deleted from favorites!',
      name: 'favs_item_has_been_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Clear web cookie`
  String get settings_general_clear_cookie {
    return Intl.message(
      'Clear web cookie',
      name: 'settings_general_clear_cookie',
      desc: '',
      args: [],
    );
  }

  /// `Cookie cleared successfully!`
  String get settings_cookie_cleared {
    return Intl.message(
      'Cookie cleared successfully!',
      name: 'settings_cookie_cleared',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get settings_general_clear_button {
    return Intl.message(
      'Clear',
      name: 'settings_general_clear_button',
      desc: '',
      args: [],
    );
  }

  /// `Send "Do Not Track" request`
  String get sendDNTRequest {
    return Intl.message(
      'Send "Do Not Track" request',
      name: 'sendDNTRequest',
      desc: '',
      args: [],
    );
  }

  /// `Additional`
  String get settings_additional_tab {
    return Intl.message(
      'Additional',
      name: 'settings_additional_tab',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
