import 'package:Muslimlife/viewmodel/auth/email_verification_controller.dart';
import 'package:Muslimlife/viewmodel/auth/otp_validation_controller.dart';
import 'package:Muslimlife/viewmodel/auth/password_reset_controller.dart';
import 'package:Muslimlife/viewmodel/auth/user_sign_in_controller.dart';
import 'package:Muslimlife/viewmodel/auth/user_sign_up_controller.dart';
import 'package:Muslimlife/viewmodel/azkar_category_controller.dart';
import 'package:Muslimlife/viewmodel/categories_controller.dart';
import 'package:Muslimlife/viewmodel/dua_category_controller.dart';
import 'package:Muslimlife/viewmodel/event_prayer_category_controller.dart';
import 'package:Muslimlife/viewmodel/hadith_category_controller.dart';
import 'package:Muslimlife/viewmodel/profile_edit_controller.dart';
import 'package:Muslimlife/viewmodel/splash_screen_controller.dart';
import 'package:Muslimlife/viewmodel/surah_details_controller.dart';
import 'package:get/get.dart';
import '../viewmodel/articles_controller.dart';
import '../viewmodel/bottom_nav_viewmodel.dart';


class InitialBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
    Get.put(UserSignUpController());
    Get.put(UserSignInController());
    Get.put(EmailVerificationController());
    Get.put(OtpValidationController());
    Get.put(PasswordResetController());
    Get.put(CategoriesController());
    Get.put(HadithDataListController());
    Get.put(DuaCategoryController());
    Get.put(AzkarCategoryController());
    Get.put(EventPrayerCategoryController());
    Get.put(SurahDetailsController());
    Get.put(ProfileEditController());
    Get.put(BottomNavViewModel());
    Get.put(ArticleController());
  }
}
