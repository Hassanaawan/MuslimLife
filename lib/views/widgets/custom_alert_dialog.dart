import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/auth/user_login_screen.dart';
import 'congrats_alert_dialog_widget.dart';

void showCustomAlertDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SignInRequiredDialog(
        title: 'sign_in_required'.tr,
        message: 'please_sign_in_first'.tr,
        onContinuePressed: () {
          Get.offAll(() => UserLoginScreen(isParent: true));
          print('Sign Up successful');
        },
      );
    },
  );
}