import 'package:get/get.dart';
import '../../services/token_manager.dart';
import '../../utils/urls.dart';
import 'dart:convert';
import 'package:dio/dio.dart';


class OtpValidationController extends GetxController {
  String _message = '';
  final Dio _dio = Dio();

  String get message => _message;

  Future<bool> verifyOtp(String email, String otpString) async {
    int otpInt = int.parse(otpString);
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "otp": otpInt,
    };

    try {
      final response = await _dio.post(
        Urls.verifyOTP,
        data: {
          'data': jsonEncode(requestBody),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AuthController.accessToken}',
          },
        ),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        _handleError(response.statusCode);
        print(_message);
        return false;
      }
    } on DioError catch (e) {
      // Handle DioError
      if (e.response != null) {
        _handleError(e.response?.statusCode);
        print('Error: ${e.response?.data}');
      } else {
        _message = 'Failed to reach server';
        print('Error sending request: $e');
      }
      update();
      return false;
    } finally {
      update();
    }
  }

  void _handleError(int? statusCode) {
    if (statusCode == 401) {
      _message = 'otp_not_match'.tr;
    } else {
      _message = 'An unexpected error occurred.';
    }
  }
}
