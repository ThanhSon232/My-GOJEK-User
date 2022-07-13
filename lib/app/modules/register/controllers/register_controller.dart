import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phoneNumber = '';

  @override
  void onInit() {
    super.onInit();
  }

  String? nameValidator(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else if (RegExp(".*[0-9].*").hasMatch(value)) {
      return "Name can't have number";
    }
    return null;
  }

  String? emailValidator(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else if(!GetUtils.isEmail(value)) {
      return "This is not an email";
    }
    return null;
  }

  String? phoneNumberValidator(String value){
    if (value.isEmpty) {
      return "This field is required";
    } else if(!GetUtils.isPhoneNumber(value)) {
      return "This is a valid phone number";
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
