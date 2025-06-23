import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class WeatherFetchException extends CustomException {
  WeatherFetchException(int code)
      : super('Error al obtener los datos: $code');
}