import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:my_grab/app/modules/user/controllers/user_controller.dart';

import '../../../data/common/google_map.dart';

class FindTransportationController extends GetxController {
  //TODO: Implement FindTransportationController
  final count = 0.obs;
  Rx<double> scrollPosition = 0.0.obs;
  var position = {}.obs;
  var showMap = false.obs;
  var isLoading = false.obs;
  Maps map = Maps();
  var userController = Get.find<UserController>();
  ScrollController scrollController = ScrollController(initialScrollOffset: 1);

  @override
  void onInit() async{
    super.onInit();
    // print("find: " + passwordController);
    isLoading.value = true;
    scrollController.addListener(() {
      scrollPosition.value = scrollController.position.pixels;
    });
    await map.determinePosition();
    if(map.permission == LocationPermission.whileInUse || map.permission == LocationPermission.always){
      position.value = await map.getCurrentPosition();
    }
    isLoading.value = false;

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
