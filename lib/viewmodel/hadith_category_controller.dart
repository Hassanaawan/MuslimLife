import 'dart:developer';
import 'package:get/get.dart';
import '../models/hadith_category_model.dart';
import '../services/token_manager.dart';
import '../utils/urls.dart';
import 'package:dio/dio.dart';

class HadithDataListController extends GetxController {
  String _errorMessage = '';
  final List<HadithCategoryModel> _hadithCategoryDataList = [];

  String get errorMessage => _errorMessage;
  List<HadithCategoryModel> get hadithCategoryDataList => _hadithCategoryDataList;

  Future<bool> getHadithCategoryData(String categoryName) async {
    update();

    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${AuthController.accessToken}';
      final response = await dio.get(Urls.getHadithCategoryData(categoryName));

      if (response.statusCode == 200) {
        List<dynamic> dataList = response.data;
        _hadithCategoryDataList.clear();
        for (var data in dataList) {
          _hadithCategoryDataList.add(HadithCategoryModel.fromJson(data));
        }
        update();
        log(_hadithCategoryDataList.length.toString());
        return true;
      } else {
        _errorMessage = 'Hadith category data fetch failed!';
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
