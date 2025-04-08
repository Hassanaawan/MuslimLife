import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors_constants.dart';
import '../../constants/fonts_weights.dart';

class SecondSurahAyahCard extends StatelessWidget {
  const SecondSurahAyahCard({
    super.key,
    required this.surahEnglish,
    required this.surahArabic,
  });

  final String surahEnglish;
  final String surahArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.colorGrey.withOpacity(0.5)),
          color: AppColors.colorBlack.withOpacity(.1),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Text(
              surahArabic,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.colorWhiteHighEmp,
                fontSize: 14.sp,
                fontWeight: FontWeights.regular,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              surahEnglish,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.colorWhiteHighEmp,
                fontSize: 14.sp,
                fontWeight: FontWeights.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
