sealed class Result<T,E extends Exception>{
  T unwrap();
  bool isOK();
  bool isErr();
}

class Ok<T, E extends Exception> extends Result<T, E> {
  final T value;
  Ok(this.value);
  
  @override
  T unwrap() {
    return value;
    
  }
  
  @override
  bool isErr() {
    return false;
  }
  
  @override
  bool isOK() {
    return true;
  }

  
}

class Err<T, E extends Exception> extends Result<T, E> {
  final E error;
  Err(this.error);
  
  @override
  T unwrap() {
    throw error;
  }
  
  @override
  bool isErr() {
    return true;
  }
  
  @override
  bool isOK() {
    return false;
  }
  
}