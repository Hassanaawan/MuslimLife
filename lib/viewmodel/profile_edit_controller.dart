import 'dart:convert';
import 'dart:io';
import '../utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;


class ProfileEditController extends GetxController {
  final String _message = '';
  final Dio _dio = Dio();

  String get message => _message;

  Future<bool> updateUserData(Map<String, dynamic> requestBody, String uId,
      bool imageUpload, File? filePath) async {
    update();
    print(requestBody);
    print(uId);

    try {
      FormData formData = FormData.fromMap({
        'data': jsonEncode(requestBody),
        if (imageUpload && filePath != null)
          'file': await MultipartFile.fromFile(filePath.path),
      });

      final response = await _dio.post(Urls.updateUserData(uId), data: formData);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed update with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    } finally {
      update();
    }
  }
}


