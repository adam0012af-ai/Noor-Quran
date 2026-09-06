import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/ad_service.dart';
import '../../providers/app_settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SegmentedButton<ThemeMode>(segments: const [ButtonSegment(value: ThemeMode.system, label: Text('النظام')), ButtonSegment(value: ThemeMode.light, label: Text('فاتح')), ButtonSegment(value: ThemeMode.dark, label: Text('داكن'))], selected: {s.themeMode}, onSelectionChanged: (v) => s.setThemeMode(v.first)),
        const SizedBox(height: 24),
        Text('حجم خط القرآن: ${s.quranFontSize.toInt()}'),
        Slider(min: 20, max: 44, value: s.quranFontSize, onChanged: s.setQuranFontSize),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: () => AdService().showRewarded(onReward: () => s.setSeedColor(const Color(0xFF7C3AED))), icon: const Icon(Icons.palette), label: const Text('شاهد إعلانًا لفتح ثيم بنفسجي')),
      ]),
    );
  }
}
