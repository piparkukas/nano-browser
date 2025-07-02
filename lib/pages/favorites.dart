import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:browser/func/favorites_forming_service.dart';
import 'package:browser/generated/l10n.dart';
import 'package:browser/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesService favoritesService = FavoritesService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await favoritesService.loadFavorites();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _clearAll() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).favs_alert_dialog_title),
        content: Text(S.of(context).favs_alert_dialog_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).history_alert_dialog_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context).history_alert_dialog_acception),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await favoritesService.clearFavorites();
      setState(() {});
    }
  }

  Future<void> _removeFavorite(FavoriteItem item) async {
    await favoritesService.removeFavorite(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).menu_item_button_favorites),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              ),
              onPressed: _clearAll,
              child: Text(
                S.of(context).history_clear_all,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoritesService.favorites.isEmpty
              ? Center(child: Text(S.of(context).favs_no_favs_found, softWrap: true,))
              : ListView.builder(
                  itemCount: favoritesService.favorites.length,
                  itemBuilder: (context, index) {
                    final item = favoritesService.favorites[index];
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.url),
                          leading: IconButton(
                            icon: Icon(Icons.content_copy,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: item.url));
                              AnimatedSnackBar.material(
                                      S
                                          .of(context)
                                          .history_url_has_copied_to_clipboard,
                                      type: AnimatedSnackBarType.info,
                                      borderRadius: BorderRadius.circular(20),
                                      duration: Duration(seconds: 5),
                                      mobileSnackBarPosition:
                                          MobileSnackBarPosition.top)
                                  .show(context);
                            },
                          ),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeFavorite(item);
                                AnimatedSnackBar.material(
                                        S
                                            .of(context)
                                            .favs_item_has_been_deleted,
                                        type: AnimatedSnackBarType.success,
                                        borderRadius: BorderRadius.circular(20),
                                        duration: Duration(seconds: 5),
                                        mobileSnackBarPosition:
                                            MobileSnackBarPosition.top)
                                    .show(context);
                              }),
                          onTap: () {
                            _openUrl(item.url);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _openUrl(String url) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(initialQuery: url),
      ),
    );
  }
}
