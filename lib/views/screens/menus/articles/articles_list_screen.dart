import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/colors_constants.dart';
import '../../../../viewmodel/articles_controller.dart';
import 'article_details_screen.dart';
import 'article_search_screen.dart';

class ArticlesListScreen extends StatefulWidget {
  const ArticlesListScreen({super.key});

  @override
  State<ArticlesListScreen> createState() => _ArticlesListScreenState();
}

class _ArticlesListScreenState extends State<ArticlesListScreen> {
  String selectedCategoryId = "all"; // Variable to track the selected category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorGreenCard,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColors.colorGreenCard,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "articles".tr,
              style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (){
                Get.to(
                    const ArticleSearchScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 500)
                );
              },
                child: const Icon(Icons.search, size: 24.0, color: Colors.white,)
            ),
            const SizedBox(width: 16,)
          ],
        ),
      ),
      body: GetBuilder<ArticleController>(
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length + 1, // +1 for the "All" category
                  itemBuilder: (context, index) {
                    String categoryId;
                    String categoryName;

                    if (index == 0) {
                      // The first item is the "All" category
                      categoryId = "all";
                      categoryName = "All"; // Label for "All"
                    } else {
                      categoryId = controller.categories[index - 1].internalId!; // Get category ID
                      categoryName = controller.categories[index - 1].categoryEnglish!; // Get category name
                    }

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryId = categoryId; // Update selected category ID
                        });
                      },
                      child: Container(
                        height: 30,
                        margin: EdgeInsets.only(right: 8.0, left: index == 0 ? 16.0 : 0.0),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: selectedCategoryId == categoryId ? AppColors.colorPrimaryLighter : AppColors.colorGreenDark,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              color: selectedCategoryId == categoryId ? Colors.white : Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4, // 2 for mobile, 4 for tablet
                      childAspectRatio: 0.9, // Adjust the aspect ratio if needed
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                    ),
                    itemCount: _getFilteredArticles(controller).length, // Get filtered articles count
                    itemBuilder: (context, index) {
                      var article = _getFilteredArticles(controller)[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            ArticleDetailsScreen(
                              title: article.titleEnglish,
                              thumbUrl: article.thumbnailUrl,
                              timestamp: article.timestamp,
                              content: article.contentEnglish,
                              index: index,
                            ),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: _buildArticleCard(article.thumbnailUrl, article.timestamp, article.titleEnglish),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to get filtered articles based on the selected category
  List<ArticleModel> _getFilteredArticles(ArticleController controller) {
    if (selectedCategoryId == "all") {
      return controller.articles; // Return all articles
    }
    return controller.articles.where((article) => article.categoryId == selectedCategoryId).toList();
  }

  Widget _buildArticleCard(String thumbnailUrl, String timestamp, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                thumbnailUrl,
                height: 110.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 4.0),
            child: Text(
              formatTimestamp(timestamp),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.colorBlackLowEmp,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 8, top: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14,
                height: 0.9,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    // Convert the timestamp string to an integer
    int timestampInt = int.parse(timestamp);

    // Convert the timestamp to milliseconds since Epoch
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);

    // Format the date to dd/MM/yy
    String formattedDate = DateFormat('dd/MM/yy').format(date);

    return formattedDate;
  }
}
