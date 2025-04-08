import 'dart:developer';
import 'package:get/get.dart';
import '../models/event_prayer_category_model.dart';
import '../services/token_manager.dart';
import '../utils/urls.dart';
import 'package:dio/dio.dart';

class EventPrayerCategoryController extends GetxController {
  String _errorMessage = '';
  final List<EventPrayerCategoryModel> _eventPrayerCategoryDataList = [];

  String get errorMessage => _errorMessage;
  List<EventPrayerCategoryModel> get eventPrayerCategoryDataList => _eventPrayerCategoryDataList;

  Future<bool> getEventPrayerCategoryData(String categoryName) async {
    update();

    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${AuthController.accessToken}';
      final response = await dio.get(Urls.getEventPrayerCategoryData(categoryName));

      if (response.statusCode == 200) {
        List<dynamic> dataList = response.data;
        _eventPrayerCategoryDataList.clear();
        for (var data in dataList) {
          _eventPrayerCategoryDataList.add(EventPrayerCategoryModel.fromJson(data));
        }
        update();
        log(_eventPrayerCategoryDataList.length.toString());
        return true;
      } else {
        _errorMessage = 'Event Prayer category data fetch failed!';
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
