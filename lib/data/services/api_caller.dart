
import 'package:logger/logger.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:of9_task_manager/ui/controller/auth_controller.dart';

import '../../app.dart';

class ApiCaller {

  static final Logger _logger = Logger();


  static Future<APIResponse> getRequest ({required String url}) async {

    try {

      Uri uri = Uri.parse(url);
      _logRequest(url);

      Response response = await get(uri, headers: {
        'token' : AuthController.accessToken ?? ''
      });
      _logResponse(url, response);

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: true
        );
      } else if (response.statusCode == 401){
        await moveToLogin();
        return APIResponse(
            body: jsonDecode(response.body), responseCode: statusCode, isSuccess: false, errorMessage: 'Unauthorized'
        );
      } else {
        final decodedData = jsonDecode(response.body);
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
        'token' : AuthController.accessToken ?? ''
      };

      Response response = await post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null
      );

      _logResponse(url, response);

      final int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        return APIResponse(
            body: decodedData, responseCode: statusCode, isSuccess: true
        );
      } else if (response.statusCode == 401){
        await moveToLogin();
        return APIResponse(
            body: jsonDecode(response.body), responseCode: statusCode, isSuccess: false, errorMessage: 'Unauthorized'
        );
      } else {
        final decodedData = jsonDecode(response.body);
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

    final decodedData = jsonDecode(response.body);

    final prettyJson = const JsonEncoder.withIndent(' ').convert(decodedData);

    _logger.i(
      'URL1 => $url\n'
      'Status code => ${response.statusCode}\n'
        'Response Body => $prettyJson\n'
      // No error parameter is needed here since this is an informational log.
    );
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