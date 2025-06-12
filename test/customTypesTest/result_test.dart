import 'package:bitacora_ejercicios/utilTypes/result.dart';
import 'package:test/test.dart';

void main() {
  test("Err reports correctly as error", (){
    Result result=Err(Exception("unknown error"));
    expect(result.isErr(), true);
  });

  test("Err reports correctly as not Ok", (){
    Result result=Err(Exception("unknown error"));
    expect(result.isOK(), false);
  });

  test("OK reports correctly as not error", (){
    Result<int,Exception> result=Ok(42);
    expect(result.isErr(), false);
  });

  test("Ok reports correctly as Ok", (){
    Result<int,Exception> result=Ok(42);
    expect(result.isOK(), true);
  });




}