import 'package:bitacora_ejercicios/exception/location_permission_denied_exception.dart';
import 'package:bitacora_ejercicios/exception/location_permission_denied_forever_exception.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/service/location/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import '../../../mocks/geolocator_mock.mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('LocationService', () {
    late MockGeolocatorPlatform mockGeolocator;
    late LocationService service;

    setUp(() {
      mockGeolocator = MockGeolocatorPlatform();
      service = LocationService(mockGeolocator);
    });

    test('devuelve una ubicación correcta', () async {
      when(mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.always);
      when(mockGeolocator.getCurrentPosition(locationSettings: anyNamed('locationSettings')))
          .thenAnswer((_) async => Position(
        latitude: 1.23,
        longitude: 4.56,
        altitude: 7.89,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
        accuracy: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        timestamp: DateTime.now(),
      ));

      final location = await service.getCurrentLocation();

      expect(location.latitude, 1.23);
      expect(location.longitude, 4.56);
      expect(location.altitude, 7.89);
    });

    test('Seguridad: lanza exepción de permisos denegados', () async {
      when(mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.denied);
      when(mockGeolocator.requestPermission())
          .thenAnswer((_) async => LocationPermission.denied);

      expect(
            () => service.getCurrentLocation(),
        throwsA(isA<LocationPermissionDeniedException>()),
      );

      verifyNever(mockGeolocator.getCurrentPosition(locationSettings: anyNamed('locationSettings')));
    });

    test('Seguridad: lanza exepción de permisos denegados en configuración del dispositivo', () async {
      when(mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.deniedForever);

      expect(
            () => service.getCurrentLocation(),
        throwsA(isA<LocationPermissionDeniedForeverException>()),
      );

      verifyNever(mockGeolocator.getCurrentPosition(locationSettings: anyNamed('locationSettings')));
    });
  });
}
