abstract class CustomException implements Exception{

  CustomException(this.message);
  String message;
  @override
  String toString()=>"$runtimeType: $message";
}