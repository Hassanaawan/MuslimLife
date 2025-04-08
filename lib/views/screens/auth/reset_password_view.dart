import 'package:Muslimlife/views/screens/auth/user_login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/fonts_weights.dart';
import '../../../constants/images_constants.dart';
import '../../../services/token_manager.dart';
import '../../../viewmodel/auth/password_reset_controller.dart';
import '../../widgets/custom_action_button .dart';
import '../../widgets/snack_widget.dart';
import '../../widgets/congrats_alert_dialog_widget.dart';
import '../../widgets/loading_dialog_widget.dart';
import '../../widgets/app_background_widget.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/text_field_widget.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key, required this.email, required this.otp});

  final String email, otp;

  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          AppBackgroundWidget(bgImagePath: AppImages.backgroundSolidColorSVG),
          // Custom Appbar
          AppBarWidget(screenTitle: 'reset_password'.tr),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                SizedBox(
                  height: 116.h,
                ),
                _buildHeader(),
                SizedBox(height: 24.h),
                // Form section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInputField(),
                        SizedBox(height: 32.h),
                        _buildSubmitButton(context),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            'rps_title'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24.sp,
              fontWeight: FontWeights.semiBold,
              color: AppColors.backgroundColor,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            'rps_subtitle'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              color: AppColors.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Column(
      children: [
        TextFieldWidget(
          formTitle: 'auth_password'.tr,
          hintText: '****************',
          controller: passwordTEController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
        ),
        SizedBox(height: 16.h),
        TextFieldWidget(
          formTitle: 'auth_confirm_password'.tr,
          hintText: '****************',
          controller: confirmPasswordTEController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GetBuilder<PasswordResetController>(
        builder: (resetPasswordScreenController) {
      // Elevated button
      return CustomActionButton(
          onTap: () {
            checkFormErrors(resetPasswordScreenController, context);
          },
          title: 'complete_btn_txt');
    });
  }

  //Form error checking method
  void checkFormErrors(
      PasswordResetController controller, BuildContext context) {
    if (passwordTEController.text.isEmpty) {
      makeSnack('error_password_hint'.tr);
      return;
    }
    if (passwordTEController.text.length < 8) {
      makeSnack('error_password_hint2'.tr);
      return;
    }
    if (confirmPasswordTEController.text.isEmpty) {
      makeSnack('error_confirm_password_hint'.tr);
      return;
    }
    if (confirmPasswordTEController.text != passwordTEController.text) {
      makeSnack('error_confirm_password_hint2'.tr);
      return;
    }
    // Loading indicator method
    showLoadingDialog(context);

    // Reset Password method
    resetPassword(controller, context);
  }

  //Password reset successful popup method
  void showCustomAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CongratsAlertDialogWidget(
          title: 'congratulations_txt'.tr,
          message: 'successfully_password_reset_msg'.tr,
          onContinuePressed: () async {
            print('Password Reset successful');
            /// Clear token value
            await AuthController.clearTokenValue();
            /// Navigate to sign in screen
            Get.offAll(() => UserLoginScreen(isParent: true));
          },
        );
      },
    );
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

  // Reset Password method
  Future<void> resetPassword(
      PasswordResetController controller, BuildContext context) async {
    final response =
        await controller.resetPassword(email, passwordTEController.text, otp);
    print(response);
    if (response) {
      Get.back();
      showCustomAlertDialog(context);
    } else {
      Get.back();
      makeSnack(controller.message);
    }
  }
}
