import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quran_provider.dart';
import 'surah_reader_screen.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: Consumer<QuranProvider>(builder: (context, quran, _) {
        if (quran.loading) return const Center(child: CircularProgressIndicator());
        return Column(children: [
          Padding(padding: const EdgeInsets.all(12), child: TextField(onChanged: quran.search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث باسم السورة أو داخل الآيات', border: OutlineInputBorder()))),
          Expanded(child: ListView.separated(itemCount: quran.surahs.length, separatorBuilder: (_, __) => const Divider(height: 1), itemBuilder: (context, i) {
            final s = quran.surahs[i];
            return ListTile(leading: CircleAvatar(child: Text('${s.number}')), title: Text(s.name), subtitle: Text('${s.ayahs.length} آية • ${s.revelationType}'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SurahReaderScreen(surah: s))));
          }))
        ]);
      }),
    );
  }
}
