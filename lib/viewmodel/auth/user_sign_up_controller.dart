import 'dart:convert';
import 'package:Muslimlife/viewmodel/auth/user_profile_controller.dart';
import 'package:get/get.dart';
import '../../services/token_manager.dart';
import '../../utils/urls.dart';
import 'package:dio/dio.dart';


class UserSignUpController extends GetxController {
  String _message = '';
  String _token = '';
  final Dio _dio = Dio();

  String get message => _message;

  Future<bool> signUp(String name, String email, String password, String userAdId) async {
    update();

    Map<String, dynamic> requestBody = {
      "fullName": name,
      "email": email,
      "password": password,
      "oneSignalId": userAdId,
    };

    String jsonRequestBody = jsonEncode(requestBody);

    try {
      final response = await _dio.post(
        Urls.userSignUp,
        data: {
          'data': jsonRequestBody,
        },
      );

      if (response.statusCode == 201) {
        var responseJson = response.data;

        await UserProfileController.setUserId(responseJson['newUser']['_id']);
        await UserProfileController.setUserName(responseJson['newUser']['fullName']);
        await UserProfileController.setUserMail(responseJson['newUser']['email']);

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

  String _handleError(int? statusCode) {
    switch (statusCode) {
      case 500:
        return 'dup_user'.tr;
      default:
        return 'unknown error';
    }
  }
}
