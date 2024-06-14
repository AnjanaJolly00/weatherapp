import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'pretty_dio_logger.dart';
import 'api_interceptor.dart';

class DioBuilderResponse {
  Dio dio;
  Options dioOptions;

  DioBuilderResponse({required this.dio, required this.dioOptions});
}

class DioBuilder {
  Options _getCachedDioOptions() {
    return buildCacheOptions(
      const Duration(days: 30),
      forceRefresh: true,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 501;
        },
      ),
    );
  }

  Future<DioBuilderResponse> buildCachedDio({
    bool hasAuth = true,
    bool shouldQueue = false,
  }) async {
    DioCacheManager dioCacheManager = DioCacheManager(CacheConfig());
    Options dioOptions = _getCachedDioOptions();
   
    Dio dio = Dio(BaseOptions(
        persistentConnection: true,
        baseUrl: 'https://api.openweathermap.org/data/2.5/',
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        headers:{
                'Content-Type': 'application/json',
              }));
    dio.interceptors.add(DioInterceptor(dio));
    dio.interceptors.add(dioCacheManager.interceptor);
    if (shouldQueue) dio.interceptors.add(QueuedInterceptor());
    return DioBuilderResponse(dio: dio, dioOptions: dioOptions);
  }

  Future<DioBuilderResponse> buildNonCachedDio({
    bool hasAuth = true,
    bool shouldQueue = false,
  }) async {
    Options dioOptions = _getDioOptions();
  
    Dio dio = Dio(BaseOptions(
        persistentConnection: true, baseUrl: 'https://api.openweathermap.org/data/2.5/',
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        headers:  {
                'Content-Type': 'application/json',
              }));
    dio.interceptors.add(PrettyDioLogger());

    dio.interceptors.add(DioInterceptor(dio));
    if (shouldQueue) dio.interceptors.add(QueuedInterceptor());
    return DioBuilderResponse(dio: dio, dioOptions: dioOptions);
  }

  Options _getDioOptions() {
    return Options(
      persistentConnection: true,
      followRedirects: false,
      validateStatus: (status) {
        return status! < 501;
      },
    );
  }
}
