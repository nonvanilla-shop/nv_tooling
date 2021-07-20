/// Base class declaring the interface.
abstract class SuccessOrFailure<S, F> {
  const SuccessOrFailure();

  static success<S, F>(S success) => Success(success);
  static failure<S, F>(F failure) => Failure(failure);

  T access<T>(T Function(S success) onSuccess, T Function(F failure) onFailure);
  SuccessOrFailure<NS, NF> map<NS, NF>({
    NS Function(S s)? success,
    NF Function(F f)? failure,
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
  SuccessOrFailure<NS, NF> map<NS, NF>({
    NS Function(S s)? success,
    NF Function(F f)? failure,
  }) =>
      successOf<NS, NF>(success?.call(_success) ?? _success as NS);
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
  SuccessOrFailure<NS, NF> map<NS, NF>({
    NS Function(S s)? success,
    NF Function(F f)? failure,
  }) =>
      failureOf<NS, NF>(failure?.call(_failure) ?? _failure as NF);
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
