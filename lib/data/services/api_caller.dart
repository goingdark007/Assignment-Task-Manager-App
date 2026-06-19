import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:of9_task_manager/data/services/token_source.dart';
import 'package:of9_task_manager/ui/controller/auth_controller.dart';
import '../../app.dart';

class ApiCaller {

  static final Logger _logger = Logger();

  static late TokenSource _tokenSource;

  static void init({ required TokenSource tokenSource}){
    _tokenSource = tokenSource;
  }


  static Future<APIResponse> getRequest ({required String url}) async {

    try {

      Uri uri = Uri.parse(url);
      _logRequest(url);

      final Response response = await get(uri, headers: {
        'Content-Type': 'application/json',
        'token' : _tokenSource.accessToken ?? ''
      }).timeout(const Duration(seconds: 15)); // Set a timeout for the request

      _logResponse(url, response);

      final int statusCode = response.statusCode;
      final decodedData = _safeDecode(response.body);
      if (statusCode == 200) {

        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: true
        );
      } else if (response.statusCode == 401){
        await moveToLogin();
        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: false, errorMessage: 'Unauthorized'
        );
      } else {
        debugPrint('Error response body: $statusCode\n body => ${response.body}'); // Log the error response body for debugging
        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: false
        );
      }
    } catch (e) {
      return APIResponse(responseCode: 000, body: null, isSuccess: false, errorMessage: e.toString());
    }

  }

  static Future<APIResponse> postRequest ({required String url, required Map<String, dynamic>? body}) async {

    try {

      _logRequest(url, body: body);

      Uri uri = Uri.parse(url);

      final headers = {
        "Accept": 'application/json',
        "Content-Type": 'application/json',
        'token' : _tokenSource.accessToken ?? ''
      };

      final Response response = await post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null
      ).timeout(const Duration(seconds: 15)); // Set a timeout for the request

      _logResponse(url, response);

      final int statusCode = response.statusCode;
      final decodedData = _safeDecode(response.body);
      if (statusCode == 200 || statusCode == 201) {

        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: true
        );
      } else if (response.statusCode == 401){
        await moveToLogin();
        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: false, errorMessage: 'Unauthorized'
        );
      } else {
        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: false
        );
      }
    } catch (e) {
      return APIResponse(responseCode: 000, body: null, isSuccess: false, errorMessage: e.toString());
    }

  }

  static void _logRequest(String url,{ Map<String, dynamic>? body}) {
    _logger.i(
        'URL1 => $url\n'
        'Response Body => $body\n'
    );
  }

  static void _logResponse(String url, Response response) {

    final decodedData = _safeDecode(response.body);

    final prettyJson = decodedData is String
        ? decodedData
        : const JsonEncoder.withIndent('  ').convert(decodedData);


    _logger.i(
      'URL1 => $url\n'
      'Status code => ${response.statusCode}\n'
        'Response Body => $prettyJson\n'
      // No error parameter is needed here since this is an informational log.
    );
  }

  /// Safely JSON decoding
  static dynamic _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body; // fallback (plain text / HTML)
    }
  }

  static Future<void> moveToLogin () async {
    await AuthController.clearUserData();
    TaskManagerApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }


}

/// Model API response statusCode and body
class APIResponse {

  final dynamic body;
  final int responseCode;
  final bool isSuccess;
  final String? errorMessage;

  APIResponse({this.body, required this.responseCode,required this.isSuccess, this.errorMessage = 'Something wrong'});

}