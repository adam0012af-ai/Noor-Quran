import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../data/models/quran_models.dart';
import '../data/repositories/quran_repository.dart';

class QuranProvider extends ChangeNotifier {
  final QuranRepository repository;
  QuranProvider(this.repository);

  List<Surah> _surahs = [];
  bool _loading = true;
  String _query = '';

  List<Surah> get surahs => _query.isEmpty
      ? _surahs
      : _surahs.where((s) => s.name.contains(_query) || s.englishName.toLowerCase().contains(_query.toLowerCase()) || s.ayahs.any((a) => a.text.contains(_query))).toList();
  bool get loading => _loading;

  Future<void> load() async {
    try {
      _surahs = await repository.loadQuran();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void search(String value) {
    _query = value.trim();
    notifyListeners();
  }

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
