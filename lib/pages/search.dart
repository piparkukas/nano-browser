// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:browser/generated/l10n.dart';
import 'package:browser/func/favorites_forming_service.dart';
import 'package:browser/func/history_collection_service.dart';
import 'package:browser/func/settings_declarative_service.dart';
import 'package:browser/pages/favorites.dart';
import 'package:browser/pages/history.dart';
import 'package:browser/pages/home.dart';
import 'package:browser/pages/settings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;
  const SearchPage({super.key, required this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final HistoryService _historyService = HistoryService();
  late InAppWebViewController webViewController;
  late TextEditingController textEditingController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  WebUri _prepareUrl(String query) {
    final uri = Uri.tryParse(query.trim());
    final isProbablyUrl = uri != null && (uri.hasScheme || query.contains('.') || query.startsWith('www'));
    if (isProbablyUrl) {
      final urlString = uri.hasScheme ? query.trim() : 'https://${query.trim()}';
      return WebUri(urlString);
    }
    final searchUrl = BrowserSettings.searchEngineUrl + Uri.encodeQueryComponent(query.trim());
    return WebUri(searchUrl);
  }

  Future<void> loadInitialUrl(String query) async {
    final webUri = _prepareUrl(query);
    final headers = <String, String>{};
    if (BrowserSettings.doNotTrack) headers['DNT'] = '1';
    await webViewController.loadUrl(
      urlRequest: URLRequest(
        url: webUri,
        headers: headers.isNotEmpty ? headers : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool addressBarTop = BrowserSettings.addressBarPosition == 'top';
    final List<Widget> children = addressBarTop
        ? [
            _buildSearchFieldWidget(),
            _buildLoadingLineWidget(),
            Expanded(child: _buildWebview()),
          ]
        : [
            Expanded(child: _buildWebview()),
            _buildLoadingLineWidget(),
            _buildSearchFieldWidget(),
            const SizedBox(height: 30),
          ];

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Theme.of(context).colorScheme.surface),
      body: WillPopScope(
        onWillPop: () async {
          if (await webViewController.canGoBack()) {
            webViewController.goBack();
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildLoadingLineWidget() {
    return Container(
      height: 2,
      color: Colors.transparent,
      child: isLoading
          ? LinearProgressIndicator(
              color: Theme.of(context).colorScheme.primary)
          : Container(),
    );
  }

  Widget _buildSearchFieldWidget() {
    return Container(
      height: 55,
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _homeButton(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: TextField(
                  controller: textEditingController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(7, 0, 7, 2),
                    border: InputBorder.none,
                    hintText: S.of(context).home_search_or_enter_address,
                  ),
                  onSubmitted: loadInitialUrl,
                ),
              ),
            ),
          ),
          _shareButton(),
          _favoriteButton(),
          _dotMenuButton()
        ],
      ),
    );
  }

  Widget _buildWebview() {
    final headers = <String, String>{};
    if (BrowserSettings.doNotTrack) headers['DNT'] = '1';
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: _prepareUrl(widget.initialQuery),
        headers: headers.isNotEmpty ? headers : null
      ),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(javaScriptEnabled: BrowserSettings.jsEnabled),
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStart: (controller, url) {
        setState(() {
          isLoading = true;
          textEditingController.text = url.toString();
        });
      },
      onLoadStop: (controller, url) async {
        if (url != null) {
          await _historyService.addHistoryItem(url.toString());
        }
        setState(() => isLoading = false);
      },
    );
  }

  Widget _homeButton() {
    return IconButton(
      onPressed: () => Navigator.pop(
          context, MaterialPageRoute(builder: (_) => const HomePage())),
      color: Theme.of(context).colorScheme.onSurface,
      icon: const Icon(Icons.home),
    );
  }

  Widget _shareButton() {
    return IconButton(
      onPressed: () async {
        final url = await webViewController.getUrl();
        if (url != null) await Share.share(url.toString());
      },
      icon: const Icon(Icons.share),
    );
  }

  Widget _favoriteButton() {
    return IconButton(
      icon: const Icon(Icons.favorite),
      onPressed: () async {
        final url = await webViewController.getUrl();
        if (url != null) _onAddToFavorites(url.toString());
      },
    );
  }

  Future<void> _onAddToFavorites(String url) async {
    showDialog<String>(
      context: context,
      builder: (context) {
        String title = '';
        return AlertDialog(
          title: Text(S.of(context).search_add_to_favs),
          content: TextField(
            decoration:
                InputDecoration(labelText: S.of(context).search_name_this_page),
            onChanged: (value) => title = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).history_alert_dialog_cancel),
            ),
            TextButton(
              onPressed: () async {
                if (title.isNotEmpty) {
                  final item = FavoriteItem(title: title, url: url);
                  final service = FavoritesService();
                  await service.loadFavorites();
                  await service.addFavorite(item);
                  Navigator.pop(context);
                  AnimatedSnackBar.material(
                    S.of(context).search_added_to_favs,
                    type: AnimatedSnackBarType.success,
                    borderRadius: BorderRadius.circular(20),
                    duration: const Duration(seconds: 5),
                    mobileSnackBarPosition: MobileSnackBarPosition.top,
                  ).show(context);
                }
              },
              child: Text(S.of(context).history_alert_dialog_acception),
            ),
          ],
        );
      },
    );
  }

  Widget _dotMenuButton() {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),
      ),
      menuChildren: [
        Wrap(
          children: [
            _navButton(Icons.arrow_back, () => webViewController.goBack()),
            _navButton(
                Icons.arrow_forward, () => webViewController.goForward()),
            _navButton(Icons.replay_outlined, () => webViewController.reload()),
            _navButton(Icons.copy, () async {
              final url = await webViewController.getUrl();
              if (url != null) {
                await Clipboard.setData(ClipboardData(text: url.toString()));
                AnimatedSnackBar.material(
                  S.of(context).history_url_has_copied_to_clipboard,
                  type: AnimatedSnackBarType.info,
                  borderRadius: BorderRadius.circular(20),
                  duration: const Duration(seconds: 5),
                  mobileSnackBarPosition: MobileSnackBarPosition.top,
                ).show(context);
              }
            }),
          ],
        ),
        MenuItemButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HistoryPage())),
          leadingIcon: const Icon(Icons.history),
          child: Text(S.of(context).menu_item_button_history),
        ),
        MenuItemButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const FavoritesPage())),
          leadingIcon: const Icon(Icons.favorite),
          child: Text(S.of(context).menu_item_button_favorites),
        ),
        MenuItemButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SettingsPage())),
          leadingIcon: const Icon(Icons.settings),
          child: Text(S.of(context).menu_item_button_settings),
        ),
      ],
      builder: (_, controller, __) => IconButton(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        color: Theme.of(context).colorScheme.onSurface,
        icon: const Icon(Icons.more_vert),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: MenuItemButton(
        onPressed: onPressed,
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
