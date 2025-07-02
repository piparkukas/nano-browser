// ignore_for_file: use_build_context_synchronously
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:browser/func/history_collection_service.dart';
import 'package:browser/generated/l10n.dart';
import 'package:browser/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final HistoryService _historyService = HistoryService();
  late Future<List<HistoryItem>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _historyService.getHistory();
  }

  void _refreshHistory() {
    setState(() {
      _historyFuture = _historyService.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).menu_item_button_history),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              ),
              child: Text(S.of(context).history_clear_all,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(S.of(context).history_alert_dialog_title),
                    content: Text(S.of(context).history_alert_dialog_content),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(S.of(context).history_alert_dialog_cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context, true);
                          await _historyService.clearHistory();
                          _refreshHistory();
                        },
                        child:
                            Text(S.of(context).history_alert_dialog_acception),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<HistoryItem>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(S.of(context).histoy_is_empty));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  child: ListTile(
                    title: Text(
                      item.url,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(item.timestamp),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
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
                      icon: const Icon(Icons.delete,
                          size: 20, color: Colors.red),
                      onPressed: () async {
                        await _historyService.removeHistoryItem(item.url);
                        _refreshHistory();
                        AnimatedSnackBar.material(
                                S.of(context).history_item_has_been_deleted,
                                type: AnimatedSnackBarType.success,
                                borderRadius: BorderRadius.circular(20),
                                duration: Duration(seconds: 5),
                                mobileSnackBarPosition:
                                    MobileSnackBarPosition.top)
                            .show(context);
                      },
                    ),
                    onTap: () {
                      _openUrl(item.url);
                    },
                  ),
                ),
              );
            },
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
