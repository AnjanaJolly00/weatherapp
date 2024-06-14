// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';


class DioInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries; // Maximum number of retries

  DioInterceptor(this.dio, {this.maxRetries = 3});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

   
    log('[ Hereeeeeeeeeeeee-;-;p ${options.baseUrl}]');
    log('[ URL: ${options.baseUrl}${options.path} ]');
    log('[ Headers: ${options.headers.toString()} ]');
    log('[ Request: ${options.data.toString()} ]');
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    log('[ Response: ${response.data} ]');

    if(response.statusCode==403){
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('[ Error ] ${err.toString()}');
    log('[ Error Response] ${err.response.toString()}');
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _retryRequest(err.requestOptions, handler);
        break;
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 401:

          case 403:
        
          case 404:
            throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }

  


  Future<void> _retryRequest(
      RequestOptions requestOptions, ErrorInterceptorHandler handler) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await dio.request(
          requestOptions.path,
          queryParameters: requestOptions.queryParameters,
          data: requestOptions.data,
        );

        // Check if the response is successful
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          // Success, return the response
          return handler.resolve(response);
        }
      } catch (e) {
        // Retry failed, increment the retry count
        retryCount++;
      }
    }

    // All retries failed, throw the original error
    handler.next(
      DioException(
        requestOptions: requestOptions,
        error: 'Max retries exceeded',
        type: DioExceptionType.connectionError,
      ),
    );
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
