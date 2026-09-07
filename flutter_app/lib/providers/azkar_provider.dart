import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../data/models/azkar_models.dart';
import '../data/repositories/azkar_repository.dart';

class AzkarProvider extends ChangeNotifier {
  final AzkarRepository repository;
  AzkarProvider(this.repository);

  List<ZikrItem> _items = [];
  bool _loading = false;
  bool _loaded = false;
  String? _error;

  List<ZikrItem> get items => _items;
  bool get loading => _loading;
  bool get loaded => _loaded;
  String? get error => _error;

  Future<void> load() async {
    if (_loaded || _loading) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await repository.loadAzkar();
      _loaded = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<ZikrItem> byCategory(String category) => _items.where((e) => e.category == category).toList();

  int remaining(ZikrItem item) => Hive.box('counters').get('zikr:${item.id}', defaultValue: item.repeat) as int;

  Future<void> decrement(ZikrItem item) async {
    final box = Hive.box('counters');
    final current = remaining(item);
    await box.put('zikr:${item.id}', current > 0 ? current - 1 : item.repeat);
    notifyListeners();
  }
}
