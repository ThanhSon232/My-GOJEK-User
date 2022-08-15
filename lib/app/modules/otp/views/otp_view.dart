import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../themes/text.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const h = SizedBox(
      height: 10,
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
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
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
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/img.png",
                  height: 80,
                ),
                h,
                Text(
                  "You're almost there!",
                  style: textTheme.headline1,
                ),
                h,
                const Text(
                  "You must enter OTP which we sent you earlier",
                  style: normalBlackText,
                ),
                h,
                Form(
                  key: controller.formKey,
                  child:Pinput(
                      length: 6,
                      controller: controller.otpController,
                      // validator: (value) => controller.validator(),
                      errorText: controller.error.value,
                  ),
                ),
                h,
                h,
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Obx(
                    () => ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: controller.isClicked.value
                            ? null
                            : () {
                                controller.startTimer();
                              },
                        child: controller.isClicked.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${controller.start.value}s",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              )
                            : const Text("Resend")),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: Colors.grey,
              onPressed: () async {
                var check = controller.check();
                if(check){
                  controller.validateOTP();
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
