import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../constants/colors_constants.dart';
import '../../../../constants/images_constants.dart';
import '../../../widgets/loading_dialog_widget.dart';
import '../../../widgets/app_background_widget.dart';
import '../../../widgets/app_bar_widget.dart';

class PrivacyTermsScreen extends StatefulWidget {
  const PrivacyTermsScreen({super.key, required this.privacyPolicyUrl});
  final String privacyPolicyUrl;
  @override
  State<PrivacyTermsScreen> createState() => _PrivacyTermsScreenState();
}
class _PrivacyTermsScreenState extends State<PrivacyTermsScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.colorPrimary)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _isLoading = false;
            setState(() {});
            // Inject CSS to make the background transparent and text white
            _webViewController.runJavaScript("""
              document.body.style.backgroundColor = 'transparent';
              document.body.style.color = 'white';
            """);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.privacyPolicyUrl));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackgroundWidget(
            bgImagePath: AppImages.backgroundSolidColorSVG,
          ),
          AppBarWidget(screenTitle: 'privacy_policy'.tr),
          Padding(
            padding: EdgeInsets.only(top: 97.h, left: 16.h, right: 16.h, bottom: 16.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.colorPrimary,
              ),
              child: _isLoading
                  ? const Center(child: LoadingDialogWidget())
                  : WebViewWidget(controller: _webViewController),
            ),
          ),
        ],
      ),
    );
  }
}










