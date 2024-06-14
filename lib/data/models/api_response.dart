import 'dart:io';
import 'package:dio/dio.dart';

class ApiResponse<T> {
  /// true = request is success
  bool isSuccessful;
  int? code;

  /// response data for the request
  T? data;

  /// Error message which can be displayed to the user
  String? errorMsg;

  ApiResponse({
    this.isSuccessful = false,
    this.code,
    this.data,
    this.errorMsg,
  });

  ApiResponse<T> copyWith({
    bool? isSuccessful,
    int? code,
    T? data,
    String? errorMsg,
  }) {
    return ApiResponse<T>(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      code: code ?? this.code,
      data: data ?? this.data,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  factory ApiResponse.fromResponse(Response response) {
    try {
      return ApiResponse<T>(
        isSuccessful: response.statusCode! >= 200 && response.statusCode! < 300,
        code: response.statusCode,
        data: response.data as T?,
        errorMsg: response.statusMessage,
      );
    } catch (e) {
      return ApiResponse<T>(
        isSuccessful: false,
        code: response.statusCode,
        errorMsg: 'Failed to parse response data',
      );
    }
  }

  factory ApiResponse.fromError(DioException error) {
    String errorMsg = 'Unknown error';
    if (error.type == DioExceptionType.badResponse) {
      // The request was made and the server responded with a status code
      errorMsg = 'Server error';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      // Timeout error
      errorMsg = 'Request timeout';
    } else if (error.type == DioExceptionType.cancel) {
      // Request was cancelled
      errorMsg = 'Request cancelled';
    } else if (error.error is SocketException) {
      // Network error
      errorMsg = 'No internet connection';
    }

    return ApiResponse<T>(
      isSuccessful: false,
      code: error.response?.statusCode,
      errorMsg: errorMsg,
    );
  }
}

// import 'package:dio/dio.dart';

// class ApiResponse<T> {
//   /// true = request is success
//   bool isSuccessful;
//   int? code;

//   /// response data for the request
//   var rawResponse;

//   /// Error message which can be displayed to user
//   String? errorMsg;

//   ApiResponse({
//     this.isSuccessful = false,
//     this.code = 400,
//     this.rawResponse,
//     this.errorMsg = "",
//   });

//   ApiResponse copyWith({
//     bool? isSuccessful,
//     int? code,
//     String? rawResponse,
//     String? errorMsg,
//   }) {
//     return ApiResponse(
//       isSuccessful: isSuccessful ?? this.isSuccessful,
//       code: code ?? this.code,
//       rawResponse: rawResponse ?? this.rawResponse,
//       errorMsg: errorMsg ?? this.errorMsg,
//     );
//   }

//   factory ApiResponse.fromResponse(Response response) {
//     return ApiResponse(
//       isSuccessful: response.statusCode! >= 200 && response.statusCode! < 300,
//       code: response.statusCode,
//       rawResponse: response.data,
//       errorMsg: response.statusMessage,
//     );
//   }
// }
