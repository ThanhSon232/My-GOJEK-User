import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grab/app/data/common/api_handler.dart';
import 'package:my_grab/app/modules/register/controllers/register_controller.dart';

import '../../../routes/app_pages.dart';

class OtpController extends GetxController {
  //TODO: Implement OtpController
  var isLoading = false.obs;
  final count = 0.obs;
  var isClicked = true.obs;
  TextEditingController otpController = TextEditingController();
  Timer? timer;
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  var start = 30.obs;
  var registerController = Get.find<RegisterController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var error = ''.obs;



  @override
  void onInit() async{
    super.onInit();
    await startTimer();
  }

  String? validator(){
    if(otpController.text.isEmpty){
      return "OTP can't be empty";
    }
    else if(otpController.text.length < 6){
      return "Please fill all the numbers";
    }
    return null;
  }

  validateOTP() async{
    isLoading.value = true;
    var response = await apiHandlerImp.put(
        {"username": "0${registerController.phoneNumberController.text}",
        "otp": otpController.text
        },
        "validateOTP");
    if(response.data["status"]){
      error.value = '';
      Get.toNamed(Routes.PASSWORD);
    } else {
      // error.value = "OTP doesn't match what we sent. Try again";
      Get.snackbar("Fail", "OTP doesn't match what we sent. Try again", backgroundColor: Colors.grey[100]!);
    }
    isLoading.value = false;
  }

  bool check() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }


  sendOTP() async {
    var response = await apiHandlerImp.put(
        {"username": "0${registerController.phoneNumberController.text}"},
        "sendOTP");
  }

  Future<void> startTimer() async {
    isClicked.value = true;
    const oneSec = Duration(seconds: 1);
    await sendOTP();
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          start.value = 30;
          isClicked.value = false;
          timer.cancel();
        } else {
          start.value -= 1;
        }
      },
    );
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
