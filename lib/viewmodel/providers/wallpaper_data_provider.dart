import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../models/wallpaper_model.dart';
import '../../utils/urls.dart';

class WallpaperDataProvider extends ChangeNotifier{
  List<WallpaperModel>? _allWallpapers;
  List<WallpaperModel>? get allWallpapers => _allWallpapers;
  final Dio dio = Dio();

  Future<void> fetchAllWallpapers() async{
    final apiUrl = Urls.fetchWallpapersData; // Replace with your API URL
    final response = await dio.get(apiUrl);
    print("Fetch all wallpapers data with response code ${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      _allWallpapers = jsonData.map((json) => WallpaperModel.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }
}



