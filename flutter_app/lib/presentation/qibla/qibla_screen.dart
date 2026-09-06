import 'package:flutter/material.dart';
import 'package:smooth_compass/utils/smooth_compass.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('اتجاه القبلة')),
        body: Center(
          child: SmoothCompass(
            rotationSpeed: 200,
            height: 300,
            width: 300,
            isQiblahCompass: true,
            compassBuilder: (context, snapshot, child) {
              return AnimatedRotation(
                turns: snapshot?.data?.turns ?? 0,
                duration: const Duration(milliseconds: 500),
                child: Stack(alignment: Alignment.center, children: [
                  Container(width: 280, height: 280, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: Theme.of(context).colorScheme.primary))),
                  const Positioned(top: 18, child: Text('N', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                  AnimatedRotation(turns: (snapshot?.data?.qiblahOffset ?? 0) / 360, duration: const Duration(milliseconds: 500), child: const Icon(Icons.navigation_rounded, size: 120)),
                ]),
              );
            },
          ),
        ),
      );
}
