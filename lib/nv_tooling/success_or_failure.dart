/// Base class declaring the interface.
abstract class SuccessOrFailure<S, F> {
  const SuccessOrFailure();

  static success<S, F>(S success) => Success(success);
  static failure<S, F>(F failure) => Failure(failure);

  T access<T>(T Function(S success) onSuccess, T Function(F failure) onFailure);
  SuccessOrFailure<S, F> map({
    S Function(S s)? success,
    F Function(F f)? failure,
  });
  bool get isSuccess;
  bool get isFailure;
}

/// Success case.
class Success<S, F> extends SuccessOrFailure<S, F> {
  final S _success;

  const Success(this._success);

  @override
  T access<T>(
    T Function(S success) onSuccess,
    T Function(F failure) onFailure,
  ) =>
      onSuccess(_success);

  @override
  bool get isFailure => false;

  @override
  bool get isSuccess => true;

  @override
  SuccessOrFailure<S, F> map({
    S Function(S s)? success,
    F Function(F f)? failure,
  }) =>
      successOf<S, F>(success?.call(_success) ?? _success);
}

/// Failure case.
class Failure<S, F> extends SuccessOrFailure<S, F> {
  final F _failure;

  const Failure(this._failure);

  @override
  T access<T>(
    T Function(S success) onSuccess,
    T Function(F failure) onFailure,
  ) =>
      onFailure(_failure);

  @override
  bool get isFailure => true;

  @override
  bool get isSuccess => false;

  @override
  SuccessOrFailure<S, F> map({
    S Function(S s)? success,
    F Function(F f)? failure,
  }) =>
      failureOf<S, F>(failure?.call(_failure) ?? _failure);
}

/// Constructor wrapper for Success which reads nicer.
SuccessOrFailure<S, F> successOf<S, F>(S success) => Success(success);

/// Constructor wrapper for Failure which reads nicer.
SuccessOrFailure<S, F> failureOf<S, F>(F failure) => Failure(failure);

/// Constructor wrapper that catches exceptions and returns them as a Failure.
SuccessOrFailure<S, dynamic> catching<S>(S Function() attempt) {
  try {
    return successOf(attempt());
  } catch (e) {
    return failureOf(e);
  }
}
