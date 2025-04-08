import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/colors_constants.dart';
import '../../../../viewmodel/articles_controller.dart';
import 'article_details_screen.dart';

class ArticleSearchScreen extends StatefulWidget {
  const ArticleSearchScreen({super.key});

  @override
  State<ArticleSearchScreen> createState() => _ArticleSearchScreenState();
}

class _ArticleSearchScreenState extends State<ArticleSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Get.find<ArticleController>().filterArticles(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorGreenCard,
      appBar: AppBar(
        backgroundColor: AppColors.colorGreenCard,
        automaticallyImplyLeading: false,
        title: ReusableTextFormField(
          controller: _searchController,
          formFieldHint: "search_articles".tr,
          keyboardType: TextInputType.text,
          hasSuffixIcon: true,
          hasPrefixIcon: true,
          borderColor: AppColors.colorGreenCard,
          fillColor: Colors.white,
          onSuffixTap: () {
            Get.back();
          },
        ),
      ),
      body: GetBuilder<ArticleController>(
        builder: (controller) {
          // Show empty widget when there's no search query
          if (_searchController.text.isEmpty) {
            return Center(child: SvgPicture.asset("assets/images/search_big.svg"));
          }
          // Show message if no articles match the search query
          if (controller.filteredArticles.isEmpty) {
            return const Center(child: Text("No articles found", style: TextStyle(color: Colors.white),));
          }
          return Column(
            children: [
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
                    itemCount: controller.filteredArticles.length,
                    itemBuilder: (context, index) {
                      var article = controller.filteredArticles[index];
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
              style: TextStyle(
                fontSize: 12,
                color: AppColors.colorBlackLowEmp,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 8, top: 4),
            child: Text(
              title,
              style: TextStyle(
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
    int timestampInt = int.parse(timestamp);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);
    return DateFormat('dd/MM/yy').format(date);
  }
}


class ReusableTextFormField extends StatelessWidget {
  const ReusableTextFormField({
    super.key,
    required this.formFieldHint,
    this.controller,
    required this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLen,
    required this.hasSuffixIcon,
    required this.hasPrefixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.inputFormatters,
    this.prefixIconString,
    required this.borderColor,
    required this.fillColor,
  });

  final String formFieldHint;
  final String? prefixIconString;
  final bool hasSuffixIcon;
  final bool hasPrefixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText, readOnly;
  final int? maxLen;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Color borderColor, fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLen,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      enableSuggestions: false,
      readOnly: readOnly,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        isDense: true,
        hintText: formFieldHint,
        hintStyle: const TextStyle(
          color: Colors.black12,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: hasPrefixIcon ? GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onSuffixTap,
          child: const Padding(
              padding: EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 12),
              child: Icon(Icons.arrow_back, size: 24.0,)
          ),
        )
            : null,
        suffixIcon: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){},
          child: const Padding(
            padding: EdgeInsets.only(
                left: 12, right: 12, top: 12, bottom: 12),
            child: Icon(Icons.search, size: 24.0,),
          ),
        ),
        filled: true,
        fillColor: fillColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
            color: borderColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.black54,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      inputFormatters: inputFormatters,
      onChanged: onChanged,
    );
  }
}