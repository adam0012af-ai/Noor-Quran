import 'package:flutter/material.dart';
import '../azkar/azkar_screen.dart';
import '../prayer/prayer_screen.dart';
import '../qibla/qibla_screen.dart';
import '../quran/surah_list_screen.dart';
import '../settings/settings_screen.dart';
import '../tasbeeh/tasbeeh_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, IconData, Widget)>[
      ('القرآن الكريم', Icons.menu_book_rounded, const SurahListScreen()),
      ('الأذكار', Icons.auto_awesome_rounded, const AzkarScreen()),
      ('السبحة', Icons.radio_button_checked, const TasbeehScreen()),
      ('مواقيت الصلاة', Icons.schedule_rounded, const PrayerScreen()),
      ('القبلة', Icons.explore_rounded, const QiblaScreen()),
      ('الإعدادات', Icons.settings_rounded, const SettingsScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('نور')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Card(child: InkWell(borderRadius: BorderRadius.circular(12), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.$3)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(item.$2, size: 42), const SizedBox(height: 12), Text(item.$1, style: Theme.of(context).textTheme.titleMedium)])));
        },
      ),
    );
  }
}
