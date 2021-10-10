/// Base class declaring the interface.
abstract class Result<S, E extends Exception> {
  const Result();

  static value<S, F>(S success) => Value(success);
  static exception<S, E extends Exception>(E failure) => Error(failure);

  S unwrap();

  T access<T>(
    T Function(S success) onValue,
    T Function(E failure) onException,
  );

  Result<NS, NE> map<NS, NE extends Exception>({
    NS Function(S s)? value,
    NE Function(E f)? exception,
  });

  bool get isSuccess;
  bool get isFailure;
}

/// Value case.
class Value<S, E extends Exception> extends Result<S, E> {
  final S _value;

  const Value(this._value);

  @override
  S unwrap() => _value;

  @override
  T access<T>(
    T Function(S success) onSuccess,
    T Function(E failure) onFailure,
  ) =>
      onSuccess(_value);

  @override
  bool get isFailure => false;

  @override
  bool get isSuccess => true;

  @override
  Result<NS, NE> map<NS, NE extends Exception>({
    NS Function(S s)? value,
    NE Function(E f)? exception,
  }) =>
      valueOf<NS, NE>(value?.call(_value) ?? _value as NS);
}

/// Error case.
class Error<S, E extends Exception> extends Result<S, E> {
  final E _exception;

  const Error(this._exception);

  @override
  S unwrap() => throw _exception;

  @override
  T access<T>(
    T Function(S success) onSuccess,
    T Function(E failure) onFailure,
  ) =>
      onFailure(_exception);

  @override
  bool get isFailure => true;

  @override
  bool get isSuccess => false;

  @override
  Result<NS, NE> map<NS, NE extends Exception>({
    NS Function(S s)? value,
    NE Function(E f)? exception,
  }) =>
      exceptionOf<NS, NE>(exception?.call(_exception) ?? _exception as NE);
}

/// Constructor wrapper for Value which reads nicer.
Result<S, E> valueOf<S, E extends Exception>(S success) => Value(success);

/// Constructor wrapper for Exception which reads nicer.
Result<S, E> exceptionOf<S, E extends Exception>(E exception) =>
    Error(exception);

typedef AsyncResult<S, E extends Exception> = Future<Result<S, E>>;

/// Void object for value cases that should return void.
class Nothing {
  const Nothing();
}

/// Cleaner way to return a [Nothing] object.
const nothing = Nothing();
