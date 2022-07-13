import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../data/common/api_handler.dart';
import '../../../data/common/util.dart';
import '../../../routes/app_pages.dart';
import '../../login/controllers/login_controller.dart';

class PasswordLoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var loginController = Get.find<LoginController>();
  APIHandlerImp apiHandler = APIHandlerImp();
  String password = '';



  String? passwordValidator(String value){
    if (value.isEmpty) {
      return "This field is required";
    } else if(value.length < 6) {
      return "Password length must be longer than 6 digits";
    }
    return null;
  }

  bool check() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }



  Future<void> login() async {
    EasyLoading.show();
    print(loginController.phoneNumber);
    print(password);

    var response = await apiHandler.post(json.encode({
      "username": loginController.phoneNumber,
      "password": password
    }), "user/login");
    print(response);

    if(response["status"]){
      Get.offAllNamed(Routes.HOME);
      apiHandler.storeToken(response["data"]);
    } else {
      SnackBar.showSnackBar("Lỗi", "Mật khẩu không đúng");
    }

    EasyLoading.dismiss();
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
