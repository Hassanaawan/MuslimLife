import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class BottomNavViewModel extends GetxController {
  late ScrollController scrollController;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    startAutoScroll();
  }

  void startAutoScroll() {
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (scrollController.position.pixels < scrollController.position.maxScrollExtent) {
        scrollController.animateTo(
          scrollController.position.pixels + 50,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else {
        scrollController.jumpTo(0);
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    timer.cancel();
    super.onClose();
  }
}
