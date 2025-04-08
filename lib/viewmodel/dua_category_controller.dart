import 'dart:developer';
import 'package:get/get.dart';
import '../models/dua_category_model.dart';
import '../services/token_manager.dart';
import '../utils/urls.dart';
import 'package:dio/dio.dart';

class DuaCategoryController extends GetxController {
  String _errorMessage = '';
  final List<DuaCategoryModel> _duaCategoryDataList = [];

  String get errorMessage => _errorMessage;
  List<DuaCategoryModel> get duaCategoryDataList => _duaCategoryDataList;

  Future<bool> getDuaCategoryData(String categoryName) async {
    update();

    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${AuthController.accessToken}';
      final response = await dio.get(Urls.getDuaCategoryData(categoryName));

      if (response.statusCode == 200) {
        List<dynamic> dataList = response.data;
        _duaCategoryDataList.clear();
        for (var data in dataList) {
          _duaCategoryDataList.add(DuaCategoryModel.fromJson(data));
        }
        update();
        log(_duaCategoryDataList.length.toString());
        return true;
      } else {
        _errorMessage = 'Dua category data fetch failed!';
        update();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      update();
      return false;
    }
  }
}
