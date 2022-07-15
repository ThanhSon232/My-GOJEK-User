import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grab/app/data/common/api_handler.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  var phoneNumberError = ''.obs;
  var isLoading = false.obs;

  String? phoneNumberValidator(String value){
    if (value.isEmpty) {
      return "This field is required";
    } else if(!GetUtils.isPhoneNumber(value)) {
      return "This is not a valid phone number";
    }
    return null;
  }

  Future<bool> check() async{
    isLoading.value = true;
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return false;
    }

    var phoneResponse = await apiHandlerImp.post({
      "phoneNumber": '0${phoneNumberController.text}'
    },
        "user/checkPhonenumber");

    if(!phoneResponse.data["status"]){
      phoneNumberError.value = "Phone number is not existed, try another one";
      isLoading.value = false;
      return false;
    }
    formKey.currentState!.save();
    isLoading.value = false;
    return true;
  }



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
