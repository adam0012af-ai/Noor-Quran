import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/azkar_repository.dart';
import 'data/repositories/quran_repository.dart';
import 'providers/app_settings_provider.dart';
import 'providers/azkar_provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/quran_provider.dart';
import 'presentation/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SafeBootApp());
}

class SafeBootApp extends StatefulWidget {
  const SafeBootApp({super.key});

  @override
  State<SafeBootApp> createState() => _SafeBootAppState();
}

class _SafeBootAppState extends State<SafeBootApp> {
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    try {
      await Hive.initFlutter();
      await Hive.openBox('settings');
      await Hive.openBox('bookmarks');
      await Hive.openBox('counters');
      if (!mounted) return;
      setState(() => _ready = true);
      unawaited(_initializeOptionalServices());
    } catch (e, st) {
      debugPrint('Core boot failed: $e\n$st');
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return const IslamicApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _error == null
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded, size: 64),
                        SizedBox(height: 18),
                        Text('نور', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        SizedBox(height: 18),
                        CircularProgressIndicator(),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 64),
                        const SizedBox(height: 16),
                        const Text('تعذر تهيئة التخزين المحلي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableText(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 18),
                        FilledButton(onPressed: () { setState(() => _error = null); _boot(); }, child: const Text('إعادة المحاولة')),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _initializeOptionalServices() async {
  try { await initializeDateFormatting('ar'); } catch (_) {}
  try { await NotificationService.instance.initialize(); } catch (_) {}
  try { await MobileAds.instance.initialize(); } catch (_) {}
}

class IslamicApp extends StatelessWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider(QuranRepository())),
        ChangeNotifierProvider(create: (_) => AzkarProvider(AzkarRepository())),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, settings, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'نور',
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light(settings.seedColor),
          darkTheme: AppTheme.dark(settings.seedColor),
          themeMode: settings.themeMode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
