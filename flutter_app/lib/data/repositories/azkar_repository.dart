import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/azkar_models.dart';

class AzkarRepository {
  Future<List<ZikrItem>> loadAzkar() async {
    final raw = await rootBundle.loadString('assets/data/azkar.json');
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => ZikrItem.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
