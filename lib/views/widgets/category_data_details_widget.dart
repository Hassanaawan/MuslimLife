import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants/colors_constants.dart';
import '../../constants/fonts_weights.dart';
import '../../viewmodel/Providers/location_data_provider.dart';
import '../../viewmodel/language_validation_controller.dart';

class CategoryDataDetailsWidget extends StatelessWidget {
  const CategoryDataDetailsWidget({
    super.key,
    this.authorName,
    required this.amolEnglish,
    required this.amolArabic,
    required this.amolTurkish,
    required this.amolUrdu,
    required this.title,
    required this.amolBangla,
    required this.amolFrench,
    required this.amolHindi,
  });

  final String? authorName;
  final String amolEnglish;
  final String amolArabic;
  final String amolTurkish;
  final String amolUrdu;
  final String amolBangla;
  final String amolFrench;
  final String amolHindi;
  final String title;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationDataProvider>(context, listen:  false);
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.colorGrey.withOpacity(0.5)),
          color: AppColors.colorBlack.withOpacity(.1),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          ),
          authorName != null
              ? Text(
                  authorName!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.colorPrimaryLighter,
                    fontSize: 16.sp,
                    fontWeight: FontWeights.semiBold,
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(
            height: 16,
          ),
          Container(
            color: AppColors.colorWhiteHighEmp,
            height: 0.5,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            amolArabic,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          ),
          const SizedBox(height: 5),
          LanguageValidationController.setLang == 'en'
              ? Text(
            amolEnglish,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          )
              : LanguageValidationController.setLang == 'tr'
              ? Text(
            amolTurkish,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          )
              : LanguageValidationController.setLang == 'ur' ? Text(
            amolUrdu,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          )
              : LanguageValidationController.setLang == 'bn' ? Text(
            amolBangla,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          )
              : LanguageValidationController.setLang == 'fr' ? Text(
            amolEnglish,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          )
              : LanguageValidationController.setLang == 'hi' ? Text(
            amolHindi,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          )
              : Text(
            amolArabic,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorWhiteHighEmp,
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
            ),
          ),
        ],
      ),
    );
  }
}


