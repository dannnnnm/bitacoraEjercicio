import 'package:bitacora_ejercicios/utilTypes/option.dart';
import 'package:test/test.dart';

void main(){
  test("Some returns true to isSome", (){
    Option<int> option=Some(42);
    expect(option.isSome(), true);
  });
  test("Some returns false to isNone", (){
    Option<int> option=Some(42);
    expect(option.isNone(), false);
  });
  test("Nonee returns false to isSome", (){
    None option=None();
    expect(option.isSome(), false);
  });
  test("Nonee returns true to isNone", (){
    Option<int> option=Some(42);
    expect(option.isNone(), true);
  });

  test("Some returns the contained value", (){
    String value="is that the door?";
    Option<String> option=Some(value);
    expect(option.unwrap(), value);
  });

  
}