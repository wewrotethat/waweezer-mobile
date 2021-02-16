import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:waweezer_mobile/helpers/exceptions/network_exceptions.dart';

class ApiHelpers {
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    var responseJson;
    try {
      final response = await http.post(url, body: body);
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      print("post socket exception $e");
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(
      String url, Map<String, String> headers, dynamic body) async {
    var responseJson;
    try {
      final response = await http.put(url, headers: headers, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
