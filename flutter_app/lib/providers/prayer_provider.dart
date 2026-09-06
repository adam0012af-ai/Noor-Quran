import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class PrayerProvider extends ChangeNotifier {
  PrayerTimes? _times;
  Position? _position;
  String? _error;
  bool _loading = false;

  PrayerTimes? get times => _times;
  Position? get position => _position;
  String? get error => _error;
  bool get loading => _loading;

  Future<void> refresh() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('يلزم السماح بالموقع لحساب المواقيت والقبلة.');
      }
      _position = await Geolocator.getCurrentPosition();
      final coords = Coordinates(_position!.latitude, _position!.longitude);
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;
      _times = PrayerTimes.today(coords, params);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
