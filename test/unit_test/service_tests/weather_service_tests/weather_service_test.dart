import 'dart:convert';

import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/service/weather/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('WeatherService', () {
    late WeatherService service;
    late MockClient mockClient;

    final mockApiResponse = {
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
          },
          {
            "time": DateTime.now().toUtc().toIso8601String(),
            "data": {
              "instant": {
                "details": {
                  "air_temperature": 8.0,
                  "wind_speed": 3.0,
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
    };

    setUp(() {
      mockClient = MockClient((request) async {
        if (request.url.queryParameters['lat'] == null ||
            request.url.queryParameters['lon'] == null) {
          return http.Response('Bad Request', 400);
        }
        return http.Response(jsonEncode(mockApiResponse), 200);
      });
      service = WeatherService(client: mockClient);
    });

    test('Devuelve datos válidos con altitud', () async {
      final result = await service.fetchWeatherData(-38.81, -72.60, 100);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['properties'], isNotNull);
    });

    test('Devuelve datos válidos sin altitud', () async {
      final result = await service.fetchWeatherData(-38.81, -72.60, 0);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('Falla sin latitud', () async {
      await expectLater(
        service.fetchWeatherData(null, 10.0, 0),
        throwsException,
      );
    });

    test('Falla sin longitud', () async {
      await expectLater(
        service.fetchWeatherData(10.0, null, 0),
        throwsException,
      );
    });

    test('Falla sin latitud y longitud', () async {
      await expectLater(
        service.fetchWeatherData(null, null, 0),
        throwsException,
      );
    });

    test('Devuelve modelo Weather válido', () {
      final weather = service.parseTodayWeather(mockApiResponse);
      expect(weather, isA<Weather>());
      expect(weather.weatherStatus, equals('clearsky'));
      expect(weather.currentTemperatureCelsius, 10.0);
    });

    test('Lanza excepción si no hay timeseries', () {
      final emptyJson = {
        'properties': {
          'timeseries': []
        }
      };
      expect(() => service.parseTodayWeather(emptyJson), throwsException);
    });

    test('parseTodayWeather lanza excepción si no hay datos del día', () {
      final jsonSinHoy = {
        "properties": {
          "timeseries": [
            {
              "time": DateTime.now().toUtc().subtract(Duration(days: 1)).toIso8601String(),
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
      };
      expect(() => service.parseTodayWeather(jsonSinHoy), throwsException);
    });
  });
}
