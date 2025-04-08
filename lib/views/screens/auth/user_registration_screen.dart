import 'package:Muslimlife/constants/colors_constants.dart';
import 'package:Muslimlife/views/screens/auth/user_login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../constants/fonts_weights.dart';
import '../../../constants/images_constants.dart';
import '../../../viewmodel/auth/user_sign_up_controller.dart';
import '../../widgets/custom_action_button .dart';
import '../../widgets/snack_widget.dart';
import '../../widgets/congrats_alert_dialog_widget.dart';
import '../../widgets/loading_dialog_widget.dart';
import '../../widgets/app_background_widget.dart';
import '../../widgets/text_field_widget.dart';
import '../home/home_page.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({Key? key, required this.isParent}) : super(key: key);
  final bool isParent;

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final TextEditingController nameTEController = TextEditingController();

  final TextEditingController emailTEController = TextEditingController();

  final TextEditingController passwordTEController = TextEditingController();

  final TextEditingController confirmPasswordTEController =
      TextEditingController();

  String userAdId = '';

  void getAndSaveDeviceId() async {
    userAdId = OneSignal.User.pushSubscription.id!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSaveDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          AppBackgroundWidget(bgImagePath: AppImages.backgroundSolidColorSVG),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                SizedBox(height: 116.h),
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
                        SizedBox(height: 20.h),
                        _buildToSignIn(),
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
            'signup_title'.tr,
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
            'signup_subtitle'.tr,
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
          formTitle: 'auth_name'.tr,
          hintText: 'auth_name_hint'.tr,
          controller: nameTEController,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 16.h),
        TextFieldWidget(
          formTitle: 'auth_email'.tr,
          hintText: 'example@domain.com'.tr,
          controller: emailTEController,
          keyboardType: TextInputType.emailAddress,
        ),
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

  Widget _buildSubmitButton(BuildContext context) {
    return GetBuilder<UserSignUpController>(
        builder: (signUpScreenController) {
      return CustomActionButton(
          onTap: () {
            checkFormErrors(context, signUpScreenController);
          },
          title: 'sign_up');
    });
  }

  Widget _buildToSignIn() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'already_have_account'.tr,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              color: AppColors.backgroundColor,
            ),
          ),
          const WidgetSpan(
            child: SizedBox(width: 5),
          ),
          TextSpan(
            text: 'sign_in'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.colorPrimaryLighter,
              fontFamily: 'Poppins',
              fontWeight: FontWeights.semiBold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.isParent
                    ? Get.to(() => UserLoginScreen(
                          isParent: false,
                        ))
                    : Get.offAll(() => UserLoginScreen(
                          isParent: true,
                        ));
              },
          ),
        ],
      ),
    );
  }

  //Form error checking method
  void checkFormErrors(
      BuildContext context, UserSignUpController controller) {
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
    /// Loading indicator method
    showLoadingDialog(context);

    /// Signup method
    signUp(controller, context);
  }

  ///Account creation successful popup method
  void showCustomAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CongratsAlertDialogWidget(
          title: 'congratulations_txt'.tr,
          message: 'successfully_account_create_msg'.tr,
          onContinuePressed: () {
            Get.back();
            Get.offAll(
              () => const HomePage(
                loadUserData: true,
              ),
            );
          },
        );
      },
    );
  }

  // Signup method
  Future<void> signUp(
      UserSignUpController controller, BuildContext context) async {
    final response = await controller.signUp(nameTEController.text.trim(),
        emailTEController.text.trim(), passwordTEController.text, userAdId);
    if (response) {
      Get.back();
      showCustomAlertDialog(context);
    } else {
      Get.back();
      makeSnack(controller.message);
    }
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
}
