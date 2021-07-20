import 'package:flutter_test/flutter_test.dart';

import 'package:nv_tooling/nv_tooling.dart';

void main() {
  test('Success has boolean getters with correct return values', () {
    final success = successOf(12);
    expect(success.isFailure, false);
    expect(success.isSuccess, true);
  });

  test('Failure has boolean getters with correct return values', () {
    final success = failureOf(12);
    expect(success.isFailure, true);
    expect(success.isSuccess, false);
  });

  test('Success accessor calls onSuccess function', () {
    final SuccessOrFailure<int, bool> success = successOf(12);
    expect(success.access((success) => success, (failure) => -1), 12);
  });

  test('Failure accessor calls onFailure function', () {
    final SuccessOrFailure<int, bool> failure = failureOf(true);
    expect(failure.access((success) => false, (failure) => failure), true);
  });

  test('Failure maps to new failure correctly', () {
    final SuccessOrFailure<int, bool> failure = failureOf(true);
    expect(
      failure
          .map(failure: (f) => -1)
          .access((success) => 12, (failure) => failure),
      -1,
    );
  });

  test('Failure maps to identity if no param passed', () {
    final SuccessOrFailure<int, bool> failure = failureOf(true);
    expect(
      failure.map().access((success) => false, (failure) => failure),
      true,
    );
  });

  test('Success maps to new success correctly', () {
    final SuccessOrFailure<int, bool> success = successOf(12);
    expect(
      success.map(success: (s) => 'value: $s').access(
            (success) => success,
            (failure) => failure,
          ),
      'value: 12',
    );
  });

  test('Failure maps to identity if no param passed', () {
    final SuccessOrFailure<int, bool> success = successOf(1);
    expect(success.map().access((success) => success, (failure) => failure), 1);
  });
}
