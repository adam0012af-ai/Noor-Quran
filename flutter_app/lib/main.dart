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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage is part of the core offline experience, so it is prepared
  // before rendering the app. Optional platform services are deliberately not
  // allowed to block startup.
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('bookmarks');
  await Hive.openBox('counters');

  runApp(const IslamicApp());

  // Never let ads, notification plugins, or locale preparation crash startup.
  unawaited(_initializeOptionalServices());
}

Future<void> _initializeOptionalServices() async {
  try {
    await initializeDateFormatting('ar');
  } catch (e, st) {
    debugPrint('Arabic date formatting init failed: $e\n$st');
  }

  try {
    await NotificationService.instance.initialize();
  } catch (e, st) {
    debugPrint('Notification initialization failed: $e\n$st');
  }

  try {
    await MobileAds.instance.initialize();
  } catch (e, st) {
    debugPrint('Mobile Ads initialization failed: $e\n$st');
  }
}

class IslamicApp extends StatelessWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider(QuranRepository())..load()),
        ChangeNotifierProvider(create: (_) => AzkarProvider(AzkarRepository())..load()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
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
          );
        },
      ),
    );
  }
}
