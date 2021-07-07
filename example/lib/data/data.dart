import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nv_tooling/nv_tooling.dart';

part 'data.freezed.dart';

class Data {
  SuccessOrFailure<WeatherData, HttpFailure> getWeather() {
    try {
      final map = fakeHttpCall();
      return successOf(_mapToWeatherData(map));
    } catch (e) {
      return failureOf(HttpFailure.noConnection());
    }
  }

  Map<String, dynamic> fakeHttpCall() {
    if (Random().nextInt(100) < 50) {
      return {'weather': 'sun', 'tempInDegrees': 12, 'propRain': 34};
    } else {
      throw Exception();
    }
  }

  WeatherData _mapToWeatherData(Map<String, dynamic> map) => WeatherData(
        weather: map['weather'] as String,
        tempInDegrees: map['tempInDegrees'] as int,
        propRain: map['propRain'] as int,
      );
}

// Sealed union is useful here to force ourselves to handle every possible scenario.
@freezed
class HttpFailure with _$HttpFailure {
  const factory HttpFailure.noConnection() = _NoConnection;
  const factory HttpFailure.unauthorized() = _Unauthorized;
}

@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    required String weather,
    required int tempInDegrees,
    required int propRain,
  }) = _WeatherData;
}
