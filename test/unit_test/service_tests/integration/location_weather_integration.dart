import 'package:flutter_test/flutter_test.dart';
import 'package:bitacora_ejercicios/service/location/location_service.dart';
import 'package:bitacora_ejercicios/service/weather/weather_service.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('LocationService + WeatherService integración', () {
    test('TRF44: Flujo completo ubicación y clima', () async {

      final mockGeolocator = _MockGeolocatorPlatform();

      // Mock de respuesta de la API
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({
          "properties": {
            "timeseries": [
              {
                "time": DateTime.now().toUtc().toIso8601String(),
                "data": {
                  "instant": {
                    "details": {
                      "air_temperature": 10.0,
                      "wind_speed": 2.0,
                    }
                  },
                  "next_6_hours": {
                    "summary": {
                      "symbol_code": "clearsky_day"
                    }
                  }
                }
              }
            ]
          }
        }), 200);
      });

      final locationService = LocationService(mockGeolocator);
      final weatherService = WeatherService(client: mockClient);

      final Location location = await locationService.getCurrentLocation();
      expect(location.latitude, 1.23);
      expect(location.longitude, 4.56);
      expect(location.altitude, 7.89);

      final weatherJson = await weatherService.fetchWeatherData(
        location.latitude,
        location.longitude,
        location.altitude,
      );
      expect(weatherJson['properties'], isNotNull);

      final Weather weather = weatherService.parseTodayWeather(weatherJson);
      expect(weather.weatherStatus, equals('clearsky'));
      expect(weather.currentTemperatureCelsius, equals(10.0));
    });
  });
}

// Mock Geolocator
class _MockGeolocatorPlatform extends GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.always;
  }

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) async {
    return Position(
      latitude: 1.23,
      longitude: 4.56,
      altitude: 7.89,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return LocationPermission.always;
  }
}
