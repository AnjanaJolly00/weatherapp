import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/models/api_response.dart';
import 'dio_builder.dart';

class DioApiService {
  //

  static Future<ApiResponse> getRequest(
      {url,
      body,
      queryParameters,
      Options? options,
      bool hasAuth = true}) async {
    ApiResponse clientResponse = ApiResponse();
    try {
      DioBuilderResponse dioBuilderResponse =
          await DioBuilder().buildNonCachedDio(hasAuth: hasAuth);
      Response response = (await dioBuilderResponse.dio.get(url,
          data: body ?? {},
          options: options ?? dioBuilderResponse.dioOptions,
          queryParameters: queryParameters));
      debugPrint(response.toString());
      clientResponse = ApiResponse.fromResponse(response);
    } on DioException catch (e) {
      clientResponse = ApiResponse.fromError(e);
    } catch (e) {
      clientResponse.errorMsg = e.toString();
    }

    return clientResponse;
  }

  static Future<ApiResponse> postRequest(
      {url,
      body,
      queryParameters,
      Options? options,
      void Function(int, int)? onSend,
      void Function(int, int)? onReceive,
      hasAuth = true}) async {
    ApiResponse clientResponse = ApiResponse();
    try {
      DioBuilderResponse dioBuilderResponse =
          await DioBuilder().buildNonCachedDio(
        hasAuth: hasAuth,
      );
      Response response = (await dioBuilderResponse.dio.post(
        url,
        queryParameters: queryParameters ?? {},
        data: body ?? {},
        options: options ?? dioBuilderResponse.dioOptions,
      ));
      clientResponse = ApiResponse.fromResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        clientResponse = ApiResponse.fromError(e);
      } else {
        clientResponse.errorMsg = e.message ?? "";
      }
    } catch (e) {
      clientResponse.errorMsg = e.toString();
    }

    return clientResponse;
  }
}
