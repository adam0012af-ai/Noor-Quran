import 'package:flutter/material.dart';
import '../azkar/azkar_screen.dart';
import '../prayer/prayer_screen.dart';
import '../qibla/qibla_screen.dart';
import '../quran/bookmarks_screen.dart';
import '../quran/surah_list_screen.dart';
import '../settings/settings_screen.dart';
import '../tasbeeh/tasbeeh_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = <_HomeItem>[
      const _HomeItem('القرآن الكريم', '١١٤ سورة كاملة', Icons.menu_book_rounded, SurahListScreen()),
      const _HomeItem('الأذكار', 'حصن المسلم', Icons.auto_awesome_rounded, AzkarScreen()),
      const _HomeItem('مواقيت الصلاة', 'حسب موقعك', Icons.schedule_rounded, PrayerScreen()),
      const _HomeItem('اتجاه القبلة', 'بوصلة دقيقة', Icons.explore_rounded, QiblaScreen()),
      const _HomeItem('السبحة الرقمية', 'عداد محفوظ', Icons.radio_button_checked_rounded, TasbeehScreen()),
      const _HomeItem('المحفوظات', 'آياتك المفضلة', Icons.bookmarks_rounded, BookmarksScreen()),
      const _HomeItem('الإعدادات', 'المظهر والخط', Icons.tune_rounded, SettingsScreen()),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.nights_stay_rounded, color: scheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('نور', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                          Text('القرآن • الأذكار • الصلاة • القبلة', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'الإعدادات',
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [scheme.primary, scheme.tertiary],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: .18), blurRadius: 24, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 34),
                      const SizedBox(height: 18),
                      const Text('رفيقك اليومي للقرآن والذكر والصلاة', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800, height: 1.35)),
                      const SizedBox(height: 8),
                      Text('المحتوى الأساسي يعمل بدون إنترنت', style: TextStyle(color: Colors.white.withValues(alpha: .88), fontSize: 14)),
                      const SizedBox(height: 18),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: scheme.primary),
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SurahListScreen())),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('ابدأ القراءة'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('الخدمات', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.12,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.screen)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(14)),
                              child: Icon(item.icon, color: scheme.onSecondaryContainer),
                            ),
                            const Spacer(),
                            Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            Text(item.subtitle, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _HomeItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;
  const _HomeItem(this.title, this.subtitle, this.icon, this.screen);
}
