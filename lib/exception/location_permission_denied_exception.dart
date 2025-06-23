import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class LocationPermissionDeniedException extends CustomException {
  LocationPermissionDeniedException([super.message = "Permisos de ubicación denegados."]);
}
