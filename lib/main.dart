import 'package:browser/func/settings_declarative_service.dart';
import 'package:browser/generated/l10n.dart';
import 'package:browser/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BrowserSettings.loadSettings();
  runApp(const MainApp());

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return ValueListenableBuilder<bool>(
          valueListenable: BrowserSettings.themeNotifier,
          builder: (context, isDarkTheme, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: BrowserSettings.materialYouNotifier,
              builder: (context, useMaterialYou, _) {
                final lightScheme = (useMaterialYou && lightDynamic != null)
                    ? lightDynamic.harmonized()
                    : ThemeData.from(
                        colorScheme:
                            ColorScheme.fromSeed(seedColor: Colors.blue),
                        useMaterial3: true,
                      ).colorScheme;
                final darkScheme = (useMaterialYou && darkDynamic != null)
                    ? darkDynamic.harmonized()
                    : ThemeData.from(
                        colorScheme: ColorScheme.fromSeed(
                            seedColor: Colors.blue,
                            brightness: Brightness.dark),
                        useMaterial3: true,
                      ).colorScheme;
                return MaterialApp(
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  //locale: Locale('iso-code'),
                  supportedLocales: S.delegate.supportedLocales,
                  title: 'Nano',
                  home: const HomePage(),
                  theme: ThemeData(
                    colorScheme: lightScheme,
                    brightness: Brightness.light,
                    useMaterial3: true,
                  ),
                  darkTheme: ThemeData(
                    colorScheme: darkScheme,
                    brightness: Brightness.dark,
                    useMaterial3: true,
                  ),
                  themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                );
              },
            );
          },
        );
      },
    );
  }
}
