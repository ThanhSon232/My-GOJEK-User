import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
   print(PolylinePoints()
       .decodePolyline("!4m14!4m13!1m5!1m1!1s0x31752f1c06f4e1dd:0x43900f1d4539a3d!2m2!1d106.6821717!2d10.762913!1m5!1m1!1s0x31752ef09222b00b:0xb02f0a86479b4d8f!2m2!1d106.6633127!2d10.7543674!3e0"));
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
