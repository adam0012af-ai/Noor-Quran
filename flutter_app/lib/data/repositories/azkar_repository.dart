import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/azkar_models.dart';

class AzkarRepository {
  Future<List<ZikrItem>> loadAzkar() async {
    final raw = await rootBundle.loadString('assets/data/azkar.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    final result = <ZikrItem>[];

    for (final categoryEntry in decoded) {
      final categoryMap = Map<String, dynamic>.from(categoryEntry as Map);
      final category = (categoryMap['category'] ?? 'حصن المسلم').toString();
      final items = (categoryMap['array'] as List<dynamic>? ?? const []);
      for (final itemEntry in items) {
        final item = Map<String, dynamic>.from(itemEntry as Map);
        final id = '${categoryMap['id']}_${item['id']}';
        final text = (item['text'] ?? '').toString().trim();
        if (text.isEmpty) continue;
        final countValue = item['count'];
        final count = countValue is int
            ? countValue
            : int.tryParse(countValue?.toString() ?? '') ?? 1;
        result.add(
          ZikrItem(
            id: id,
            category: category,
            text: text,
            repeat: count <= 0 ? 1 : count,
            reference: null,
          ),
        );
      }
    }

    return result;
  }
}
