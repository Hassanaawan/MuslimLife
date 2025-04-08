import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors_constants.dart';
import '../../constants/images_constants.dart';
import '../../models/category_list_model.dart';
import '../../viewmodel/categories_controller.dart';
import '../../viewmodel/language_validation_controller.dart';
import '../screens/others_category_details_screen.dart';
import '../screens/quran_details_screen.dart';
import 'item_category_card.dart';
import 'loading_dialog_widget.dart';
import 'app_background_widget.dart';
import 'app_bar_widget.dart';

class SubCategoryWidget extends StatefulWidget {
  const SubCategoryWidget(
      {super.key,
      required this.categoryTitle,
      required this.iconPath,
      required this.categoryName,
      required this.cateSign});

  final String categoryTitle, iconPath, categoryName, cateSign;

  @override
  State<SubCategoryWidget> createState() =>
      _SubCategoryWidgetState();
}

class _SubCategoryWidgetState
    extends State<SubCategoryWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      widget.cateSign == 'AL-QURAN'
          ? await Get.find<CategoriesController>()
              .getCategoryList(widget.cateSign)
          : await Get.find<CategoriesController>()
              .getCategoryList(widget.categoryName);
      await LanguageValidationController.getLanguage();
    });
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackgroundWidget(
            bgImagePath: AppImages.backgroundSolidColorSVG,
          ),
          AppBarWidget(
            screenTitle: widget.categoryTitle,
          ),
          GetBuilder<CategoriesController>(builder: (categoryListController) {
            if (categoryListController.categoryDataFetchInProgress) {
              return const LoadingDialogWidget();
            }
            if (categoryListController.categoryList.isEmpty &&
                (categoryListController.surahListModel.data?.isEmpty ?? true)) {
              return Center(
                child: Text(
                  '${widget.categoryTitle.tr} is empty!',
                  style: const TextStyle(color: AppColors.colorWhiteHighEmp, fontSize: 20),
                ),
              );
            }
            final List<CategoryListModel> categoryListData =
                categoryListController.categoryList;
            return Padding(
              padding: const EdgeInsets.only(
                  top: 80, bottom: 16),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.cateSign == 'AL-QURAN'
                    ? categoryListController.surahListModel.data?.length ?? 0
                    : categoryListData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      widget.cateSign == 'AL-QURAN'
                          ? Get.to(() => QuranDetailsScreen(
                                surahName:
                                    LanguageValidationController.setLang == 'ar'
                                        ? categoryListController
                                        .surahListModel
                                        .data![index]
                                        .name!
                                        .short!
                                        : categoryListController
                                        .surahListModel
                                        .data![index]
                                        .name!
                                        .transliteration!
                                        .en!,
                                surahNumber: index + 1,
                              ))
                      ///Hadith, Dua, Azkar
                          : Get.to(
                              () => OthersCategoryOverviewScreen(
                                categoryName:
                                    LanguageValidationController.setLang == 'en'
                                        ? categoryListData[index].categoryEnglish ?? ''
                                        : LanguageValidationController.setLang == 'tr'
                                        ? categoryListData[index].categoryTurkish ?? ''
                                        : LanguageValidationController.setLang == 'ur'
                                        ? categoryListData[index].categoryUrdu ?? ''
                                        : LanguageValidationController.setLang == 'bn'
                                        ? categoryListData[index].categoryBangla ?? ''
                                        : LanguageValidationController.setLang == 'fr'
                                        ? categoryListData[index].categoryFrench ?? ''
                                        : LanguageValidationController.setLang == 'hi'
                                        ? categoryListData[index].categoryHindi ?? ''
                                        : categoryListData[index].categoryArabic ?? '',
                                cateSign: widget.cateSign, categoryNameEng: categoryListData[index]
                                  .categoryEnglish ??
                                  '', id: categoryListData[index].sId ?? '',
                              ),
                            );
                    },

                    ///Surah name
                    ///hadith
                    ///Azkar Dua
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: ItemCategoryCard(
                        iconImagePath: widget.iconPath,
                        title: widget.cateSign == 'AL-QURAN'
                            ? LanguageValidationController.setLang == 'ar'
                                ? categoryListController.surahListModel.data![index].name!.short!
                                : categoryListController.surahListModel.data![index].name!.transliteration!.en!
                            : LanguageValidationController.setLang == 'en'
                                ? categoryListData[index].categoryEnglish ?? ''
                                : LanguageValidationController.setLang == 'tr'
                            ? categoryListData[index].categoryTurkish ?? ''
                            : LanguageValidationController.setLang == 'ur' ? categoryListData[index].categoryUrdu ?? ''
                            : LanguageValidationController.setLang == 'bn' ? categoryListData[index].categoryBangla?? ''
                            : LanguageValidationController.setLang == 'fr' ? categoryListData[index].categoryFrench?? ''
                            : LanguageValidationController.setLang == 'hi' ? categoryListData[index].categoryHindi?? ''
                            : categoryListData[index].categoryArabic?? '',
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
