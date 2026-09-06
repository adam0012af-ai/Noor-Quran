import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_models.dart';

class QuranRepository {
  Future<List<Surah>> loadQuran() async {
    final raw = await rootBundle.loadString('assets/data/quran.json');
    final decoded = jsonDecode(raw);
    final data = decoded is Map<String, dynamic> ? decoded['surahs'] : decoded;
    return (data as List).map((e) => Surah.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
