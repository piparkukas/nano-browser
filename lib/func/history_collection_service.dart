import 'package:shared_preferences/shared_preferences.dart';

class HistoryItem {
  final String url;
  final DateTime timestamp;

  HistoryItem(this.url, this.timestamp);
}

class HistoryService {
  static const String _historyKey = 'browserHistory';

  Future<void> addHistoryItem(String url) async {
    if (!_isValidUrl(url)) return;

    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.removeWhere((item) => item.url == url);
    history.insert(0, HistoryItem(url, DateTime.now()));
    final limitedHistory = history.take(10000).toList();

    await prefs.setStringList(
      _historyKey,
      limitedHistory
          .map((item) => '${item.timestamp.toIso8601String()}|${item.url}')
          .toList(),
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute;
    } catch (_) {
      return false;
    }
  }

  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(_historyKey);

    return items?.map((item) {
          final parts = item.split('|');
          return HistoryItem(
            parts
                .sublist(1)
                .join('|'),
            DateTime.parse(parts[0]),
          );
        }).toList() ??
        [];
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<void> removeHistoryItem(String urlToRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    
    history.removeWhere((item) => item.url == urlToRemove);

    await prefs.setStringList(
      _historyKey,
      history
          .map((item) => '${item.timestamp.toIso8601String()}|${item.url}')
          .toList(),
    );
  }
}
