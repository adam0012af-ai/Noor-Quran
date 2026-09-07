import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../data/models/quran_models.dart';
import '../data/repositories/quran_repository.dart';

class QuranProvider extends ChangeNotifier {
  final QuranRepository repository;
  QuranProvider(this.repository);

  List<Surah> _surahs = [];
  bool _loading = false;
  bool _loaded = false;
  String? _error;
  String _query = '';

  List<Surah> get allSurahs => List.unmodifiable(_surahs);
  List<Surah> get surahs => _query.isEmpty
      ? _surahs
      : _surahs.where((s) => s.name.contains(_query) || s.englishName.toLowerCase().contains(_query.toLowerCase()) || s.ayahs.any((a) => a.text.contains(_query))).toList();
  bool get loading => _loading;
  bool get loaded => _loaded;
  String? get error => _error;

  Future<void> load() async {
    if (_loaded || _loading) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _surahs = await repository.loadQuran();
      _loaded = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void search(String value) { _query = value.trim(); notifyListeners(); }
  void clearSearch() { if (_query.isEmpty) return; _query = ''; notifyListeners(); }
  bool isBookmarked(int surah, int ayah) => Hive.box('bookmarks').containsKey('$surah:$ayah');

  Future<void> toggleBookmark(int surah, int ayah) async {
    final box = Hive.box('bookmarks');
    final key = '$surah:$ayah';
    if (box.containsKey(key)) {
      await box.delete(key);
    } else {
      await box.put(key, {'surah': surah, 'ayah': ayah, 'createdAt': DateTime.now().toIso8601String()});
    }
    notifyListeners();
  }
}
