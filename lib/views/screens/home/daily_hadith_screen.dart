import 'package:Muslimlife/constants/images_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/fonts_weights.dart';
import '../../../viewmodel/providers/hadith_provider.dart';

class DailyHadithScreen extends StatelessWidget {
  final int hadithIndex;
  const DailyHadithScreen({super.key, required this.hadithIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.backgroundImage),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHadithDetails(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
              padding: EdgeInsets.only(top: 40.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.colorWhiteHighEmp,
                  ),
                  Text(
                    "today_hadith".tr,
                    style: TextStyle(
                      color: AppColors.colorWhiteHighEmp,
                      fontSize: 18.sp,
                      fontWeight: FontWeights.semiBold,
                    ),
                  )
                ],
              ),
            );
  }

  Widget _buildHadithDetails() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      margin: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorGrey.withOpacity(0.5)),
        color: AppColors.colorBlack.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Consumer<HadithProvider>(
        builder: (context, hadithProvider, child) {
          if (hadithProvider.randomHadithIndexes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// Displaying Arabic text
                Text(
                  hadithProvider.allHadith![hadithIndex].hadithArabic!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                ),
                SizedBox(height: 10.h),
                hadithProvider.language == 'ar'
                    ? const SizedBox()
                    : Text(
                  _getTranslation(hadithProvider, hadithIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

/// Function to get the correct translation based on language
  String _getTranslation(HadithProvider hadithProvider, int index) {
    switch (hadithProvider.language) {
      case 'en':
        return hadithProvider.allHadith![index].hadithEnglish ?? "";
      case 'ur':
        return hadithProvider.allHadith![index].hadithUrdu ?? "";
      case 'tr':
        return hadithProvider.allHadith![index].hadithTurkish ?? "";
      case 'bn':
        return hadithProvider.allHadith![index].hadithBangla ?? "";
      case 'fr':
        return hadithProvider.allHadith![index].hadithFrench ?? "";
      case 'hi':
        return hadithProvider.allHadith![index].hadithHindi ?? "";
      default:
        return "";
    }
  }

}
