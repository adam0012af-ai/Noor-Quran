import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/banner_ad_widget.dart';
import '../../providers/prayer_provider.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<PrayerProvider>().refresh());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PrayerProvider>();
    final t = p.times;
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة'), actions: [IconButton(onPressed: p.refresh, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        Expanded(child: p.loading ? const Center(child: CircularProgressIndicator()) : p.error != null ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(p.error!, textAlign: TextAlign.center))) : t == null ? const Center(child: Text('لم يتم حساب المواقيت بعد')) : ListView(padding: const EdgeInsets.all(16), children: [_row('الفجر', t.fajr), _row('الشروق', t.sunrise), _row('الظهر', t.dhuhr), _row('العصر', t.asr), _row('المغرب', t.maghrib), _row('العشاء', t.isha)])),
        const Center(child: BannerAdWidget()),
      ]),
    );
  }

  Widget _row(String name, DateTime time) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(title: Text(name), trailing: Text(DateFormat('hh:mm a', 'ar').format(time), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));
}
