import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  //TODO: Implement VoucherController
  ScrollController scrollController = ScrollController();
  var scrollPosition = 0.0.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      scrollPosition.value = scrollController.position.pixels;
      print(scrollPosition.value);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
