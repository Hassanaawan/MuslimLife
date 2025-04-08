import 'dart:convert';
import 'package:get/get.dart';
import '../models/al_quran_surah/surah_list_model.dart';
import '../models/category_list_model.dart';
import '../utils/urls.dart';
import 'package:http/http.dart' as http;


class CategoriesController extends GetxController {
  bool _categoryDataFetchInProgress = false;
  String _errorMessage = '';
  final List<CategoryListModel> _categoryList = [];
  SurahListModel _surahListModel = SurahListModel();

  SurahListModel get surahListModel => _surahListModel;
  bool get categoryDataFetchInProgress => _categoryDataFetchInProgress;
  String get errorMessage => _errorMessage;
  List<CategoryListModel> get categoryList => _categoryList;

  Future<bool> getCategoryList(String categoryURL) async {
    _categoryDataFetchInProgress = true;
    update();

    final String url = categoryURL == 'AL-QURAN'
        ? Urls.getSurahList
        : Urls.getCategoryList(categoryURL);

    try {
      final response = await http.get(Uri.parse(url));

      _categoryDataFetchInProgress = false;
      update();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (categoryURL == 'AL-QURAN') {
          _surahListModel = SurahListModel.fromJson(jsonResponse);
        } else {
          _categoryList.clear();
          List<dynamic> dataList = jsonResponse;
          for (var data in dataList) {
            _categoryList.add(CategoryListModel.fromJson(data));
          }
        }
        update();
        return true;
      } else {
        _errorMessage = 'Failed to fetch data.';
        update();
        return false;
      }
    } catch (error) {
      _categoryDataFetchInProgress = false;
      _errorMessage = 'Error occurred: $error';
      update();
      return false;
    }
  }
}


