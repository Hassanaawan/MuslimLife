import 'package:Muslimlife/views/screens/menus/preferance/user_preferences_screen.dart';
import 'package:Muslimlife/views/screens/menus/zakat_calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import '../../../constants/fonts_weights.dart';
import '../../../constants/images_constants.dart';
import '../../../constants/colors_constants.dart';
import '../../../services/token_manager.dart';
import '../../../viewmodel/providers/user_data_provider.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/sub_category_widget.dart';
import '../Qibla/compass_view.dart';
import '../auth/user_login_screen.dart';
import 'namaz_time_screen.dart';
import 'update_profile_screen.dart';
import 'islamic_calender.dart';
import 'makkah_live_broadcast_screen.dart';
import 'near_by_mosques_screen.dart';

Drawer buildDrawer(BuildContext context) {
  final provider = Provider.of<UserDataProvider>(context, listen: false);

  List _menuItems = [
    {
      'icon': AppImages.alQuranPNG,
      'label': 'alquran'.tr,
      'onTap': () {
        getCategories('dua-categories', 'AL-QURAN');
      },
    },
    {
      'icon': AppImages.hadithPNG,
      'label': 'hadith'.tr,
      'onTap': () {
        getCategories('hadith-categories', 'HADITH');
      },
    },
    {
      'icon': AppImages.adhanPNG,
      'label': 'prayer_time'.tr,
      'onTap': () {
        Get.back();
        Get.to(() => const NamazTimeScreen());
      },
    },
    {
      'icon': AppImages.qiblaCompusPNG,
      'label': 'qibla_compass'.tr,
      'onTap': () {
        Get.back();
        Get.to(() => const CompassView());
      },
    },
    {
      'icon': AppImages.zakatPNG,
      'label': 'jakat_calculator'.tr,
      'onTap': () {
        Get.back();
        Get.to(() => const ZakatCalculatorScreen());
      },
    },
    {
      'icon': AppImages.makkaPNG,
      'label': 'makka_live'.tr,
      'onTap': () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MakkahLiveBroadcastScreen()));
      },
    },
    {
      'icon': AppImages.azkarPNG,
      'label': 'azkar'.tr,
      'onTap': () {
        getCategories('azkar-categories', 'AZKAR');
      },
    },
    {
      'icon': AppImages.calenderPNG,
      'label': 'islamic_calender'.tr,
      'onTap': () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HijriDatePickerDialog(
              initialDate: HijriCalendar.now(),
              firstDate: HijriCalendar.addMonth(1356, 1),
              lastDate: HijriCalendar.addMonth(1499, 1),
              initialDatePickerMode: DatePickerMode.day,
            ),
          ),
        );
      },
    },
    {
      'icon': AppImages.mosquePNG,
      'label': 'mosque_location'.tr,
      'onTap': () {
        Get.back();
        Get.to(() => const NearbyMosquesScreen());
      },
    },
    {
      'icon': AppImages.preferencesPNG,
      'label': 'preference'.tr,
      'onTap': () {
        Get.back();
        Get.to(() => const UserPreferencesScreen());
      },
    },
    {
      'icon': AppImages.accountPNG,
      'label': 'my_profile'.tr,
      'onTap': () async {
        Get.back();
        provider.userData!.thumbnailUrl == 'Null'
            ? showCustomAlertDialog(context)
            : Get.to(() => const UpdateProfileScreen());
      },
    },
    {
      'icon': AppImages.loginPNG,
      'label': 'sign_in'.tr,
      'onTap': () async {
        Get.offAll(UserLoginScreen(isParent: true));
      },
    },
  ];

  return Drawer(
    child: DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.colorGradient1Start,
            AppColors.colorGradient1End,
          ],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Image.asset(AppImages.appLogo, height: 80, width: 80,),
          ),
          const Divider(color: AppColors.colorAlert),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];

                // Handle the last item (login/logout)
                if (index == _menuItems.length - 1) {
                  return provider.userDataLoading ||
                          provider.userData!.thumbnailUrl == 'Null'
                      ? _buildSignin()
                      : _buildLogout();
                } else {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: index == 0
                            ? BorderSide
                                .none // No top border for the first item
                            : const BorderSide(
                                color: AppColors.colorBlackLowEmp,
                                width: 0.5,
                              ),
                        bottom: index == _menuItems.length - 1
                            ? BorderSide
                                .none // No bottom border for the last item
                            : const BorderSide(
                                color: AppColors.colorBlackLowEmp,
                                width: 0.5,
                              ),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: const BoxDecoration(
                          color: AppColors.colorWhiteHighEmp,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(item['icon'], width: 24),
                      ),
                      title: Text(
                        item['label'],
                        style:
                            const TextStyle(color: AppColors.colorWhiteHighEmp),
                      ),
                      onTap: item['onTap'],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSignin() {
  return InkWell(
    onTap: () async {
      Get.offAll(UserLoginScreen(isParent: true));
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.h),
      child: Container(
        height: 52.h,
        width: 102.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.colorYellowStart,
              AppColors.colorYellowEnd,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.login,
              size: 28.0,
              color: AppColors.colorPrimary,
            ),
            const SizedBox(width: 8.0),
            Text(
              'sign_in'.tr,
              style: const TextStyle(
                color: AppColors.colorBlackHighEmp,
                fontSize: 13.0,
                fontWeight: FontWeights.semiBold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLogout() {
  return InkWell(
    onTap: () async {
      await AuthController.clearTokenValue();
      Get.offAll(() => UserLoginScreen(isParent: true));
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.h),
      child: Container(
        height: 52.h,
        width: 102.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.colorYellowStart,
              AppColors.colorYellowEnd,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.logoutPNG,
              height: 32.h,
              width: 32.w,
            ),
            const SizedBox(width: 8.0),
            Text(
              'logout'.tr,
              style: const TextStyle(
                color: AppColors.colorBlackHighEmp,
                fontSize: 13.0,
                fontWeight: FontWeights.semiBold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

getCategories(String categoryName, String cateSign) {
  if (cateSign == 'HADITH') {
    Get.back();
    Get.to(
      () => SubCategoryWidget(
        categoryTitle: 'hadith',
        iconPath: AppImages.hadithSVG,
        categoryName: categoryName,
        cateSign: cateSign,
      ),
    );
  } else {
    if (cateSign == 'DUA') {
      Get.back();
      Get.to(
        () => SubCategoryWidget(
          categoryTitle: 'dua',
          iconPath: AppImages.duaSVG,
          categoryName: categoryName,
          cateSign: cateSign,
        ),
      );
    } else {
      if (cateSign == 'AL-QURAN') {
        Get.back();
        Get.to(
          () => SubCategoryWidget(
            categoryTitle: 'alquran',
            iconPath: AppImages.quranSVG,
            categoryName: categoryName,
            cateSign: cateSign,
          ),
        );
      } else {
        if (cateSign == 'AZKAR') {
          Get.back();
          Get.to(
            () => SubCategoryWidget(
              categoryTitle: 'azkar',
              iconPath: AppImages.duaSVG,
              categoryName: categoryName,
              cateSign: cateSign,
            ),
          );
        } else {
          if (cateSign == 'EVENT-PRAYERS') {
            Get.back();
            Get.to(
              () => SubCategoryWidget(
                categoryTitle: 'event_prayers',
                iconPath: AppImages.duaSVG,
                categoryName: categoryName,
                cateSign: cateSign,
              ),
            );
          }
        }
      }
    }
  }
}
