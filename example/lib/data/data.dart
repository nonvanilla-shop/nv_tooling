import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nv_tooling/nv_tooling.dart';

part 'data.freezed.dart';

class Data {
  Result<WeatherData, HttpException> getWeather() {
    try {
      final map = fakeHttpCall();
      return valueOf(_mapToWeatherData(map));
    } catch (e) {
      return exceptionOf(HttpException.noConnection());
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
class HttpException extends Exception with _$HttpException {
  @Implements(Exception)
  const factory HttpException.noConnection() = _NoConnection;
  @Implements(Exception)
  const factory HttpException.unauthorized() = _Unauthorized;
}

@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    required String weather,
    required int tempInDegrees,
    required int propRain,
  }) = _WeatherData;
}
