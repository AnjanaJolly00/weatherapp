import 'dart:developer';

import '../../data/models/api_response.dart';
import '../service/dio_service/dio_api_service.dart';

class WeatherRepo {
  final appId = "bd5e378503939ddaee76f12ad7a97608";

  Future<ApiResponse> getLocationWeather({lat, lon, city}) {
    var query = {"lat": lat, "lon": lon, "appid": appId, 'q': city};
    log(query.toString());
    return DioApiService.getRequest(url: 'weather', queryParameters: query);
  }

  Future<ApiResponse> getWeeklyLocation({lat, lon, city}) {
    var query = {"lat": lat, "lon": lon, "appid": appId, 'q': city};
    log(query.toString());
    return DioApiService.getRequest(url: 'onecall', queryParameters: query);
  }

  Future<ApiResponse> getDailyLocation({lat, lon}) {
    var query = {"lat": lat, "lon": lon, "appid": appId, 'cnt': 7};
    log(query.toString());
    return DioApiService.getRequest(
        url: 'forecast/daily', queryParameters: query);
  }
}
