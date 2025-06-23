import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class WeatherParseException extends CustomException {
  WeatherParseException(String reason) : super('No se pudo determinar el clima: $reason');
}