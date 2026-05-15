import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../exceptions/dio_Exception.dart';

class NetworkApiServices {
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  Future<dynamic> getApi(String url, {Map<String, dynamic>? headers}) async {
    if (kDebugMode) {
      print("🌐 GET Request: $url");
    }

    dynamic responseJson;
    try {
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      ).timeout(const Duration(seconds: 20));
      
      responseJson = returnResponse(response);
    } on DioException catch (e) {
       print("STATUS CODE: ${e.response?.statusCode}");
       print("RESPONSE: ${e.response?.data}");

      if (e.error is SocketException) {
        throw InternetException("No Internet Connection");
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw RequestTimeOut("Connection Timed Out");
      } else {
        throw FetchDataException("Error: ${e.message}");
      }
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        throw InvalidUrlException("");
      case 401:
      case 403:
        throw UnauthorisedException("");
      case 404:
        throw NotFoundException("");
      case 500:
      default:
        throw FetchDataException("Error communicating with server: ${response.statusCode}");
    }
  }
}