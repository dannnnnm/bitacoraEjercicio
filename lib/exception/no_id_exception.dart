import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class NoIDException extends CustomException{
  NoIDException():super("attempted to use an unregistered elemnt (ID 0) where a persisted one is needed");


}