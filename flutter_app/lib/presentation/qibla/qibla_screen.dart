import 'dart:math' as math;
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQibla();
  }

  Future<void> _loadQibla() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => _error = 'فعّل خدمة الموقع لتحديد اتجاه القبلة بدقة.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() => _error = 'يلزم السماح بالوصول إلى الموقع لحساب اتجاه القبلة.');
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      final qibla = Qibla(coordinates);
      if (mounted) setState(() => _qiblaDirection = qibla.direction);
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر تحديد الموقع. حاول مرة أخرى.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اتجاه القبلة')),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_off_rounded, size: 64),
                    const SizedBox(height: 16),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _loadQibla,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            )
          : _qiblaDirection == null
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<CompassEvent>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    final heading = snapshot.data?.heading;
                    if (heading == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'هذا الجهاز لا يوفّر حساس بوصلة متوافقًا.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    final relative = (_qiblaDirection! - heading + 360) % 360;
                    final aligned = relative < 4 || relative > 356;
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            aligned ? 'أنت في اتجاه القبلة' : 'حرّك الهاتف حتى يتجه السهم إلى الأعلى',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: 290,
                            height: 290,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3, color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                                const Positioned(top: 14, child: Text('N', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
                                Transform.rotate(
                                  angle: relative * math.pi / 180,
                                  child: Icon(
                                    Icons.navigation_rounded,
                                    size: 130,
                                    color: aligned ? Theme.of(context).colorScheme.primary : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('زاوية القبلة: ${_qiblaDirection!.toStringAsFixed(1)}°'),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
