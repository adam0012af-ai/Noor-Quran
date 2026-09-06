import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/quran_models.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/quran_provider.dart';

class SurahReaderScreen extends StatelessWidget {
  final Surah surah;
  const SurahReaderScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final quran = context.watch<QuranProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(surah.name), actions: [
        IconButton(onPressed: () => settings.setQuranFontSize((settings.quranFontSize - 2).clamp(20, 44).toDouble()), icon: const Icon(Icons.text_decrease)),
        IconButton(onPressed: () => settings.setQuranFontSize((settings.quranFontSize + 2).clamp(20, 44).toDouble()), icon: const Icon(Icons.text_increase)),
      ]),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: surah.ayahs.length,
        separatorBuilder: (_, __) => const Divider(height: 28),
        itemBuilder: (context, i) {
          final a = surah.ayahs[i];
          final marked = quran.isBookmarked(surah.number, a.numberInSurah);
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [Text('﴿${a.numberInSurah}﴾'), const Spacer(), IconButton(onPressed: () => quran.toggleBookmark(surah.number, a.numberInSurah), icon: Icon(marked ? Icons.bookmark : Icons.bookmark_border))]),
            Text(a.text, textAlign: TextAlign.justify, textDirection: TextDirection.rtl, style: TextStyle(fontSize: settings.quranFontSize, height: 2.1)),
          ]);
        },
      ),
    );
  }
}
