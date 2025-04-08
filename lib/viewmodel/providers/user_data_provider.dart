import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/currency_data_model.dart';
import '../../models/user_model.dart';
import '../../utils/urls.dart';

class UserDataProvider extends ChangeNotifier{
  UserModel? _userData;
  UserModel? get userData => _userData;

  bool _userDataLoading = false;
  bool get userDataLoading => _userDataLoading;

  final Dio dio = Dio();

  Future<void> fetchLoggedInUserData(bool hasUser) async{
    if(hasUser){
      _userDataLoading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      String url = "${Urls.fetchUserData}/$userId";

      final response = await dio.get(url);
      print("Fetch user data with response code: ${response.statusCode}");
      if(response.statusCode == 200){
        final jsonData = response.data;
        print("==============================================${response.data}");
        _userData = UserModel.fromJson(jsonData);
        _userDataLoading = false;
        notifyListeners();
      } else {
        final dummyData = UserModel(
          fullName: 'Guest User',
          thumbnailUrl: 'Null',
        );
        _userData = dummyData;
        _userDataLoading = false;
        print('Failed to load Single User data: ${response.statusCode}');
      }
    } else{
      final dummyData = UserModel(
        fullName: 'Guest User',
        thumbnailUrl: 'Null',
      );
      _userData = dummyData;
      _userDataLoading = false;
      print('Its guest log in');
    }
  }


  CurrencyData? _allCurrency;
  CurrencyData? get allCurrency => _allCurrency;

/// Fetching all currency data
  Future<void> fetchAllCurrencyData() async {
    String url = Urls.getAllCurrency;
    final response = await dio.get(url);
    print("Fetch all Currency data with response code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = response.data;
      _allCurrency = CurrencyData.fromJson(data);
      notifyListeners();
    } else {
      print('Failed to load Currency data: ${response.statusCode}');
    }
  }



  ///Update donation
  Future<void> updateDonationInfo(Donation data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final url = "${Urls.updateDonation}$userId";

    try {
      FormData formData = FormData.fromMap({
        'data': jsonEncode(data.toJson()),
      });

      final response = await dio.post(url, data: formData);
      print("Donation data updated with status: ${response.statusCode}");
    } on DioError catch (e) {
      print('Error updating donation info: ${e.message}');
    }
  }

}



class Donation {
  final int donationAmount;

  Donation({required this.donationAmount});

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      donationAmount: json['donationAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['donationAmount'] = this.donationAmount;
    return data;
  }
}
