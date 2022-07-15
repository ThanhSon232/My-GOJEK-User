import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_grab/app/modules/home/views/home_view.dart';
import 'package:my_grab/app/modules/welcome/views/welcome_view.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          splash: Image.asset("assets/splash_logo.jpg"),
          splashIconSize: 150,
          nextScreen: controller.isFirstTime ? const WelcomeView() : const HomeView(),
          splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
