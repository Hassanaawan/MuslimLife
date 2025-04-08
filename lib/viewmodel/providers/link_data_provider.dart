import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/urls.dart';

class LinkDataProvider with ChangeNotifier {
  String liveLink = "";

  Future<void> fetchData() async {
    try {
      Dio dio = Dio();

      /// Replace with your actual API endpoint
      final response = await dio.get(Urls.liveLink);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data; // Dio parses JSON for you

        // Assuming 'live_link' is the key you want to extract
        liveLink = data['live_link'];

        print("*****************Successsss");
        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load data');
    }
  }
}