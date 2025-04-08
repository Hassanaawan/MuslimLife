import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/colors_constants.dart';
import '../../constants/fonts_weights.dart';
import '../../constants/images_constants.dart';

class CongratsAlertDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onContinuePressed;

  const CongratsAlertDialogWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          height: 350.h,
          child: Stack(
            children: [
              /// Background Image covering the entire dialog
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SvgPicture.asset(
                  AppImages.dialogBackgroundSVG,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 12,
                    right: 12,
                    bottom: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.colorBlackHighEmp,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        message.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.colorBlackMidEmp,
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: 140.w,
                        child: ElevatedButton(
                          onPressed: onContinuePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Make button background transparent
                            shadowColor: Colors.transparent, // Remove shadow if not needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24), // Optional: Rounded corners
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.colorGradient1Start,
                                  AppColors.colorGradient1End,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'continue_btn_txt'.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white, // Text color
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SignInRequiredDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onContinuePressed;

  const SignInRequiredDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          height: 350.h,
          child: Stack(
            children: [
              /// Background Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: SvgPicture.asset(
                  AppImages.dialogBackgroundSVG,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Title Text
                      Text(
                        title.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.colorBlackHighEmp,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      /// Message Text
                      Text(
                        message.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.colorBlackMidEmp,
                          fontSize: 16.sp,
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      /// Gradient Button
                      SizedBox(
                        width: 200.h,
                        child: ElevatedButton(
                          onPressed: onContinuePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24), // Rounded corners
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.colorGradient1Start,
                                  AppColors.colorGradient1End,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'sign_in'.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white, // Text color
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      /// Skip Text
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "skip".tr,
                          style: TextStyle(
                            color: AppColors.colorBlackHighEmp,
                            fontSize: 16.sp,
                            fontWeight: FontWeights.regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}