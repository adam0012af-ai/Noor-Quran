import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../providers/quran_provider.dart';
import 'surah_reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final box = Hive.box('bookmarks');
    final entries = box.values.whereType<Map>().toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('الآيات المحفوظة')),
      body: quran.loading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark_border_rounded, size: 72),
                        SizedBox(height: 16),
                        Text('لا توجد آيات محفوظة بعد'),
                        SizedBox(height: 6),
                        Text('اضغط علامة الحفظ بجوار أي آية لتظهر هنا.', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final surahNumber = entry['surah'] as int;
                    final ayahNumber = entry['ayah'] as int;
                    final surah = quran.surahs.firstWhere((s) => s.number == surahNumber);
                    final ayah = surah.ayahs.firstWhere((a) => a.numberInSurah == ayahNumber);
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        leading: CircleAvatar(child: Text('$ayahNumber')),
                        title: Text('${surah.name} • الآية $ayahNumber'),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            ayah.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_left_rounded),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SurahReaderScreen(surah: surah)),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
