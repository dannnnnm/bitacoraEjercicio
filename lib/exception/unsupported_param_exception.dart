import 'package:bitacora_ejercicios/exception/custom_exception.dart';

class UnsupportedParamException extends CustomException{
  UnsupportedParamException(String paramName,String reason):super("the supplied parameter $paramName is not supported for this operation because $reason");
}