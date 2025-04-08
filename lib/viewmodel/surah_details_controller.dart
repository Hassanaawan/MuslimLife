import 'dart:developer';
import 'package:get/get.dart';
import '../models/al_quran_surah/full_surah_details_model.dart';
import '../services/token_manager.dart';
import '../utils/urls.dart';
import 'package:dio/dio.dart';

class SurahDetailsController extends GetxController {
  bool _fullSurahFetchInProgress = false;
  String _errorMessage = '';
  List<Verses> _versesList = [];

  String get errorMessage => _errorMessage;
  bool get fullSurahFetchInProgress => _fullSurahFetchInProgress;
  List<Verses>? get versesList => _versesList;

  Future<bool> getFullSurahDetails(int surahNumber) async {
    _fullSurahFetchInProgress = true;
    update();

    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${AuthController.accessToken}';
      final response = await dio.get(Urls.getSurahFull(surahNumber));
      _fullSurahFetchInProgress = false;
      update();

      if (response.statusCode == 200) {
        final data = AlQuranSurahModel.fromJson(response.data); // Use response.data for Dio
        _versesList = data.data!.verses!;
        log(_versesList[1].toString());
        log(_versesList[1].audio.toString());
        update();
        return true;
      } else {
        _errorMessage = 'Failed to get full surah data!';
        update();
        return false;
      }
    } catch (e) {
      _fullSurahFetchInProgress = false;
      _errorMessage = 'An error occurred: $e';
      update();
      return false;
    }
  }
}
