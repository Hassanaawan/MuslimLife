import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/urls.dart';


class ArticleController extends GetxController {
  var articles = <ArticleModel>[].obs;
  var isLoading = false.obs;

  var categories = <CategoryModel>[].obs;
  var isLoadingCategory = false.obs;

  List<ArticleModel> filteredArticles = []; // Filtered articles

  @override
  void onInit() {
    fetchArticles();
    fetchCategories();
    loadArticles();
    super.onInit();
  }

  void fetchArticles() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse(Urls.fetchArticlesUrl));
      debugPrint("Articles fetch with response code ${response.statusCode}");
      if (response.statusCode == 200) {
        final jsonList = json.decode(response.body);
        if (jsonList is List) {
          // Ensure the JSON is a list of objects
          articles.value = jsonList.map((json) => ArticleModel.fromJson(json)).toList();
        } else {
          // Show an error if the JSON is not a list as expected
          Get.snackbar('Error', 'Unexpected JSON format.');
        }
      } else {
        // Handle non-200 status codes
        Get.snackbar('Error', 'Failed to load articles. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Show the error message if there's an exception
      Get.snackbar('Error', 'Failed to load articles: $e');
    } finally {
      isLoading(false);
      update();
    }
  }


  void fetchCategories() async {
    isLoadingCategory(true);
    try {
      final response = await http.get(Uri.parse(Urls.fetchCategoriesUrl));
      debugPrint("Categories fetch with response code ${response.statusCode}");
      if (response.statusCode == 200) {
        final jsonList = json.decode(response.body);
        if (jsonList is List) {
          // Ensure the JSON is a list of objects
          categories.value = jsonList.map((json) => CategoryModel.fromJson(json)).toList();
        } else {
          // Show an error if the JSON is not a list as expected
          Get.snackbar('Error', 'Unexpected JSON format.');
        }
      } else {
        // Handle non-200 status codes
        Get.snackbar('Error', 'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Show the error message if there's an exception
      Get.snackbar('Error', 'Failed to load categories: $e');
    } finally {
      isLoadingCategory(false);
      update();
    }
  }

  void loadArticles() {
    // Load articles from a source
    // Example: articles = loadYourArticles();
    // Initially, show all articles
    filteredArticles = articles;
    update();
  }

  void filterArticles(String query) {
    if (query.isEmpty) {
      filteredArticles = [];
    } else {
      filteredArticles = articles
          .where((article) => article.titleEnglish.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

}


class ArticleModel {
  final int indexId;
  final String id;
  final String originalUrl;
  final String thumbnailUrl;
  final String titleEnglish;
  final String titleMalay;
  final String contentEnglish;
  final String contentMalay;
  final String categoryId;
  final List<String> tag;
  final String timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryMalay;
  final String categoryEnglish;

  ArticleModel({
    required this.indexId,
    required this.id,
    required this.originalUrl,
    required this.thumbnailUrl,
    required this.titleEnglish,
    required this.titleMalay,
    required this.contentEnglish,
    required this.contentMalay,
    required this.categoryId,
    required this.tag,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryMalay,
    required this.categoryEnglish,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      indexId: json['id'],
      id: json['_id'],
      originalUrl: json['originalUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      titleEnglish: json['titleEnglish'],
      titleMalay: json['titleMalay'],
      contentEnglish: json['contentEnglish'],
      contentMalay: json['contentMalay'],
      categoryId: json['category_id'],
      tag: List<String>.from(json['tag']),
      timestamp: json['timestamp'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryMalay: json['categoryMalay'],
      categoryEnglish: json['categoryEnglish'],
    );
  }
}

class CategoryModel {
  String? id;
  String? internalId;
  String? categoryEnglish;
  String? categoryMalay;
  String? timestamp;
  String? createdAt;
  String? updatedAt;

  CategoryModel({
    this.id,
    this.internalId,
    this.categoryEnglish,
    this.categoryMalay,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor to initialize from JSON
  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    internalId = json['_id'];
    categoryEnglish = json['categoryEnglish'];
    categoryMalay = json['categoryMalay'];
    timestamp = json['timestamp'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['_id'] = internalId;
    data['categoryEnglish'] = categoryEnglish;
    data['categoryMalay'] = categoryMalay;
    data['timestamp'] = timestamp;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
