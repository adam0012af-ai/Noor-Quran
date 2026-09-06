import 'package:quran/quran.dart' as quran;
import '../models/quran_models.dart';

class QuranRepository {
  Future<List<Surah>> loadQuran() async {
    var absoluteAyah = 0;
    final surahs = <Surah>[];

    for (var surahNumber = 1; surahNumber <= quran.totalSurahCount; surahNumber++) {
      final verseCount = quran.getVerseCount(surahNumber);
      final ayahs = <Ayah>[];
      for (var verseNumber = 1; verseNumber <= verseCount; verseNumber++) {
        absoluteAyah++;
        ayahs.add(
          Ayah(
            number: absoluteAyah,
            numberInSurah: verseNumber,
            juz: quran.getJuzNumber(surahNumber, verseNumber),
            text: quran.getVerse(surahNumber, verseNumber),
          ),
        );
      }

      surahs.add(
        Surah(
          number: surahNumber,
          name: quran.getSurahNameArabic(surahNumber),
          englishName: quran.getSurahNameEnglish(surahNumber),
          revelationType: quran.getPlaceOfRevelation(surahNumber),
          ayahs: ayahs,
        ),
      );
    }

    return surahs;
  }
}
