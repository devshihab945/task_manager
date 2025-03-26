import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String ? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage = 'Something Went Wrong!',
  });
}

class NetworkClient {
  static final Logger _logger = Logger();

  static Future<NetworkResponse> getRequest({required String url, Map<String, String>? headers}) async {
    try {
      _preRequestLog(url);
      Uri uri = Uri.parse(url);
      Response response = await get(uri, headers: headers);
      _postRequestLog(url, response.statusCode,
          headers: response.headers, responseBody: response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: jsonDecode(response.body),
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: response.body,
        );
      }
    } on Exception catch (e) {
      _postRequestLog(url, -1);
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body, Map<String, String>? headers}) async
  {
    try {
      _preRequestLog(url, body: body);
      Uri uri = Uri.parse(url);
      Response response = await post(uri,
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
          body: jsonEncode(body));
      _postRequestLog(url, response.statusCode,
          headers: response.headers, responseBody: response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: jsonDecode(response.body),
        );
      } else {
        final decodedResponse = jsonDecode(response.body);
        String errorMessage = decodedResponse['data'] ?? 'Something went wrong';
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } on Exception catch (e) {
      _postRequestLog(url, -1, errorMessage: e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }


  static void _preRequestLog(String url, {Map<String, dynamic>? body, Map<String, dynamic>? headers}) {
    _logger.i('URL: $url\n' 'Headers: $headers\n' 'Body: $body' );
  }

  static void _postRequestLog(String url, int? statusCode,
      {Map<String, dynamic>? headers,
      dynamic responseBody,
      dynamic errorMessage}) {
    if (errorMessage != null) {
      _logger.i(''
          'URL: $url\n'
          'Status Code: $statusCode\n'
          'Error Message: $errorMessage');
    } else {
      _logger.i(''
          'URL: $url\n'
          'Status Code: $statusCode\n'
          'Headers: $headers\n'
          'Response: $responseBody');
    }
  }


}
