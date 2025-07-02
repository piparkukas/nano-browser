import 'package:browser/generated/l10n.dart';
import 'package:browser/pages/favorites.dart';
import 'package:browser/pages/history.dart';
import 'package:browser/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMenuButton(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Text('Nano ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Theme.of(context).colorScheme.primary))),
                    SizedBox(
                      child: Text('browser',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                    ),
                    SizedBox(
                      child: LottieBuilder.asset('lib/assets/leaf.json'),
                    ),
                    SizedBox(height: 100)
                  ],
                ),
                SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 16, 30, 0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        border: Border.all(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    S.of(context).home_search_or_enter_address,
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SearchPage(initialQuery: value),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final value = textEditingController.text.trim();
                              if (value.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchPage(initialQuery: value),
                                  ),
                                );
                              }
                            },
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            icon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () async {
                            ClipboardData? clipboardData =
                                await Clipboard.getData('text/plain');
                            if (clipboardData != null) {
                              setState(() {
                                textEditingController.text =
                                    clipboardData.text ?? '';
                              });
                            }
                          },
                          child: Text(S.of(context).home_paste_from_clipboard,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildMenu(),
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      menuChildren: _buildMenuItems(),
      builder: (context, controller, child) {
        return IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  List<Widget> _buildMenuItems() {
    return [
      MenuItemButton(
        onPressed: () => _navigateTo(HistoryPage()),
        leadingIcon: Icon(Icons.history),
        child: Text(S.of(context).menu_item_button_history),
      ),
      MenuItemButton(
        onPressed: () => _navigateTo(FavoritesPage()),
        leadingIcon: const Icon(Icons.favorite),
        child: Text(S.of(context).menu_item_button_favorites),
      ),
      MenuItemButton(
        onPressed: () => _navigateTo(SettingsPage()),
        leadingIcon: Icon(Icons.settings),
        child: Text(S.of(context).menu_item_button_settings),
      ),
    ];
  }

  Widget _buildMenu() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, right: 10),
        child: MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          menuChildren: _buildMenuItems(),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
