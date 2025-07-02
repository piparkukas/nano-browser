import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteItem {
  final String title;
  final String url;

  FavoriteItem({required this.title, required this.url});

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}

class FavoritesService {
  static const String _favoritesKey = 'favorites';
  final List<FavoriteItem> _favorites = [];

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      List<dynamic> list = jsonDecode(favoritesJson);
      _favorites.clear();
      _favorites.addAll(list.map((e) => FavoriteItem.fromJson(e)));
    }
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favoritesJson =
        jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_favoritesKey, favoritesJson);
  }

  List<FavoriteItem> get favorites => List.unmodifiable(_favorites);

  Future<void> addFavorite(FavoriteItem item) async {
    _favorites.add(item);
    await saveFavorites();
  }

  Future<void> removeFavorite(FavoriteItem item) async {
    _favorites.removeWhere((element) => element.url == item.url);
    await saveFavorites();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await saveFavorites();
  }
}

