import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/colors_constants.dart';
import '../../../../constants/localization/app_constants.dart';
import '../../../../constants/images_constants.dart';
import '../../../../viewmodel/Providers/location_data_provider.dart';
import '../../../../viewmodel/app_localization_controller.dart';
import '../../../../viewmodel/app_navigation_controller.dart';
import '../../../../viewmodel/language_validation_controller.dart';
import '../../../../viewmodel/providers/hadith_provider.dart';
import '../../../widgets/app_background_widget.dart';
import '../../../widgets/app_bar_widget.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final bool backButton;
  const LanguageSelectionScreen({super.key, required this.backButton});

  void _saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<HadithProvider>(context, listen: false);
    final languages = [
      {'code': 'en', 'text': 'English'},
      {'code': 'ar', 'text': 'العربية'},
      {'code': 'ur', 'text': 'اردو'},
      {'code': 'tr', 'text': 'Türkçe'},
      {'code': 'bn', 'text': 'বাংলা'},
      {'code': 'fr', 'text': 'French'},
      {'code': 'hi', 'text': 'हिन्दी'},

    ];

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          AppBackgroundWidget(
            bgImagePath: AppImages.backgroundSolidColorSVG,
          ),
           AppBarWidget(
            backButton: backButton,
            screenTitle: 'select_language',
          ),
          Column(
            children: [
              SizedBox(height: 80.h),
              Expanded(
                child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  padding: EdgeInsets.all(20.h),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return buildLanguageButton(
                      languageIndex: index,
                      context: context,
                      languageProvider: languageProvider,
                      languageCode: languages[index]['code']!,
                      buttonText: languages[index]['text']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLanguageButton({
    required int languageIndex,
    required BuildContext context,
    required HadithProvider languageProvider,
    required String languageCode,
    required String buttonText,
  }) {
    return ElevatedButton(
      onPressed: () async {
        Get.find<AppLocalizationController>().setLanguage(Locale(
          AppConstants.languages[languageIndex].languageCode,
          AppConstants.languages[languageIndex].countryCode,
        ));
        Get.find<AppLocalizationController>().setSelectedIndex(1);
        _saveLanguage(languageCode);
        await languageProvider.getLanguage();
        await LanguageValidationController.setLanguage(languageCode);
        await AppNavigationController.setLanguageValue(false);
        await AppNavigationController.getAppInstallValue();
        await Provider.of<LocationDataProvider>(context, listen: false).getBool();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.colorPrimary,
        minimumSize: Size(100.h, 60.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: AppColors.colorWhiteHighEmp,
          fontWeight: FontWeight.bold,
          fontSize: 17.sp,
        ),
      ),
    );
  }
}
