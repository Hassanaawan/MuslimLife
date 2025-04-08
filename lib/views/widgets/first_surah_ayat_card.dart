import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/colors_constants.dart';
import '../../constants/fonts_weights.dart';

class FirstSurahAyahCard extends StatelessWidget {
  const FirstSurahAyahCard({
    Key? key,
    required this.arabic,
    required this.english,
    required this.surahName,
    required this.onIconTap,
    required this.isAudioPlaying,
  }) : super(key: key);

  final String arabic;
  final String english;
  final String surahName;
  final bool isAudioPlaying;
  final VoidCallback onIconTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorGrey.withOpacity(0.5)),
              color: AppColors.colorBlack.withOpacity(.1),
              borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    surahName,
                    style: TextStyle(
                      color: AppColors.colorWhiteHighEmp,
                      fontSize: 16.sp,
                      fontWeight: FontWeights.semiBold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onIconTap,
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      child: Center(
                        child: Icon(
                          isAudioPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.iconColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
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
                arabic,
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
                english,
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
      ),
    );
  }
}
