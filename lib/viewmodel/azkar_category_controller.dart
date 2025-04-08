import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/azkar_category_model.dart';
import '../services/token_manager.dart';
import '../utils/urls.dart';

class AzkarCategoryController extends GetxController {
  String _errorMessage = '';
  final List<AzkarCategoryModel> _azkarCategoryDataList = [];

  String get errorMessage => _errorMessage;
  List<AzkarCategoryModel> get azkarCategoryDataList => _azkarCategoryDataList;

  Future<bool> getAzkarCategoryData(String categoryName) async {
    update();
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${AuthController.accessToken}';
      final response = await dio.get(Urls.getAzkarCategoryData(categoryName));
      if (response.statusCode == 200) {
        List<dynamic> dataList = response.data;

        _azkarCategoryDataList.clear();
        for (var data in dataList) {
          _azkarCategoryDataList.add(AzkarCategoryModel.fromJson(data));
        }
        update();
        log(_azkarCategoryDataList.length.toString());
        return true;
      } else {
        _errorMessage = 'Azkar category data get failed!';
        return false;
      }
    } catch (e) {
      /// Handle any errors that occur during the request
      _errorMessage = 'An error occurred: $e';
      return false;
    } finally {
      update();
    }
  }
}