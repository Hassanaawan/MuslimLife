import 'package:Muslimlife/constants/colors_constants.dart';
import 'package:Muslimlife/views/screens/auth/user_registration_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../constants/fonts_weights.dart';
import '../../../constants/images_constants.dart';
import '../../../viewmodel/auth/user_sign_in_controller.dart';
import '../../widgets/snack_widget.dart';
import '../../widgets/loading_dialog_widget.dart';
import '../../widgets/app_background_widget.dart';
import '../../widgets/text_field_widget.dart';
import '../../widgets/custom_action_button .dart';
import '../home/home_page.dart';
import 'email_verification_screen.dart';

class UserLoginScreen extends StatefulWidget {
  UserLoginScreen({Key? key, required this.isParent}) : super(key: key);
  final bool isParent;

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();

  String userAdId = '';

  void getAndSaveDeviceId() async{
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
                        SizedBox(height: 12.h),
                        _buildForgetPassword(),
                        SizedBox(height: 32.h),
                        _buildSubmitButton(context),
                        SizedBox(height: 20.h),
                        _buildToRegistration(),
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
            'sign_in_title'.tr,
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
            'sign_in_subtitle'.tr,
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
      ],
    );
  }

  Widget _buildForgetPassword() {
    return InkWell(
      onTap: () {
        Get.to(() => EmailVerificationScreen());
      },
      child: Text(
        'forgot_password'.tr,
        style: TextStyle(
          color: AppColors.colorPrimaryLighter,
          fontSize: 16.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeights.semiBold,
        ),
      ),
    );
  }

  Widget _buildToRegistration() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'no_account'.tr,
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
            text: 'resister'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.colorPrimaryLighter,
              fontFamily: 'Poppins',
              fontWeight: FontWeights.semiBold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.isParent
                    ? Get.to(() => UserRegistrationScreen(
                  isParent: false,
                ))
                    : Get.offAll(() => UserRegistrationScreen(
                  isParent: true,
                ));
              },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GetBuilder<UserSignInController>(
        builder: (signInScreenController) {
          return SizedBox(
            height: 54.h,
            width: double.infinity,
            child: CustomActionButton(
              title: 'sign_in'.tr,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                checkFormErrors(context, signInScreenController);
              },
            ),
          );

        });
  }

  //Form error checking method
  void checkFormErrors(
      BuildContext context, UserSignInController controller) {
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
    // Loading indicator method
    showLoadingDialog(context);

    // Signup method
    signIn(controller);
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
  Future<void> signIn(UserSignInController controller) async {
    final response = await controller.signIn(
      emailTEController.text.trim(),
      passwordTEController.text,
      userAdId,
    );
    print(response);
    if (response) {
      ///print('Go Home');
      Get.back();
      Get.offAll(() => const HomePage(
            loadUserData: true,
          ));
      ///print('Home');
    } else {
      Get.back();
      makeSnack(controller.message);
    }
  }
}
