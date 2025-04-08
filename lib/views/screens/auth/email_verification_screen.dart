import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/images_constants.dart';
import '../../../viewmodel/auth/email_verification_controller.dart';
import '../../widgets/custom_action_button .dart';
import '../../widgets/snack_widget.dart';
import '../../widgets/loading_dialog_widget.dart';
import '../../widgets/app_background_widget.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/text_field_widget.dart';
import 'otp_verification_screen.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

  final TextEditingController emailTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          AppBackgroundWidget(bgImagePath: AppImages.backgroundSolidColorSVG),
          // Custom Appbar
          AppBarWidget(
            screenTitle: 'forgot_password2'.tr,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildWidget(),
                  SizedBox(height: 32.h),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return TextFieldWidget(
      formTitle: 'auth_email'.tr,
      hintText: 'example@domain.com',
      controller: emailTEController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GetBuilder<EmailVerificationController>(
        builder: (forgotPasswordScreenController) {
      // Elevated button
          //  reset_password
      return CustomActionButton(onTap: (){
        checkFormErrors(forgotPasswordScreenController, context);
      }, title: 'reset_password');
    });
  }

  //Form error checking method
  void checkFormErrors(
      EmailVerificationController controller, BuildContext context) {
    if (emailTEController.text.isEmpty) {
      makeSnack('error_email_hint'.tr);
      return;
    }
    if (!GetUtils.isEmail(emailTEController.text)) {
      makeSnack('error_valid_email_hint'.tr);
      return;
    }
    // Loading indicator method
    showLoadingDialog(context);
    // Forgot password method
    verifyEmail(controller);
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

  // Signup method
  Future<void> verifyEmail(EmailVerificationController controller) async {
    final response =
        await controller.verifyEmail(emailTEController.text.trim());
    print(response);
    if (response) {
      Get.back();
      print('Password reset successful');
      // Navigate to reset otp screen
      Get.to(() => OtpVerificationScreen(email: emailTEController.text.trim()));
    } else {
      Get.back();
      makeSnack(controller.message);
    }
  }
}
