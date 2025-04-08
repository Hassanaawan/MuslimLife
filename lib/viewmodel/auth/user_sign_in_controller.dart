import 'dart:convert';
import 'package:Muslimlife/viewmodel/auth/user_profile_controller.dart';
import 'package:get/get.dart';
import '../../services/token_manager.dart';
import '../../utils/urls.dart';
import 'package:dio/dio.dart';

class UserSignInController extends GetxController {
  String _message = '';
  String _token = '';
  final Dio _dio = Dio();

  String get message => _message;

  Future<bool> signIn(String email, String password, String userAdId) async {
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "oneSignalId": userAdId,
    };
    String jsonRequestBody = jsonEncode(requestBody);

    try {
      final response = await _dio.post(
        Urls.signIn,
        data: {
          'data': jsonRequestBody,
        },
      );

      if (response.statusCode == 200) {
        var responseJson = response.data;
        print('============================ Response JSON: $responseJson');
        print('============================ Response JSON: ${response.statusCode}');
        print('============================ Response JSON: ${response.data}');
        if (responseJson['token'] != null) {
          _token = responseJson['token'];
          await AuthController.setAccessToken(_token);
        } else {
          print('Token is null');
        }

        if (responseJson['user'] != null) {
          await UserProfileController.setUserId(responseJson['user']['_id']);
          await UserProfileController.setUserName(responseJson['user']['fullName']);
          await UserProfileController.setUserMail(responseJson['user']['email']);
        } else {
          print('User data is null');
        }

        DateTime expireTime = DateTime.now().add(const Duration(days: 6));
        await AuthController.setExpireDateAndTime(expireTime.toString());

        print(_token);
        return true;
      } else {
        _message = _handleError(response.statusCode);
        print(_message);
        return false;
      }
    } on DioError catch (e) {
      // Handle DioError
      if (e.response != null) {
        _message = _handleError(e.response?.statusCode);
        print('Error: ${e.response?.data}');
      } else {
        _message = 'Failed to reach server';
        print('Error sending request: $e');
      }
      update();
      return false;
    }
  }

  // Error message handler
  String _handleError(int? statusCode) {
    switch (statusCode) {
      case 404:
        return 'user_not_found'.tr;
      case 401:
        return 'invalid_password'.tr;
      default:
        return 'unknown_error'.tr;
    }
  }
}

