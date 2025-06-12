import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class UnregisteredComponentException extends CustomException{
  UnregisteredComponentException(String cause, String precursor):super("$cause requires $precursor to be saved first");
  UnregisteredComponentException.unregistered(String cause):super("$cause was not previously persisted to the database");
}