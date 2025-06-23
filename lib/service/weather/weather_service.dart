import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitacora_ejercicios/model/weather.dart';

class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchWeatherData(
      double? lat, double? lon, double? altitude) async {
    if (lat == null || lon == null) {
      throw Exception('Latitud y longitud son requeridas');
    }

    final url = Uri.parse(
      'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$lat&lon=$lon&altitude=${altitude ?? 0}',
    );

    final response = await client.get(
      url,
      headers: {
        'User-Agent': 'bitacoraEjercicio/1.0 (contacto@gmail.com)',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener los datos: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Weather parseTodayWeather(Map<String, dynamic> json) {
    final timeseries = json['properties']['timeseries'] as List;
    if (timeseries.isEmpty) {
      throw Exception("No se encontraron datos de clima");
    }

    final today = DateTime.now().toLocal().day;

    double? minTemp, maxTemp;
    double? currentTemp;
    double? windSpeedKmh;

    final Map<String, int> symbolCount = {};

    for (var item in timeseries) {
      final t = DateTime.parse(item['time']).toLocal();
      if (t.day != today) continue;

      final details = item['data']['instant']['details'];
      final temp = (details['air_temperature'] as num).toDouble();
      final windMs = (details['wind_speed'] as num).toDouble();

      if (currentTemp == null) {
        currentTemp = temp;
        windSpeedKmh = windMs * 3.6;
      }

      minTemp = (minTemp == null) ? temp : (temp < minTemp ? temp : minTemp);
      maxTemp = (maxTemp == null) ? temp : (temp > maxTemp ? temp : maxTemp);

      final symbolCode =
          item['data']['next_6_hours']?['summary']?['symbol_code'] ??
              item['data']['next_12_hours']?['summary']?['symbol_code'] ??
              item['data']['next_1_hours']?['summary']?['symbol_code'];

      if (symbolCode != null) {
        final normalized = _normalizeSymbol(symbolCode);
        symbolCount[normalized] = (symbolCount[normalized] ?? 0) + 1;
      }
    }

    if (currentTemp == null ||
        minTemp == null ||
        maxTemp == null ||
        windSpeedKmh == null ||
        symbolCount.isEmpty) {
      throw Exception("No se pudo determinar el clima del día");
    }

    final mostFrequentSymbol = symbolCount.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    return Weather(
      mostFrequentSymbol,
      mostFrequentSymbol,
      currentTemp,
      minTemp,
      maxTemp,
      windSpeedKmh.round(),
    );
  }

  String _normalizeSymbol(String symbolCode) {
    return symbolCode.split('_').first;
  }
}
