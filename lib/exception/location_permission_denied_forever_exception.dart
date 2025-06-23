import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class LocationPermissionDeniedForeverException extends CustomException {
  LocationPermissionDeniedForeverException([String message = "Permisos de ubicación denegados en configuración."])
      : super(message);
}
