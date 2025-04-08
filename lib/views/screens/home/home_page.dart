import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Muslimlife/views/screens/home/tasbih_counter_view.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/fonts_weights.dart';
import '../../../constants/images_constants.dart';
import '../../../services/prayer_time_service.dart';
import '../../../viewmodel/Providers/location_data_provider.dart';
import '../../../viewmodel/articles_controller.dart';
import '../../../viewmodel/bottom_nav_viewmodel.dart';
import '../../../viewmodel/providers/hadith_provider.dart';
import '../../../viewmodel/providers/link_data_provider.dart';
import '../../../viewmodel/providers/user_data_provider.dart';
import '../../../viewmodel/providers/wallpaper_data_provider.dart';
import '../../widgets/loading_dialog_widget.dart';
import '../menus/articles/article_details_screen.dart';
import '../menus/articles/articles_list_screen.dart';
import '../menus/islamic_calender.dart';
import '../menus/menu_bottom_sheet.dart';
import '../menus/near_by_mosques_screen.dart';
import '../qibla/compass_view.dart';
import '../wallpapers/all_wallpapers_view.dart';
import '../wallpapers/set_background.dart';
import 'daily_dua_screen.dart';
import 'daily_hadith_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final bool loadUserData;

  const HomePage({super.key, required this.loadUserData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final BottomNavViewModel bottomNavController = Get.put(BottomNavViewModel());
  late HijriCalendar today;

  @override
  void initState() {
    super.initState();
    readJson();
    loadData();
    startTimer();

    /// Initialize Hijri calendar date here
    today = HijriCalendar.now();
  }

  Future<void> loadData() async {
    Provider.of<UserDataProvider>(context, listen: false)
        .fetchLoggedInUserData(widget.loadUserData);
    Provider.of<HadithProvider>(context, listen: false).getLanguage();
    Provider.of<LocationDataProvider>(context, listen: false).getLocation();
    Provider.of<LinkDataProvider>(context, listen: false).fetchData();
  }

  Timer? _timer;
  int remainingTime = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
      });
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    final provider = Provider.of<LocationDataProvider>(context, listen: false);
    return Consumer<UserDataProvider>(builder: (context, userProvider, child) {
      return Stack(
        children: [
          Scaffold(
            key: _scaffoldKey,
            endDrawer: buildDrawer(context),
            body: Container(
              decoration:
                  const BoxDecoration(color: AppColors.colorWhiteHighEmp),
              child: Column(
                children: [
                  SizedBox(height: 40.h),

                  ///Appbar
                  _buildAppBar(),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 16.h),
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                _buildAlermTime(),
                                SizedBox(height: 10.h),

                                ///Carousel Slider
                                _buildCarouselSlider(),
                                SizedBox(height: 4.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _buildPageIndicator(),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.colorWhiteHighEmp
                                        .withOpacity(0.2),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ///Next Prayer Time
                                      _buildNextPrayerTimeWithChart(provider),
                                      SizedBox(height: 14.h),

                                      ///All Prayer Time
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: homePrayerTimeWidget(),
                                      ),
                                      SizedBox(height: 14.h),

                                      ///Wallpaper
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: _buildWallpaper(),
                                      ),

                                      ///Today Hadith
                                      SizedBox(height: 14.h),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "today_hadith".tr,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors
                                                      .colorBlackHighEmp),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: _buildTodayHadithCard(),
                                      ),
                                      SizedBox(height: 14.h),

                                      ///today Dua
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: _buildTodayDuaCard(),
                                      ),
                                      SizedBox(height: 14.h),

                                      ///Blog
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'articles'.tr,
                                              style: const TextStyle(
                                                  color: AppColors.colorBlack,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ArticlesListScreen(),
                                                    transition: Transition.rightToLeft,
                                                    duration: const Duration(milliseconds: 500));
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'see_all'.tr,
                                                    style: const TextStyle(
                                                      color: AppColors.colorBlackLowEmp,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 4.0,
                                                      left: 4.0,
                                                    ),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios_outlined,
                                                      size: 12,
                                                      color: AppColors.colorBlackLowEmp,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 8.h),

                                      SizedBox(
                                        height: 220,
                                        child:
                                        GetBuilder<ArticleController>(
                                            builder: (controller) {
                                              if (controller.isLoading.value) {
                                                return const Center(
                                                    child: CircularProgressIndicator(
                                                      color: AppColors.colorPrimary,
                                                    ));
                                              } else if (controller.articles.isEmpty) {
                                                return Center(
                                                    child: Container(
                                                      height: 220,
                                                      width: double.maxFinite,
                                                      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(8.0)),
                                                      child: const Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Icon(
                                                              Icons.error_outline,
                                                              size: 34,
                                                            ),
                                                            Text(
                                                              "No articles found!!",
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                              } else {
                                                return ListView.builder(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    itemCount: controller
                                                        .articles.length,
                                                    padding:
                                                    const EdgeInsets.only(
                                                        bottom: 16.0),
                                                    itemBuilder:
                                                        (context, index) {
                                                      var article = controller
                                                          .articles[index];
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
                                                              duration: const Duration(milliseconds: 500));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                            left: index == 0 ? 16.0 : 0.0,
                                                            right: index == controller.articles.length - 1 ? 16.0 : 12,
                                                          ),
                                                          child: _buildArticleCard(article.thumbnailUrl, article.timestamp, article.titleEnglish,),
                                                        ),
                                                      );
                                                    });
                                              }
                                            }),
                                      ),
                                      SizedBox(height: 14.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavigation(context),
          ),
          userProvider.userDataLoading
              ? Scaffold(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  body: const LoadingDialogWidget(),
                )
              : const SizedBox(),
        ],
      );
    });
  }

  Widget _buildAlermTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<LocationDataProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 100.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.colorGradient1Start,
                  AppColors.colorGradient1End
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "${DateFormat('EEEE').format(DateTime.now())}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeights.semiBold,
                        color: AppColors.colorWarning,
                      ),
                    ),
                    Text(
                      "${today.hDay} - ${today.longMonthName} - ${today.hYear}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeights.regular,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                    ),
                    Text(
                      "${DateFormat('d\'${provider.getDaySuffix(DateTime.now().day)}\' - MMMM - y').format(DateTime.now())}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeights.regular,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 80,
                  width: 1,
                  color: AppColors.colorGrey,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (provider.prayerTimes != null &&
                        provider.prayerTimes!.isNotEmpty) ...[
                      Text(
                        "Sahrih End Time: ${provider.formatPrayerTime(
                          provider.prayerTimes![0].fajr.subtract(
                            const Duration(minutes: 5),
                          ),
                        )}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeights.regular,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                      ),
                      Text(
                        "Iftar End Time: ${provider.formatPrayerTime(provider.prayerTimes![0].maghrib)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeights.regular,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        "Prayer times not available",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeights.regular,
                          color: AppColors
                              .colorWarning, // Change color to suit your design
                        ),
                      ),
                    ],
                    GestureDetector(
                      onTap: () async {
                        if (Platform.isAndroid) {
                          try {
                            const intent = AndroidIntent(
                              action: 'android.intent.action.SET_ALARM',
                            );
                            await intent.launch();
                          } catch (e) {
                            print('Error launching alarm intent: $e');
                            // Fallback option
                            try {
                              const fallbackIntent = AndroidIntent(
                                action: 'android.intent.action.MAIN',
                                category: 'android.intent.category.DEFAULT',
                                package: 'com.android.deskclock',
                              );
                              await fallbackIntent.launch();
                            } catch (e) {
                              print('Error launching fallback intent: $e');
                            }
                          }
                        } else if (Platform.isIOS) {
                          // For iOS devices
                          final url = Uri.parse('clock-setup://');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.colorWarning),
                        ),
                        child: const Text(
                          "Set Alarm",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.colorWarning,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWallpaper() {
    return Consumer<WallpaperDataProvider>(
      builder: (context, provider, child) {
        if (provider.allWallpapers == null || provider.allWallpapers!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "b_three_header".tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorWhiteHighEmp),
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 150.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 8.0 : 4.0,
                          right: index == 10 - 1 ? .0 : 4.0,
                        ),
                        child: Container(
                          width: 200.h,
                          height: 150.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.colorGradient1Start,
                                AppColors.colorGradient1End
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: const Center(
                              child: Text(
                            "Wallpaper not available.",
                            style:
                                TextStyle(color: AppColors.colorWhiteHighEmp),
                          )),
                        ),
                      );
                    }),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "b_three_header".tr,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorBlackHighEmp),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 150.h,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 8.0 : 4.0,
                      right: index == 10 - 1 ? 8.0 : 4.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetBackground(
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 200.h,
                        height: 150.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                provider.allWallpapers![index].thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              BorderRadius.circular(16), // Rounded corners
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 70.h,
      width: double.infinity,
      color: AppColors.colorWhiteHighEmp,
      child: SingleChildScrollView(
        controller: bottomNavController.scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 4.h),

            ///Home
            SizedBox(
              width: 60.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.homeIconPNG,
                    height: 20.h,
                    color: AppColors.colorPrimary,
                  ),
                  Text(
                    'home'.tr,
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
            ),

            ///Tasbih
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Container(
                width: 1,
                height: double.infinity,
                color: AppColors.colorWhiteMidEmp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const TasbihCounterView(data: ''));
              },
              child: SizedBox(
                width: 70.h, // Define a specific width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.tasbihCounterPNG,
                      height: 20.h,
                    ),
                    Text(
                      'tasbih'.tr,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),

            ///Quran
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Container(
                width: 1,
                height: double.infinity,
                color: AppColors.colorWhiteMidEmp,
              ),
            ),
            GestureDetector(
              onTap: () {
                getCategories('dua-categories', 'AL-QURAN');
              },
              child: SizedBox(
                width: 70.h, // Define a specific width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.alQuranPNG,
                      height: 20.h,
                    ),
                    Text(
                      'alquran'.tr,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),

            ///Qibla
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Container(
                width: 1,
                height: double.infinity,
                color: AppColors.colorWhiteMidEmp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const CompassView());
              },
              child: SizedBox(
                width: 70.h, // Define a specific width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.compassSVG,
                      height: 20.h,
                    ),
                    Text(
                      'qibla_compass2'.tr,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),

            ///Calender
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Container(
                width: 1,
                height: double.infinity,
                color: AppColors.colorWhiteMidEmp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => HijriDatePickerDialog(
                    initialDate: HijriCalendar.now(),
                    firstDate: HijriCalendar.addMonth(1356, 1),
                    lastDate: HijriCalendar.addMonth(1499, 1),
                    initialDatePickerMode: DatePickerMode.day,
                  ),
                );
              },
              child: SizedBox(
                width: 70.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.calenderPNG,
                      height: 20.h,
                    ),
                    Text(
                      'calender'.tr,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),

            ///Hadith
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Container(
                width: 1,
                height: double.infinity,
                color: AppColors.colorWhiteMidEmp,
              ),
            ),
            GestureDetector(
              onTap: () {
                getCategories('hadith-categories', 'HADITH');
              },
              child: SizedBox(
                width: 70.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.hadithPNG,
                      height: 20.h,
                    ),
                    Text(
                      'hadith'.tr,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),

            ///Dua
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Container(
                width: 1,
                height: double.infinity,
                color: AppColors.colorWhiteMidEmp,
              ),
            ),
            GestureDetector(
              onTap: () {
                getCategories('dua-categories', 'DUA');
              },
              child: SizedBox(
                width: 70.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.duaPNG,
                      height: 20.h,
                    ),
                    Text(
                      'dua'.tr,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),

            ///Location
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Container(
                width: 1,
                height: double.infinity,
                color: AppColors.colorWhiteMidEmp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const NearbyMosquesScreen());
              },
              child: SizedBox(
                width: 70.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.mosquePNG,
                      height: 20.h,
                    ),
                    Text(
                      'location'.tr,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.h),
          ],
        ),
      ),
    );
  }

  ///Fetch Zikir from json
  List _zikir = [];

  Future<void> readJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language');
    print(language);
    String jsonAssetPath = 'assets/locales/zikir_ar.json';
    if (language == 'en') {
      jsonAssetPath = 'assets/locales/zikir_en.json';
    } else if (language == 'ar') {
      jsonAssetPath = 'assets/locales/zikir_ar.json';
    }

    final String response = await rootBundle.loadString(jsonAssetPath);
    final data = await json.decode(response);
    setState(() {
      _zikir = data['data'];
    });
  }

  ///Home screen appBar widget
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Consumer<UserDataProvider>(
        builder: (context, userProvider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      AppImages.appLogo,
                      height: 46.h,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    child: Text(
                      'assalamu_alaikum'.tr,
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeights.semiBold,
                          color: AppColors.colorBlackHighEmp,
                          height: 0.9),
                    ),
                  ),
                ],
              ),

              ///Drawer
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  ///CarouselSlider Widget
  Widget _buildCarouselSlider() {
    return CarouselSlider(
      items: [
        buildCarouselItem(
          image: AppImages.bannerImageOne,
          header: 'b_one_header'.tr,
          title: 'b_one_title'.tr,
          buttonText: 'b_one_btn'.tr,
          onTap: () {
            Get.to(() => const TasbihCounterView(data: ''));
          },
          index: 0,
        ),
        buildCarouselItem(
          image: AppImages.bannerImageTwo,
          header: 'b_two_header'.tr,
          title: 'b_two_title'.tr,
          buttonText: 'b_two_btn'.tr,
          onTap: () {
            getCategories('dua-categories', 'AL-QURAN');
          },
          index: 1,
        ),
        buildCarouselItem(
          image: AppImages.bannerImageThree,
          header: 'b_three_header'.tr,
          title: 'b_three_title'.tr,
          buttonText: 'b_three_btn'.tr,
          onTap: () {
            Get.to(() => const AllWallpapersView());
          },
          index: 2,
        ),
      ],
      options: CarouselOptions(
        height: MediaQuery.of(context).size.width*0.5,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.95,
        onPageChanged: (index, reason) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }

  Widget buildCarouselItem({
    required String image,
    required String header,
    required String title,
    required String buttonText,
    required VoidCallback onTap,
    required int index,
  }) {
    return Container(
      // height: 100.h,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.colorWhiteHighEmp,
                height: 3.h,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.caprasimo(
                textStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorWhiteHighEmp,
                  height: 0.9.h,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onTap,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: index == 2
                          ? AppColors.colorWarning
                          : AppColors.colorPrimary,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.colorWhiteHighEmp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 7.h,
      width: isActive ? 18.w : 8.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.sliderIndicator : AppColors.colorGrey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  ///Home screen prayer time widget
  Widget homePrayerTimeWidget() {
    return Consumer<LocationDataProvider>(builder: (context, provider, child) {
      return Stack(
        children: [
          Container(
            // height: 370.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  AppColors.colorGradient1Start,
                  AppColors.colorGradient1End
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowColor,
                  spreadRadius: -2.0,
                  blurRadius: 4,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        // height: 290.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.colorGradient1Start,
                              AppColors.colorGradient1End
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              spreadRadius: -2.0,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 60.h,
                                  width: 40.w,
                                  child: Image.asset(
                                    AppImages.lampTwo,
                                  ),
                                ),

                                ///locations
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0, left: 8.0, right: 8.0),
                                  child: Container(
                                    height: 40.h,
                                    width: 200.w,
                                    constraints:
                                        BoxConstraints(maxWidth: 350.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.colorGreenCard),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, right: 5.0),
                                          child: Icon(
                                            Icons.location_on,
                                            color: AppColors.indicatorColor,
                                            size: 16.sp,
                                          ),
                                        ),
                                        provider.locationName == ''
                                            ? SizedBox(
                                                width: 150.w,
                                                child: Center(
                                                  child: Text(
                                                    'loading.....',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .colorPrimaryLighter,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.sp),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                width: 150.w,
                                                child: Text(
                                                  provider.locationName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .indicatorColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.sp),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                  width: 40.w,
                                  child: Image.asset(
                                    AppImages.lampTwo,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'prayer_time'.tr,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeights.regular,
                                  color: AppColors.colorWhiteHighEmp,
                                ),
                              ),
                            ),
                            Text(
                              DateFormat(
                                      'd\'${provider.getDaySuffix(DateTime.now().day)}\' MMMM y')
                                  .format(DateTime.now()),
                              style: TextStyle(
                                  fontSize: 12.sp, color: AppColors.colorAlert),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ///Fajr Namaz
                                  Container(
                                    height: 36.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.h),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PrayerTimeService.instance
                                                    .isCurrentTime('Fajr')
                                                ? AppColors.colorWarning
                                                : AppColors.colorBlueLight),
                                        borderRadius: BorderRadius.circular(8),
                                        color: PrayerTimeService.instance
                                                .isCurrentTime('Fajr')
                                            ? AppColors.colorGreenCard
                                            : Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.fazrSVG,
                                              height: 18.h,
                                            ),
                                            SizedBox(width: 2.h),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                'fajr'.tr,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .colorWhiteHighEmp,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeights.semiBold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (provider.prayerTimes!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.h,
                                                right: 12.h,
                                                bottom: 0.h),
                                            child: Text(
                                              provider.formatPrayerTime(provider
                                                  .prayerTimes![0].fajr),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      FontWeights.semiBold),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  ///Duhr
                                  SizedBox(height: 8.h),
                                  Container(
                                    height: 36.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.h),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PrayerTimeService.instance
                                                    .isCurrentTime("Duh'r")
                                                ? AppColors.colorWarning
                                                : AppColors.colorBlueLight),
                                        borderRadius: BorderRadius.circular(8),
                                        color: PrayerTimeService.instance
                                                .isCurrentTime("Duh'r")
                                            ? AppColors.colorGreenCard
                                            : Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.duhrSVG,
                                              height: 18.h,
                                            ),
                                            SizedBox(width: 2.h),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                'duhr'.tr,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .colorWhiteHighEmp,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeights.semiBold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (provider.prayerTimes!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.h,
                                                right: 12.h,
                                                bottom: 0.h),
                                            child: Text(
                                              provider.formatPrayerTime(provider
                                                  .prayerTimes![0].dhuhr),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      FontWeights.semiBold),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  ///Asr
                                  SizedBox(height: 8.h),
                                  Container(
                                    height: 36.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.h),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PrayerTimeService.instance
                                                    .isCurrentTime('Asr')
                                                ? AppColors.colorWarning
                                                : AppColors.colorBlueLight),
                                        borderRadius: BorderRadius.circular(8),
                                        color: PrayerTimeService.instance
                                                .isCurrentTime('Asr')
                                            ? AppColors.colorGreenCard
                                            : Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.asrSVG,
                                              height: 18.h,
                                            ),
                                            SizedBox(width: 2.h),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                'asr'.tr,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .colorWhiteHighEmp,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeights.semiBold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (provider.prayerTimes!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.h,
                                                right: 12.h,
                                                bottom: 0.h),
                                            child: Text(
                                              provider.formatPrayerTime(
                                                  provider.prayerTimes![0].asr),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      FontWeights.semiBold),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  ///magrib
                                  SizedBox(height: 8.h),
                                  Container(
                                    height: 36.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.h),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PrayerTimeService.instance
                                                    .isCurrentTime('Magrib')
                                                ? AppColors.colorWarning
                                                : AppColors.colorBlueLight),
                                        borderRadius: BorderRadius.circular(8),
                                        color: PrayerTimeService.instance
                                                .isCurrentTime('Magrib')
                                            ? AppColors.colorGreenCard
                                            : Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.magribSVG,
                                              height: 18.h,
                                            ),
                                            SizedBox(width: 2.h),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                'magrib'.tr,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .colorWhiteHighEmp,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeights.semiBold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (provider.prayerTimes!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.h,
                                                right: 12.h,
                                                bottom: 0.h),
                                            child: Text(
                                              provider.formatPrayerTime(provider
                                                  .prayerTimes![0].maghrib),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      FontWeights.semiBold),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  ///Ishaa
                                  SizedBox(height: 8.h),
                                  Container(
                                    height: 36.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.h),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PrayerTimeService.instance
                                                    .isCurrentTime("Isha'a")
                                                ? AppColors.colorWarning
                                                : AppColors.colorBlueLight),
                                        borderRadius: BorderRadius.circular(8),
                                        color: PrayerTimeService.instance
                                                .isCurrentTime("Isha'a")
                                            ? AppColors.colorGreenCard
                                            : Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.ishaSVG,
                                              height: 18.h,
                                            ),
                                            SizedBox(width: 2.h),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                'isha'.tr,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .colorWhiteHighEmp,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeights.semiBold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (provider.prayerTimes!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.h,
                                                right: 12.h,
                                                bottom: 0.h),
                                            child: Text(
                                              provider.formatPrayerTime(provider
                                                  .prayerTimes![0].isha),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      FontWeights.semiBold),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                ///Sunrise and Sunset
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.sunsetSVG,
                            height: 28.h,
                            color: AppColors.colorWarning,
                          ),
                          SizedBox(width: 8.h),
                          if (provider.prayerTimes!.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'sun_set'.tr,
                                    style: const TextStyle(
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 12,
                                        fontWeight: FontWeights.regular),
                                  ),
                                  Text(
                                    provider.formatPrayerTime(
                                        provider.prayerTimes![0].maghrib),
                                    style: TextStyle(
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeights.semiBold),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: Container(
                          width: 1,
                          height: 40.h,
                          color: AppColors.colorWarning,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.fazrSVG,
                            height: 28.h,
                            color: AppColors.colorWarning,
                          ),
                          SizedBox(width: 8.h),
                          if (provider.prayerTimes!.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'sun_rise'.tr,
                                    style: const TextStyle(
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 12,
                                        fontWeight: FontWeights.regular),
                                  ),
                                  Text(
                                    provider.formatPrayerTime(provider
                                        .prayerTimes![0].sunrise
                                        .subtract(const Duration(minutes: 3))),
                                    style: TextStyle(
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeights.semiBold),
                                  )
                                ],
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
          provider.initPosition == null
              ? Center(
                  child: Container(
                    margin: EdgeInsets.all(16.w),
                    height: 330.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'unable'.tr,
                            style: const TextStyle(
                                color: AppColors.colorWhiteHighEmp),
                          ),
                          Text(
                            'turn_on_device_location'.tr,
                            style: const TextStyle(
                              color: AppColors.colorWhiteHighEmp,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Provider.of<LocationDataProvider>(context,
                                        listen: false)
                                    .getLocation();
                              },
                              child: Container(
                                height: 100.h,
                                width: 100.w,
                                padding: const EdgeInsets.only(top: 30),
                                child: const Icon(
                                  Icons.refresh,
                                  color: AppColors.colorWhiteHighEmp,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      );
    });
  }

  Widget _buildTodayHadithCard() {
    return Consumer<HadithProvider>(
      builder: (context, hadithProvider, child) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                AppColors.colorGradient1Start,
                AppColors.colorGradient1End
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                spreadRadius: -2.0,
                blurRadius: 4,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            border: Border.all(color: AppColors.colorGrey),
          ),
          child: hadithProvider.randomHadithIndexes.isEmpty
              ? const Center(child: Text(""))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Loop to display each Hadith
                    for (int i = 0;
                        i < hadithProvider.randomHadithIndexes.length;
                        i++)
                      hadithProvider.allHadith != null &&
                              hadithProvider.allHadith!.length >
                                  hadithProvider.randomHadithIndexes[i]
                          ? InkWell(
                              onTap: () {
                                // Navigate to DailyHadithScreen with the selected index
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DailyHadithScreen(
                                      hadithIndex:
                                          hadithProvider.randomHadithIndexes[i],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  /// Display Arabic text for each Hadith
                                  Text(
                                    hadithProvider
                                        .allHadith![hadithProvider
                                            .randomHadithIndexes[i]]
                                        .hadithArabic!,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.colorWhiteHighEmp,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    _getTranslation(hadithProvider,
                                        hadithProvider.randomHadithIndexes[i]),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.colorWhiteHighEmp,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  if (i <
                                      hadithProvider
                                              .randomHadithIndexes.length -
                                          1)
                                    const Divider(
                                      color: AppColors.colorGrey,
                                    ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                    GestureDetector(
                      onTap: () {
                        Get.to(getCategories('hadith-categories', 'HADITH'));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.colorGrey),
                              borderRadius: BorderRadius.circular(16)),
                          child: const Text(
                            "See More",
                            style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontWeight: FontWeights.semiBold),
                          )),
                    ),
                  ],
                ),
        );
      },
    );
  }

  String _getTranslation(HadithProvider hadithProvider, int index) {
    switch (hadithProvider.language) {
      case 'en':
        return hadithProvider.allHadith![index].hadithEnglish!;
      case 'ur':
        return hadithProvider.allHadith![index].hadithUrdu!;
      case 'tr':
        return hadithProvider.allHadith![index].hadithTurkish!;
      case 'bn':
        return hadithProvider.allHadith![index].hadithBangla!;
      case 'fr':
        return hadithProvider.allHadith![index].hadithFrench!;
      case 'hi':
        return hadithProvider.allHadith![index].hadithHindi!;
      default:
        return "";
    }
  }

  ///Random Dua Widget
  Widget _buildTodayDuaCard() {
    return Consumer<HadithProvider>(builder: (context, duaProvider, child) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              AppColors.colorGradient1Start,
              AppColors.colorGradient1End
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: -2.0,
              blurRadius: 4,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          border: Border.all(color: AppColors.colorGrey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "today_dua".tr,
              style: TextStyle(
                color: AppColors.colorWhiteHighEmp,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),

            /// Display three duas with dividers
            for (int i = 0; i < 3; i++)
              if (duaProvider.randomDuaIndexes.length >
                  i) // Ensure we have at least 3 random indexes
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the detail page for the selected Dua using its index
                        Get.to(
                          DailyDuaScreen(
                            duaIndex: duaProvider.randomDuaIndexes[
                                i], // Pass the random index here
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          duaProvider.language == 'ar'
                              ? duaProvider
                                  .allDua![duaProvider.randomDuaIndexes[i]]
                                  .duaArabic!
                              : duaProvider.language == 'en'
                                  ? duaProvider
                                      .allDua![duaProvider.randomDuaIndexes[i]]
                                      .duaEnglish!
                                  : duaProvider.language == 'ur'
                                      ? duaProvider
                                          .allDua![
                                              duaProvider.randomDuaIndexes[i]]
                                          .duaUrdu!
                                      : duaProvider.language == 'tr'
                                          ? duaProvider
                                              .allDua![duaProvider
                                                  .randomDuaIndexes[i]]
                                              .duaTurkish!
                                          : duaProvider.language == 'bn'
                                              ? duaProvider
                                                  .allDua![duaProvider
                                                      .randomDuaIndexes[i]]
                                                  .duaBangla!
                                              : duaProvider.language == 'fr'
                                                  ? duaProvider
                                                      .allDua![duaProvider
                                                          .randomDuaIndexes[i]]
                                                      .duaFrench!
                                                  : duaProvider
                                                      .allDua![duaProvider
                                                          .randomDuaIndexes[i]]
                                                      .duaHindi!,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14.sp,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.colorWhiteHighEmp,
                          ),
                        ),
                      ),
                    ),
                    if (i < 2)
                      const Divider(
                        color: AppColors.colorGrey,
                        thickness: 1,
                      ),
                  ],
                )
              else
                const SizedBox.shrink(),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Get.to(getCategories('dua-categories', 'DUA'));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorGrey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "See More",
                  style: TextStyle(
                    color: AppColors.colorWhiteHighEmp,
                    fontWeight: FontWeights.semiBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  ///Name generating banner widget
  Widget _buildNextPrayerTimeWithChart(LocationDataProvider locationProvider) {
    // Check if prayer times are available
    if (locationProvider.prayerTimes == null ||
        locationProvider.prayerTimes!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 200.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.colorGradient1Start,
                AppColors.colorGradient1End
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Center(
              child: Text('Prayer times not available.',
                  style: TextStyle(color: AppColors.colorWhiteHighEmp))),
        ),
      );
    }

    /// Update the current prayer times using the service
    PrayerTimeService.instance.determineCurrentPrayerTime(locationProvider);

    String remainingTime = PrayerTimeService.instance.getRemainingTime();

    /// Helper function to build a prayer row
    Widget buildPrayerRow(
        String prayerName, DateTime prayerTime, DateTime nextPrayerTime) {
      bool isCurrent = PrayerTimeService.instance.isCurrentTime(prayerName);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prayerName.tr,
                style: TextStyle(
                  color: isCurrent
                      ? AppColors.colorWarning
                      : AppColors.colorWhiteHighEmp,
                  fontSize: 14.h,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
              Text(
                "${locationProvider.formatPrayerTime(prayerTime)} - ${locationProvider.formatPrayerTime(nextPrayerTime)}",
                style: TextStyle(
                  color: isCurrent
                      ? AppColors.colorWarning
                      : AppColors.colorWhiteHighEmp,
                  fontSize: 14.h,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
            ],
          ),
        ],
      );
    }

    final todayPrayerTimes = locationProvider
        .prayerTimes![0]; // Assuming first entry is today's times

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.colorGradient1Start,
              AppColors.colorGradient1End
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (PrayerTimeService.instance.currentPrayerName != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12.0, left: 12, right: 12),
                    child: SizedBox(
                      height: 80.h,
                      width: 80.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 120.h,
                            width: 120.h,
                            child: CircularProgressIndicator(
                              value: 1.0 -
                                  (DateTime.now()
                                          .difference(PrayerTimeService
                                              .instance.currentPrayerTime!)
                                          .inMinutes /
                                      PrayerTimeService.instance.nextPrayerTime!
                                          .difference(PrayerTimeService
                                              .instance.currentPrayerTime!)
                                          .inMinutes),
                              backgroundColor: Colors.white.withOpacity(.4),
                              strokeWidth: 10,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.colorWarning),
                            ),
                          ),
                          Text(
                            remainingTime,
                            style: TextStyle(
                              color: AppColors.colorWarning,
                              fontSize: 12.sp,
                              fontWeight: FontWeights.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(width: 8.h),
                if (PrayerTimeService.instance.currentPrayerName != null)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Time remaining until the end of",
                          style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                            fontWeight: FontWeights.medium,
                          ),
                        ),
                        Text(
                          "${PrayerTimeService.instance.currentPrayerName} ",
                          style: TextStyle(
                            color: AppColors.colorWarning,
                            fontSize: 18.sp,
                            fontWeight: FontWeights.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 24.h),
            buildPrayerRow('Fajr', todayPrayerTimes.fajr,
                todayPrayerTimes.sunrise.add(const Duration(minutes: 7))),
            Divider(
                color: Colors.white.withOpacity(.3),
                indent: 20,
                endIndent: 20,
                thickness: 2),
            buildPrayerRow("Duh'r", todayPrayerTimes.dhuhr,
                todayPrayerTimes.asr.subtract(const Duration(minutes: 5))),
            Divider(
                color: Colors.white.withOpacity(.3),
                indent: 20,
                endIndent: 20,
                thickness: 2),
            buildPrayerRow('Asr', todayPrayerTimes.asr,
                todayPrayerTimes.maghrib.subtract(const Duration(minutes: 5))),
            Divider(
                color: Colors.white.withOpacity(.3),
                indent: 20,
                endIndent: 20,
                thickness: 2),
            buildPrayerRow('Magrib', todayPrayerTimes.maghrib,
                todayPrayerTimes.isha.subtract(const Duration(minutes: 5))),
            Divider(
                color: Colors.white.withOpacity(.3),
                indent: 20,
                endIndent: 20,
                thickness: 2),
            buildPrayerRow("Isha'a", todayPrayerTimes.isha,
                todayPrayerTimes.fajr.subtract(const Duration(minutes: 5))),
          ],
        ),
      ),
    );
  }

  ///Articles widget
  Widget _buildArticleCard(String thumbnailUrl, timestamp, title) {
    return Container(
      width: 196,
      decoration: BoxDecoration(
        color: AppColors.colorGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
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
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 4.0),
            child: Text(
              formatTimestamp(timestamp),
              style: const TextStyle(fontSize: 12, color: AppColors.colorBlackLowEmp),
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
    int timestampInt = int.parse(timestamp);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);
    String formattedDate = DateFormat('dd/MM/yy').format(date);

    return formattedDate;
  }
}
