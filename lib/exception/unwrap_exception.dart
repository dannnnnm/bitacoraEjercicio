import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class UnwrapException extends CustomException{
  UnwrapException():super("attempted to unwrap when result was absent");
}