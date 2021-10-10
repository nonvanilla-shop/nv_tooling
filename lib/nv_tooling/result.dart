/// Base class declaring the interface.
abstract class Result<S, E> {
  const Result();

  static value<V, E>(V success) => Value(success);
  static exception<V, E>(E failure) => Error(failure);

  S unwrap();

  T access<T>(
    T Function(S value) onValue,
    T Function(E exception) onException,
  );

  Result<NS, NE> map<NS, NE>({
    NS Function(S v)? value,
    NE Function(E e)? exception,
  });

  bool get isValue;
  bool get isException;
}

/// Value case.
class Value<V, E> extends Result<V, E> {
  final V _value;

  const Value(this._value);

  @override
  V unwrap() => _value;

  @override
  T access<T>(
    T Function(V success) onValue,
    T Function(E exception) onException,
  ) =>
      onValue(_value);

  @override
  bool get isException => false;

  @override
  bool get isValue => true;

  @override
  Result<NV, NE> map<NV, NE>({
    NV Function(V v)? value,
    NE Function(E e)? exception,
  }) =>
      valueOf<NV, NE>(value?.call(_value) ?? _value as NV);
}

/// Error case.
class Error<V, E> extends Result<V, E> {
  final E _exception;

  const Error(this._exception);

  @override
  V unwrap() => throw Exception(_exception);

  @override
  T access<T>(
    T Function(V success) onValue,
    T Function(E failure) onException,
  ) =>
      onException(_exception);

  @override
  bool get isException => true;

  @override
  bool get isValue => false;

  @override
  Result<NV, NE> map<NV, NE>({
    NV Function(V v)? value,
    NE Function(E e)? exception,
  }) =>
      exceptionOf<NV, NE>(exception?.call(_exception) ?? _exception as NE);
}

/// Constructor wrapper for Value which reads nicer.
Result<V, E> valueOf<V, E>(V value) => Value(value);

/// Constructor wrapper for Exception which reads nicer.
Result<V, E> exceptionOf<V, E>(E exception) => Error(exception);

typedef AsyncResult<V, E> = Future<Result<V, E>>;

/// Void object for value cases that should return void.
class Nothing {
  const Nothing();
}

/// Cleaner way to return a [Nothing] object.
const nothing = Nothing();
