import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../themes/text.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const h = SizedBox(
      height: 30,
    );
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register",
                      style: textTheme.headline1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please fill in a few details below",
                      style: textTheme.headline2,
                    ),
                    h,
                    Text(
                      "Name",
                      style: textTheme.headline3,
                    ),
                    TextFormField(
                      validator: (value) =>  controller.nameValidator(value!),
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                          hintText: 'e.g., John Doe', hintStyle: hintStyle,),
                    ),
                    h,
                    Text(
                      "Email",
                      style: textTheme.headline3,
                    ),
                    Obx(() => TextFormField(
                        controller: controller.emailController,
                        validator: (value) =>  controller.emailValidator(value!),
                        decoration:  InputDecoration(
                            hintText: 'e.g., name@gmail.com',
                            hintStyle: hintStyle,
                          errorText: controller.emailError.value
                        ),
                      ),
                    ),
                    h,
                    Text(
                      "Phone number",
                      style: textTheme.headline3,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 85,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/flag.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("+84", style: normalBlackText)
                                ],
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Obx(() => Flexible(
                            child: TextFormField(
                              controller: controller.phoneNumberController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) =>  controller.phoneNumberValidator(value!),
                              decoration: InputDecoration(
                                  hintText: '123xxxxxxx', hintStyle: hintStyle,
                                errorText: controller.phoneNumberError.value
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: Colors.grey,
              onPressed: () async{
                var check =  await controller.check();
                if(check == true){
                  Get.toNamed(Routes.OTP);
                }
              },
              child: Obx(()=>controller.isLoading.value ? const CircularProgressIndicator(color: Colors.white,) : const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ))),
    );
  }
}
