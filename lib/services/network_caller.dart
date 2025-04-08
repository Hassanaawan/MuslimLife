import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../models/network_response.dart';
import 'token_manager.dart';

// class NetworkCaller {
//   /// get request method
//   Future<NetworkResponse> getRequest(String url, {bool isLogin = false}) async {
//     try {
//       Response response = await get(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer ${AuthController.accessToken}'},
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return NetworkResponse(
//           true,
//           response.statusCode,
//           //jsonDecode(await response.stream.bytesToString()),
//           jsonDecode(response.body),
//         );
//       } else {
//         log('Error occurred');
//         return NetworkResponse(false, response.statusCode, null);
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//     return NetworkResponse(false, -1, null);
//   }
//
//   /// Post request method
//   Future<NetworkResponse> postRequest(String url, Map<String, dynamic> body,
//       {bool isLogin = false}) async {
//     try {
//       MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
//       request.fields['data'] = jsonEncode(body);
//       StreamedResponse response = await request.send();
//       //log(response.statusCode.toString());
//       //log(await response.stream.bytesToString());
//       print(response.statusCode);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return NetworkResponse(
//           true,
//           response.statusCode,
//           jsonDecode(await response.stream.bytesToString()),
//         );
//       } else {
//         log('I am error');
//         return NetworkResponse(
//           false,
//           response.statusCode,
//           null,
//         );
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//     return NetworkResponse(false, -1, null);
//   }
//
//   /// PATCH request method
//   Future<NetworkResponse> updateRequest(String url, Map<String, dynamic> body, bool imageUpload, {File? file}
//       ) async {
//     try {
//       MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
//       request.fields['data'] = jsonEncode(body);
//       if(imageUpload){
//         request.files.add(await MultipartFile.fromPath('file', file!.path));
//       }
//       StreamedResponse response = await request.send();
//       //log(response.statusCode.toString());
//       //log(await response.stream.bytesToString());
//       print(response.statusCode);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return NetworkResponse(
//           true,
//           response.statusCode,
//           jsonDecode(await response.stream.bytesToString()),
//         );
//       } else {
//         log('I am error');
//         return NetworkResponse(
//           false,
//           response.statusCode,
//           null,
//         );
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//     return NetworkResponse(false, -1, null);
//   }
// }

// import 'package:dio/dio.dart' as dio;
//
// class NetworkCaller {
//   final dio.Dio _dio = dio.Dio();
//
//   Future<NetworkResponse> getRequest(String url, {bool isLogin = false}) async {
//     try {
//       dio.Response response = await _dio.get(
//         url,
//         options: dio.Options(
//           headers: {'Authorization': 'Bearer ${AuthController.accessToken}'},
//         ),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return NetworkResponse(
//           true,
//           response.statusCode ?? 200,
//           response.data, // Dio automatically parses JSON
//         );
//       } else {
//         log('Error occurred with status code: ${response.statusCode}');
//         return NetworkResponse(false, response.statusCode ?? -1, null);
//       }
//     } catch (dioError) {
//       log('Request failed: ${dioError.toString()}');
//       return NetworkResponse(false, -1, null);
//     }
//   }
// }
