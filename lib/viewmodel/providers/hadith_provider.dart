import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/dua_category_model.dart';
import '../../models/hadith_category_model.dart';
import '../../utils/urls.dart';

class HadithProvider extends ChangeNotifier {
  String? _language;
  String? get language =>  _language;
  final Dio dio = Dio();
  List<dynamic> randomHadithIndexes = [];

  Future<void> getLanguage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'en';
    notifyListeners();
  }


  List<HadithCategoryModel>? _allHadith;
  List<HadithCategoryModel>? get allHadith => _allHadith;


  //Fetching all hadith data
  Future<void> fetchAllHadithData() async {
    String url = Urls.getAllHadithApi;
    final response = await dio.get(url);
    print("Fetch all hadith data with response code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      _allHadith = data.map((item) => HadithCategoryModel.fromJson(item)).toList();
      getRandomHadithIndexes() ;
      notifyListeners();
    } else {
      print('Failed to load Single User data: ${response.statusCode}');
    }
  }

  Future<void> getRandomHadithIndexes() async {
    randomHadithIndexes.clear();

    while (randomHadithIndexes.length < 3) {
      int randomIndex = Random().nextInt(allHadith!.length);
      if (!randomHadithIndexes.contains(randomIndex)) {
        randomHadithIndexes.add(randomIndex);
      }
    }

    notifyListeners();
  }


  List<DuaCategoryModel>? _allDua;
  List<DuaCategoryModel>? get allDua => _allDua;
  List<dynamic> randomDuaIndexes = [];


  ///Fetching all hadith data
  Future<void> fetchAllDuaData() async {
    String url = Urls.getAllDuaApi;

    final response = await dio.get(url);
    print("Fetch all dua data with response code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      _allDua = data.map((item) => DuaCategoryModel.fromJson(item)).toList();
      getRandomDuaIndexes();
      notifyListeners();
    } else {
      print('Failed to load Single User data: ${response.statusCode}');
    }
  }

  Future<void> getRandomDuaIndexes() async {
    randomDuaIndexes.clear();

    while (randomDuaIndexes.length < 3) {
      int randomIndex = Random().nextInt(allDua!.length);
      if (!randomDuaIndexes.contains(randomIndex)) {
        randomDuaIndexes.add(randomIndex);
      }
    }

    // Notify listeners if using ChangeNotifier
    notifyListeners();
  }

}