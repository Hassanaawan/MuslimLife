import 'package:get/get.dart';
import '../services/token_manager.dart';
import '../views/screens/home/home_page.dart';
import 'language_validation_controller.dart';
import 'navigation_controller.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    goToNextScreen();
  }

  Future<void> goToNextScreen() async {
    await AuthController.getAccessToken();
    await AuthController.getExpireDateAndTime();
    await LanguageValidationController.initializeLanguage();
    await NavigationController.getLanguageValue();
    await Future.delayed(const Duration(seconds: 2));

      if (AuthController.isLoggedIn) {
        Get.offAll(() => const HomePage(loadUserData: true));
      } else {
        Get.offAll(() => const HomePage(loadUserData: false));
      }
  }
}