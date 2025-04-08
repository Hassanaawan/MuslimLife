import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/images_constants.dart';
import '../../models/azkar_category_model.dart';
import '../../models/dua_category_model.dart';
import '../../models/event_prayer_category_model.dart';
import '../../models/hadith_category_model.dart';
import '../../viewmodel/azkar_category_controller.dart';
import '../../viewmodel/dua_category_controller.dart';
import '../../viewmodel/event_prayer_category_controller.dart';
import '../../viewmodel/hadith_category_controller.dart';
import '../widgets/azkar_detail_card.dart';
import '../widgets/category_data_details_widget.dart';
import '../widgets/loading_dialog_widget.dart';
import '../widgets/app_background_widget.dart';
import '../widgets/app_bar_widget.dart';

class OthersCategoryOverviewScreen extends StatefulWidget {
  const OthersCategoryOverviewScreen({
    Key? key,
    required this.id,
    required this.categoryName,
    required this.cateSign,
    required this.categoryNameEng,
  }) : super(key: key);

  final String categoryName;
  final String categoryNameEng;
  final String cateSign;
  final String id;

  @override
  State<OthersCategoryOverviewScreen> createState() =>
      _OthersCategoryOverviewScreenState();
}

class _OthersCategoryOverviewScreenState extends State<OthersCategoryOverviewScreen> {
  List<HadithCategoryModel> hadithCategoryDataList = [];
  List<DuaCategoryModel> duaCategoryDataList = [];
  List<AzkarCategoryModel> azkarCategoryDataList = [];
  List<EventPrayerCategoryModel> eventPrayersCategoryDataList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Loading indicator method
      showLoadingDialog(context);
      await callAPIController();

      Get.back();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(int)> cardBuilders = {
      'HADITH': buildHadithCard,
      'DUA': buildDuaCard,
      'AZKAR': buildAzkarCard,
      'EVENT-PRAYERS': buildEventPrayersCard,
    };

    final List? dataList = getDataList();

    return Scaffold(
      body: Stack(
        children: [
          AppBackgroundWidget(
            bgImagePath: AppImages.backgroundSolidColorSVG,
          ),
          AppBarWidget(
            screenTitle: widget.categoryName,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 97, left: 16, right: 16, bottom: 16),
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 0),
              itemCount: dataList?.length ?? 0,
              itemBuilder: (context, index) {
                final builder = cardBuilders[widget.cateSign];
                if (builder != null) {
                  return builder(index);
                }
                return null;
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 8,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List? getDataList() {
    switch (widget.cateSign) {
      case 'HADITH':
        return hadithCategoryDataList;
      case 'DUA':
        return duaCategoryDataList;
      case 'AZKAR':
        return azkarCategoryDataList;
      case 'EVENT-PRAYERS':
        return eventPrayersCategoryDataList;
      default:
        return null;
    }
  }

  Widget buildHadithCard(int index) {
    final data = hadithCategoryDataList[index];
    return CategoryDataDetailsWidget(
      amolEnglish: data.hadithEnglish ?? '',
      amolArabic: data.hadithArabic ?? '',
      authorName: data.narratedBy ?? '',
      title: data.referenceBook ?? '',
      amolTurkish: data.hadithTurkish ?? '',
      amolUrdu: data.hadithUrdu ?? '',
      amolBangla: data.hadithBangla ?? '',
      amolFrench: data.hadithFrench ?? '',
      amolHindi: data.hadithHindi ?? '',
    );
  }

  Widget buildDuaCard(int index) {
    final data = duaCategoryDataList[index];
    return CategoryDataDetailsWidget(
      amolEnglish: data.duaEnglish ?? '',
      amolArabic: data.duaArabic ?? '',
      title: data.titleEnglish ?? '',
      amolTurkish: data.duaTurkish ?? '',
      amolUrdu: data.duaArabic ?? '',
      amolBangla: data.duaBangla ?? '',
      amolFrench: data.duaFrench ?? '',
      amolHindi: data.duaHindi ?? '',
    );
  }

  Widget buildAzkarCard(int index) {
    final data = azkarCategoryDataList[index];
    return AzkarDetailCard(
      azkarEnglish: data.azkarEnglish ?? '',
      azkarArabic: data.azkarArabic ?? '',
      azkarTurkish: data.azkarTurkish ?? '',
      azkarUrdu: data.azkarUrdu ?? '',
      azkarBangla: data.azkarBangla ?? '',
      azkarFrench: data.azkarFrench ?? '',
      azkarHindi: data.azkarHindi ?? '',
    );
  }

  Widget buildEventPrayersCard(int index) {
    final data = eventPrayersCategoryDataList[index];
    return AzkarDetailCard(
      azkarEnglish: data.eventPrayerEnglish ?? '',
      azkarArabic: data.eventPrayerArabic ?? '',
      azkarTurkish: '',
      azkarUrdu: '',
      azkarBangla: '',
      azkarFrench: '',
      azkarHindi: '',
    );
  }

  Future<void> callAPIController() async {
    switch (widget.cateSign) {
      case 'HADITH':
        await fetchHadithData();
        break;
      case 'DUA':
        await fetchDuaData();
        break;
      case 'AZKAR':
        await fetchAzkarData();
        break;
      case 'EVENT-PRAYERS':
        await fetchEventPrayersData();
        break;
      default:
        break;
    }
  }

  Future<void> fetchHadithData() async {
    await Get.find<HadithDataListController>()
        .getHadithCategoryData(widget.id);
    hadithCategoryDataList =
        Get.find<HadithDataListController>().hadithCategoryDataList;
  }

  Future<void> fetchDuaData() async {
    await Get.find<DuaCategoryController>()
        .getDuaCategoryData(widget.id);
    duaCategoryDataList =
        Get.find<DuaCategoryController>().duaCategoryDataList;
  }

  Future<void> fetchAzkarData() async {
    await Get.find<AzkarCategoryController>()
        .getAzkarCategoryData(widget.id);
    azkarCategoryDataList =
        Get.find<AzkarCategoryController>().azkarCategoryDataList;
  }

  Future<void> fetchEventPrayersData() async {
    await Get.find<EventPrayerCategoryController>()
        .getEventPrayerCategoryData(widget.id);
    eventPrayersCategoryDataList =
        Get.find<EventPrayerCategoryController>()
            .eventPrayerCategoryDataList;
  }

  // Loading indicator
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingDialogWidget();
      },
    );
  }
}
