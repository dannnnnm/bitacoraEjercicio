sealed class Option<T>{
  const Option();
  T unwrap();
  bool isSome();
  bool isNone();
}

class Some<T> extends Option<T>{
  final T value;
  Some(this.value);
  @override
  T unwrap(){
    return this.value;
  }

  @override
  bool isSome(){
    return true;
  }
  @override
  bool isNone(){
    return false;
  }
}

class None<T> extends Option<T> {
  const None();
  @override
  T unwrap(){
    throw Exception("called unwrap on None");
  }

  @override
  bool isSome(){
    return false;
  }
  @override
  bool isNone(){
    return true;
  }
}