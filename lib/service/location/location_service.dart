import 'package:geolocator/geolocator.dart';
import 'package:bitacora_ejercicios/model/location.dart';

import '../../exception/location_permission_denied_exception.dart';
import '../../exception/location_permission_denied_forever_exception.dart';

class LocationService{
  final GeolocatorPlatform _geolocator;

  LocationService([GeolocatorPlatform? geolocator])
      : _geolocator = geolocator ?? GeolocatorPlatform.instance;

  Future<Location> getCurrentLocation() async {
    LocationPermission permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedForeverException();
    }

    Position position = await _geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return Location(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
    );
  }
}