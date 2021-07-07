import 'package:flutter_test/flutter_test.dart';

import 'package:nv_tooling/nv_tooling.dart';

void main() {
  test('Success has boolean getters with correct return values', () {
    final success = successOf(12);
    expect(success.isFailure, false);
    expect(success.isSuccess, true);
  });

  test('Success has boolean getters with correct return values', () {
    final success = failureOf(12);
    expect(success.isFailure, true);
    expect(success.isSuccess, false);
  });

  test('Success accessor calls onSuccess function', () {
    final SuccessOrFailure<int, bool> success = successOf(12);
    expect(success.access((success) => 12, (failure) => -1), 12);
  });

  test('Failure accessor calls onFailure function', () {
    final SuccessOrFailure<int, bool> success = successOf(12);
    expect(success.access((success) => 12, (failure) => -1), -1);
  });
}
