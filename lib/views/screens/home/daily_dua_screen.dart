import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../constants/fonts_weights.dart';
import '../../../constants/images_constants.dart';
import '../../../constants/colors_constants.dart';
import '../../../viewmodel/providers/hadith_provider.dart';

class DailyDuaScreen extends StatelessWidget {
  final int duaIndex;
  const DailyDuaScreen({super.key, required this.duaIndex});

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
              _buildAppbar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildDuaDetails(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) {
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
            "today_dua".tr,
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

  Widget _buildDuaDetails() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      margin: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorGrey.withOpacity(0.5)),
          color: AppColors.colorBlack.withOpacity(.1),
          borderRadius: BorderRadius.circular(20)),
      child: Consumer<HadithProvider>(builder: (context, duaProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            duaProvider.randomHadithIndexes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Text(
                        duaProvider.allDua![duaIndex].duaArabic!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            //overflow: TextOverflow.ellipsis,
                            color: AppColors.colorWhiteHighEmp),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                        duaProvider.language == 'ar'
                            ? duaProvider.allDua![duaIndex].duaArabic!
                            : duaProvider.language == 'en' ? duaProvider.allDua![duaIndex].duaEnglish!
                            : duaProvider.language == 'ur' ? duaProvider.allDua![duaIndex].duaUrdu!
                            : duaProvider.language == 'tr' ? duaProvider.allDua![duaIndex].duaTurkish!
                            : duaProvider.language == 'bn' ? duaProvider.allDua![duaIndex].duaBangla!
                            : duaProvider.language == 'fr' ? duaProvider.allDua![duaIndex].duaFrench!
                            : duaProvider.allDua![duaIndex].duaHindi!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            //overflow: TextOverflow.ellipsis,
                            color: AppColors.colorWhiteHighEmp),
                      ),
                    ],
                  ),
          ],
        );
      }),
    );
  }
}
