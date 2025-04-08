import 'package:get/get.dart';
import '../../utils/urls.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class EmailVerificationController extends GetxController {
  String _message = '';

  String get message => _message;

  final Dio _dio = Dio(); // Create an instance of Dio

  Future<bool> verifyEmail(String email) async {
    Map<String, dynamic> requestBody = {"email":email};
    String jsonRequestBody = jsonEncode(requestBody);
print(jsonRequestBody);
print(Urls.sendOTP);
    try {
      final response = await _dio.post(
        Urls.sendOTP,
        data: {
          'data': jsonRequestBody,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.statusCode == 401) {
          _message = 'not_found_email'.tr;
        } else {
          _message = 'an_error_occurred';
        }
        print(_message);
        return false;
      }
    } on DioError catch (e) {
      _message = 'Failed to verify email';
      print(_message);
      return false;
    }
  }
}
