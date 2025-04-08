import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../constants/images_constants.dart';
import '../../../viewmodel/auth/user_profile_controller.dart';
import '../../../viewmodel/profile_edit_controller.dart';
import '../../../viewmodel/providers/user_data_provider.dart';
import '../../widgets/app_background_widget.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/text_field_widget.dart';
import '../../widgets/snack_widget.dart';
import '../../widgets/loading_dialog_widget.dart';
import '../../widgets/custom_action_button .dart';

class PasswordUpdateScreen extends StatefulWidget {
  final String name;

  const PasswordUpdateScreen({super.key, required this.name});

  @override
  State<PasswordUpdateScreen> createState() => _PasswordUpdateScreenState();
}

class _PasswordUpdateScreenState extends State<PasswordUpdateScreen> {

  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController =
      TextEditingController();
  String userId = '';
  String selectedImagePath = '';
  File? imageFile;

  selectImageFromGallery() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          AppBackgroundWidget(bgImagePath: AppImages.backgroundSolidColorSVG),
          // Custom Appbar

          Column(
            children: [
              AppBarWidget(screenTitle: 'change_password'.tr),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      // Form section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.h),
                        child: Column(
                          children: [
                            _buildEditableField(),
                            SizedBox(height: 32.h),
                            _buildSubmitButton(),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField() {
    return Column(
      children: [
        SizedBox(height: 16.h),
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
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 54.h,
      width: double.infinity,
      child: CustomActionButton(
        title: 'save_btn_text'.tr,
        onTap: () {
          checkFormErrors();
        },
      ),
    );
  }

  void checkFormErrors() {
    if (passwordTEController.text.isNotEmpty &&
        passwordTEController.text.length < 8) {
      makeSnack('error_password_hint2'.tr);
      return;
    }
    if (passwordTEController.text.isNotEmpty &&
        (confirmPasswordTEController.text != passwordTEController.text)) {
      makeSnack('error_confirm_password_hint2'.tr);
      return;
    }
    showLoadingDialog(context);
    Map<String, dynamic> requestBody = {
      "fullName": widget.name,
      "password": passwordTEController.text
    };
    updateUserData(requestBody, context);
  }

  Future<void> updateUserData(
      Map<String, dynamic> requestBody, BuildContext context) async {
    await UserProfileController.getUserId();
    final response = await Get.find<ProfileEditController>()
        .updateUserData(requestBody, UserProfileController.userId!, false, null);
    if (response) {
      await UserProfileController.setUserName(widget.name);
      Get.back();
      makeSnack('data_update_success'.tr);
      Provider.of<UserDataProvider>(context, listen: false)
          .fetchLoggedInUserData(true);
    } else {
      Get.back();
      makeSnack(Get.find<ProfileEditController>().message);
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingDialogWidget();
      },
    );
  }

}
