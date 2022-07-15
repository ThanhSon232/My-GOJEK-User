import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../themes/text.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const h = SizedBox(
      height: 10,
    );
    const h_2 = SizedBox(
      height: 20,
    );
    const h_3 = SizedBox(
      height: 30,
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Image.asset(
              "assets/logo_gojek.png",
              height: 100,
              width: 100,
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child: const Center(
                    child: Text(
                  "?",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: textTheme.headline1,
                ),
                h,
                Text(
                  "Enter your registered phone number to log in",
                  style: textTheme.headline2,
                ),
                h_3,
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
                    Form(
                      key: controller.formKey,
                      child: Flexible(
                        child: Obx(
                          () => TextFormField(
                            controller: controller.phoneNumberController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) =>
                                controller.phoneNumberValidator(value!),
                            decoration: InputDecoration(
                                hintText: '123xxxxxxx',
                                hintStyle: hintStyle,
                                errorText: controller.phoneNumberError.value),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                h_2,
                const Text(
                  "Issue with number?",
                  style: underlineBoldNormalGreenText,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: Colors.grey,
              onPressed: () async {
                var check = await controller.check();
                if (check) {
                  Get.toNamed(Routes.PASSWORD_LOGIN);
                }
              },
              child: Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
              ))),
    );
  }
}
