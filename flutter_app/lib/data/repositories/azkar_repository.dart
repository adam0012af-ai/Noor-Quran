import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import '../models/azkar_models.dart';

class AzkarRepository {
  final MuslimRepository _repository = MuslimRepository();

  Future<List<ZikrItem>> loadAzkar() async {
    final chapters = await _repository.getAzkarChapters(language: Language.ar);
    final grouped = await Future.wait(
      chapters.map((chapter) async {
        final items = await _repository.getAzkarItems(
          language: Language.ar,
          chapterId: chapter.id,
        );
        return items
            .map(
              (item) => ZikrItem(
                id: 'hisn_${chapter.id}_${item.id}',
                category: chapter.categoryName.isEmpty ? 'حصن المسلم' : chapter.categoryName,
                text: item.item,
                repeat: 1,
                reference: [
                  chapter.name,
                  item.reference,
                ].where((e) => e.trim().isNotEmpty).join(' • '),
              ),
            )
            .toList();
      }),
    );
    return grouped.expand((e) => e).toList();
  }
}
