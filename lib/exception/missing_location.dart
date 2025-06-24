import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class MissingLocationException extends CustomException {
  MissingLocationException() : super('Latitud y longitud son requeridas');
}