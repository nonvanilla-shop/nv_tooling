import 'package:flutter_test/flutter_test.dart';

import 'package:nv_tooling/nv_tooling.dart';

void main() {
  test('Success has boolean getters with correct return values', () {
    final success = valueOf(12);
    expect(success.isFailure, false);
    expect(success.isSuccess, true);
  });

  test('Exception has boolean getters with correct return values', () {
    final success = exceptionOf(Exception('Hello'));
    expect(success.isFailure, true);
    expect(success.isSuccess, false);
  });

  test('Success accessor calls onSuccess function', () {
    final Result<int, Exception> result = valueOf(12);
    expect(result.access((success) => success, (_) => -1), 12);
  });

  test('Exception accessor calls onException function', () {
    final exception = Exception('Hello');
    final Result<int, Exception> result = exceptionOf(exception);
    expect(
      result.access((success) => false, (exception) => exception),
      exception,
    );
  });

  test('Exception maps to new Exception correctly', () {
    final exception = Exception('Bye');
    final Result<int, Exception> result = exceptionOf(Exception('Hello'));
    expect(
      result
          .map(exception: (_) => exception)
          .access((success) => 12, (exception) => exception),
      exception,
    );
  });

  test('Exception maps to identity if no param passed', () {
    final exception = Exception('Hello');
    final Result<int, Exception> result = exceptionOf(exception);
    expect(
      result.map().access((success) => false, (exception) => exception),
      exception,
    );
  });

  test('Success maps to new success correctly', () {
    final Result<int, Exception> result = valueOf(12);
    expect(
      result.map(value: (s) => 'value: $s').access(
            (success) => success,
            (exception) => exception,
          ),
      'value: 12',
    );
  });

  test('Exception maps to identity if no param passed', () {
    final Result<int, Exception> success = valueOf(1);
    expect(success.map().access((success) => success, (exception) => exception),
        1);
  });
}
