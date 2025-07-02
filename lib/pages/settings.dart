// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:browser/func/settings_declarative_service.dart';
import 'package:browser/generated/l10n.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool useDarkTheme = BrowserSettings.useDarkTheme;
  bool useMaterialYou = BrowserSettings.useMaterialYou;
  bool jsEnabled = BrowserSettings.jsEnabled;
  String selectedSearchEngine = BrowserSettings.searchEngine;
  bool doNotTrack = BrowserSettings.doNotTrack;
  String addressBarPosition = BrowserSettings.addressBarPosition;

  bool materialYouAvailable = false;
  bool isLoadingDeviceInfo = true;

  @override
  void initState() {
    super.initState();
    _checkMaterialYouAvailability();
  }

  Future<void> _checkMaterialYouAvailability() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      setState(() {
        materialYouAvailable = androidInfo.version.sdkInt >= 31;
        isLoadingDeviceInfo = false;
      });
    }
  }

  Future<void> _changelogDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Changelog'),
          content: Text('''
- Transition to a modern webview component
- GPU Acceleration support
- Little fixes
- Almost full localize thru intl
- DNT request now works fine
- Clearing cookies now also removes it from web storage
- I gave up on method of downloading files from webview
- A full-fledged changelog appeared :)
'''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingDeviceInfo) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).menu_item_button_settings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                        height: 40,
                        child: Text(S.of(context).settings_general_tab,
                            style: TextStyle(fontSize: 24))),
                  ),
                  SwitchListTile(
                    title: Text(S.of(context).settings_general_js_mode),
                    subtitle: Text(jsEnabled
                        ? S.of(context).settings_general_js_unrestricted
                        : S.of(context).settings_general_js_disabled),
                    value: jsEnabled,
                    onChanged: (value) async {
                      setState(() {
                        jsEnabled = value;
                        BrowserSettings.jsEnabled = value;
                      });
                      await BrowserSettings.saveSettings();
                    },
                  ),
                  SwitchListTile(
                    title: Text(S.of(context).sendDNTRequest),
                    value: doNotTrack,
                    onChanged: (value) async {
                      setState(() => doNotTrack = value);
                      BrowserSettings.doNotTrack = value;
                      await BrowserSettings.saveSettings();
                    },
                  ),
                  ListTile(
                    title: Text(S.of(context).settings_general_search_engine),
                    trailing: DropdownButton<String>(
                      value: selectedSearchEngine,
                      items: const [
                        DropdownMenuItem(
                          value: "google",
                          child: Text("Google"),
                        ),
                        DropdownMenuItem(
                          value: "yandex",
                          child: Text("Yandex"),
                        ),
                        DropdownMenuItem(
                          value: "startpage",
                          child: Text("Startpage"),
                        ),
                        DropdownMenuItem(
                          value: "duckduckgo",
                          child: Text("DuckDuckGo"),
                        ),
                      ],
                      onChanged: (value) async {
                        if (value != null) {
                          setState(() {
                            selectedSearchEngine = value;
                            BrowserSettings.searchEngine = value;
                          });
                          await BrowserSettings.saveSettings();
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(S.of(context).settings_general_clear_cookie),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary),
                      onPressed: () async {
                        await BrowserSettings.clearCookieCache();
                        AnimatedSnackBar.material(
                                S.of(context).settings_cookie_cleared,
                                type: AnimatedSnackBarType.success,
                                borderRadius: BorderRadius.circular(20),
                                duration: Duration(seconds: 5),
                                mobileSnackBarPosition:
                                    MobileSnackBarPosition.top)
                            .show(context);
                      },
                      child: Text(S.of(context).settings_general_clear_button),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                        height: 40,
                        child: Text(S.of(context).settings_appearance_tab,
                            style: TextStyle(fontSize: 24))),
                  ),
                  SwitchListTile(
                    title:
                        Text(S.of(context).settings_appearance_use_dark_theme),
                    value: useDarkTheme,
                    onChanged: (value) async {
                      setState(() {
                        useDarkTheme = value;
                        BrowserSettings.useDarkTheme = value;
                        BrowserSettings.themeNotifier.value =
                            value;
                      });
                      await BrowserSettings.saveSettings();
                    },
                  ),
                  SwitchListTile(
                    title: Text(S.of(context).settings_appearance_use_MY_theme),
                    subtitle: Text(materialYouAvailable
                        ? S.of(context).settings_appearance_MY_available
                        : S.of(context).settings_appearance_MY_not_available),
                    value: useMaterialYou,
                    onChanged: materialYouAvailable
                        ? (value) async {
                            setState(() {
                              useMaterialYou = value;
                              BrowserSettings.useMaterialYou = value;
                              BrowserSettings.materialYouNotifier.value = value;
                            });
                            await BrowserSettings.saveSettings();
                          }
                        : null,
                  ),
                  ListTile(
                    title: Text(
                        S.of(context).settings_appearance_adressbar_position),
                    trailing: DropdownButton<String>(
                      value: addressBarPosition,
                      items: [
                        DropdownMenuItem(
                            value: 'top',
                            child: Text(S
                                .of(context)
                                .settings_appearance_adressbar_pos_top)),
                        DropdownMenuItem(
                            value: 'bottom',
                            child: Text(S
                                .of(context)
                                .setings_appearance_adressbar_pos_bottom)),
                      ],
                      onChanged: (value) async {
                        if (value != null) {
                          setState(() {
                            addressBarPosition = value;
                            BrowserSettings.addressBarPosition = value;
                          });
                          await BrowserSettings.saveSettings();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                        height: 40,
                        child:
                            Text(S.of(context).settings_additional_tab, style: TextStyle(fontSize: 24))),
                  ),
                  ListTile(
                    title: Text('Application version: 2.1.3 '),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary),
                      onPressed: () => _changelogDialog(),
                      child: Text('Changelog'),
                    ),
                  ),
                  ListTile(
                    title: Text('Nano Browser for android'),
                    leading: LottieBuilder.asset('lib/assets/leaf.json'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
