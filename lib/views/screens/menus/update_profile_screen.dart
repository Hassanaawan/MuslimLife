import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/fonts_weights.dart';
import '../../../constants/images_constants.dart';
import '../../../utils/urls.dart';
import '../../../viewmodel/auth/user_profile_controller.dart';
import '../../../viewmodel/profile_edit_controller.dart';
import '../../../viewmodel/providers/user_data_provider.dart';
import '../../widgets/snack_widget.dart';
import '../../widgets/loading_dialog_widget.dart';
import '../../widgets/app_background_widget.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/text_field_widget.dart';
import '../../widgets/custom_action_button .dart';
import '../auth/user_registration_screen.dart';
import 'password_update_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController =
      TextEditingController();
  String userName = '';
  String userMail = '';
  String userId = '';

  @override
  void initState() {
    // Load/Fetch user data
    loadUserData();
    super.initState();
  }

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

  // Load/Fetch user data method
  Future<void> loadUserData() async {
    //Access userNme on shared pref
    await UserProfileController.getUserName();
    //Access userMail on shared pref
    await UserProfileController.getUserMail();
    //Access userId on shared pref
    await UserProfileController.getUserId();
    // Set and update user data value
    setState(() {
      userName = UserProfileController.userName ?? '';
      userMail = UserProfileController.userMail ?? '';
      userId = UserProfileController.userId ?? '';
      nameTEController.text = userName;
      emailTEController.text = userMail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          AppBackgroundWidget(
              bgImagePath: AppImages.backgroundSolidColorSVG),

          Column(
            children: [
              AppBarWidget(screenTitle: 'profile'.tr),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Profile card section
                      _buildUserInfo(),
                      SizedBox(height: 20.h),
                      // Form section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.h),
                        child: Column(
                          children: [
                            _buildEditField(),
                            SizedBox(height: 18.h),
                            _buildChangePassword(context),
                            SizedBox(height: 32.h),
                            _buildSaveButton(),
                            SizedBox(height: 100.h),
                            _buildDeleteAccount(context),
                            SizedBox(height: 32.h),
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

  Widget _buildUserInfo() {
    return Stack(
      children: [
        Consumer<UserDataProvider>(
          builder: (context, userProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        selectedImagePath == ''
                            ? userProvider.userData!.thumbnailUrl == null ||
                                    userProvider.userData!.thumbnailUrl ==
                                        'Null' ||
                                    userProvider.userData!.thumbnailUrl == ''
                                ? ClipOval(
                                    child: Image.asset(
                                      AppImages.profileAvatarPNG,
                                      height: 100.h,
                                      width: 100.w,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 100.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: AppColors.colorWhiteHighEmp),
                                      child: Image.network(
                                        userProvider.userData!.thumbnailUrl!,
                                        fit: BoxFit.cover,
                                        height: 100.w,
                                        width: 100.w,
                                      ),
                                    ),
                                  )
                            : ClipOval(
                                child: Image.file(
                                  File(selectedImagePath),
                                  height: 100.w,
                                  width: 100.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                        Positioned(
                          right: 5.h,
                          bottom: 5.h,
                          child: InkWell(
                            onTap: () async {
                              selectedImagePath =
                                  await selectImageFromGallery();

                              if (selectedImagePath != '') {
                                setState(() {
                                  imageFile = File(selectedImagePath);
                                });
                              }
                            },
                            child: Image.asset(
                              AppImages.avatarEditPNG,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 20.sp,
                        fontWeight: FontWeights.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      userMail,
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
          },
        )
      ],
    );
  }

  Widget _buildEditField() {
    return Column(
      children: [
        TextFieldWidget(
          formTitle: 'auth_name'.tr,
          hintText: 'auth_name_hint'.tr,
          controller: nameTEController,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 16.h),
        TextFieldWidget(
          formTitle: 'auth_email'.tr,
          hintText: 'example@domain.com',
          controller: emailTEController,
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
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

  Widget _buildChangePassword(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PasswordUpdateScreen(
                    name: nameTEController.text,
                  )),
        );
      },
      child: Row(
        children: [
          SvgPicture.asset(AppImages.keySVG),
          SizedBox(width: 8.h),
          Text(
            'change_password'.tr,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeights.semiBold,
                color: AppColors.colorSecondaryLightest),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccount(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialogDeleteConfirmation(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 12.h),
        decoration: BoxDecoration(
            color: AppColors.colorWhiteHighEmp,
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            SizedBox(width: 18.h),
            Image.asset(
              AppImages.userPNG,
              height: 30,
              width: 30,
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'delete_account2'.tr,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeights.semiBold,
                        color: AppColors.colorError),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'deleting_account_info'.tr,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeights.regular,
                          color: AppColors.colorBlack),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showDialogDeleteConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent, // Make the dialog background transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: EdgeInsets.zero, // Remove default padding
        content: SizedBox(
          height: 350.h,
          child: Stack(
            children: [
              /// Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SvgPicture.asset(
                  AppImages.dialogBackgroundSVG,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),  // Adjust padding around the content
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'account_deletion'.tr,
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeights.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'confirm_delete_account'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.colorDisabled,
                          fontWeight: FontWeights.light,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30.0),

                      ///Delete Button
                      SizedBox(
                        height: 46.h,
                        width: 140.w,
                        child: ElevatedButton(
                          onPressed: () {
                            deleteData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorAlert,  // Button color
                          ),
                          child: Text(
                            'delete'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.colorWhiteHighEmp,
                              fontWeight: FontWeights.semiBold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      ///Close Button
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'close'.tr,
                          style: const TextStyle(color: AppColors.colorDisabled),
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

  bool deletingAccount = false;

  Future<void> deleteData() async {
    Navigator.pop(context);
    showLoadingDialog(context);

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');

    final Dio dio = Dio();

    try {
      final response = await dio.delete(
        "${Urls.deleteAccount}$userId",
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                const UserRegistrationScreen(isParent: true),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pop(context);
        makeSnack('please_try_again'.tr);
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      makeSnack('please_try_again'.tr);
      print(e.message);
    }
  }

  ///Form error checking method
  void checkFormErrors() async {
    if (nameTEController.text.isEmpty) {
      makeSnack('error_name_hint'.tr);
      return;
    }
    if (emailTEController.text.isEmpty) {
      makeSnack('error_email_hint'.tr);
      return;
    }
    if (!GetUtils.isEmail(emailTEController.text)) {
      makeSnack('error_valid_email_hint'.tr);
      return;
    }
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
    // Loading indicator method
    showLoadingDialog(context);
    Map<String, dynamic> requestBody = {};
    if (passwordTEController.text.isEmpty) {
      requestBody = {"fullName": nameTEController.text.trim()};
    } else {
      requestBody = {
        "fullName": nameTEController.text.trim(),
        "password": passwordTEController.text
      };
    }
    print(requestBody);
    // Update method
    updateUserData(requestBody, context);
  }

  /// Update method
  Future<void> updateUserData(
      Map<String, dynamic> requestBody, BuildContext context) async {
    bool imageUpload;
    if (selectedImagePath != '') {
      imageUpload = true;
    } else {
      imageUpload = false;
    }
    final response = await Get.find<ProfileEditController>()
        .updateUserData(requestBody, userId, imageUpload, imageFile);
    if (response) {
      await UserProfileController.setUserName(nameTEController.text.trim());
      Get.back();
      loadUserData();
      makeSnack('data_update_success'.tr);
      Provider.of<UserDataProvider>(context, listen: false)
          .fetchLoggedInUserData(true);
    } else {
      Get.back();
      makeSnack(Get.find<ProfileEditController>().message);
    }
  }

  /// Loading indicator
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
