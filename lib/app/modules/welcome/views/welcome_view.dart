import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';

import 'package:get/get.dart';
import 'package:my_grab/app/modules/welcome/controllers/welcome_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../themes/text.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  color: Colors.grey, shape: BoxShape.circle),
              child: const Center(
                  child: Text(
                    "EN",
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 400,
                      child: CarouselSlider.builder(
                        itemCount: controller.banners.length,
                        slideBuilder: ((itemIndex) {
                          return Image.asset(
                              controller.banners[itemIndex]
                          );
                        }),
                        slideIndicator: CircularSlideIndicator(
                          currentIndicatorColor: Colors.green,
                        ),
                      ),
                    ),

                    Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green
                            ),
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            }, child: const Text("Log in"))),

                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(
                                  side: BorderSide(
                                    color: Colors.green,
                                  ),
                                ),
                                primary: Colors.white,
                                elevation: 0
                            ),
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            }, child: const Text("I'm new, sign me up", style: normalGreenText,))),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RichText(text: const TextSpan(
                          children: [
                            TextSpan(text: "By logging in or registering, you agree to our ", style: normalBlackText),
                            TextSpan(text: "Terms of service ", style: normalGreenText),
                            TextSpan(text: "and ", style: normalBlackText),
                            TextSpan(text: "Privacy policy", style: normalGreenText),
                          ]
                      )),
                    )
                  ],
                )
            ),
          ),
        ));
  }
  }
