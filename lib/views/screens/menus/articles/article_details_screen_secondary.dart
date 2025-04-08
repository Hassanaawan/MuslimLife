import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/colors_constants.dart';
import '../../../../viewmodel/articles_controller.dart';
import 'article_details_screen.dart';

class ArticleDetailsScreenSecondary extends StatefulWidget {
  const ArticleDetailsScreenSecondary({super.key, required this.title, required this.thumbUrl, required this.timestamp, required this.content, required this.index});

  final String title, thumbUrl, timestamp, content;
  final int index;

  @override
  State<ArticleDetailsScreenSecondary> createState() => _ArticleDetailsScreenSecondaryState();
}

class _ArticleDetailsScreenSecondaryState extends State<ArticleDetailsScreenSecondary> {
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
              onTap: (){
                Get.back();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: Icon(Icons.arrow_back_rounded, size: 24.0, color: Colors.white,),
              ),
            ),
            Text(
              "articles_details".tr,
              style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600, height: 1.1),
                  ),
                  const SizedBox(height: 12.0,),
                  Container(
                    height: 116,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.thumbUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0,),
                  Row(
                    children: [
                      Text(
                        widget.timestamp,
                        style: const TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        height: 10.0,
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        color: Colors.white,
                      ),
                      Text(
                        "author".tr,
                        style: const TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0,),
                  HtmlWidget(
                    widget.content,
                  ),
                  const SizedBox(height: 12.0,),
                  Text(
                    'related_articles'.tr,
                    style: const TextStyle(
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 230,
              child:
              GetBuilder<ArticleController>(
                  builder: (controller) {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary,));
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.articles.length,
                          padding: const EdgeInsets.only(bottom: 16.0, top: 12.0),
                          itemBuilder: (context, index) {
                            if (index == widget.index) return const SizedBox.shrink();
                            var article = controller.articles[index];
                            return GestureDetector(
                              onTap: (){
                                print("iiiii");
                                Get.off(
                                    ArticleDetailsScreen(
                                      title: article.titleEnglish,
                                      thumbUrl: article.thumbnailUrl,
                                      timestamp: article.timestamp,
                                      content: article.contentEnglish,
                                      index: index,
                                    ),
                                    transition: Transition.rightToLeft,
                                    duration: const Duration(milliseconds: 500)
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: index == 0? 16.0 : 16.0, right: index == controller.articles.length-1? 16.0: 0.0),
                                child: _buildArticleCard(
                                  article.thumbnailUrl,
                                  article.timestamp,
                                  article.titleEnglish,
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(
      String thumbnailUrl, timestamp, title
      ) {
    return Container(
      width: 196,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130.0,
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
                  height: 130.0,
                  fit: BoxFit.cover,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 4.0),
            child: Text(
              formatTimestamp(timestamp),
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.colorBlackLowEmp
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
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
