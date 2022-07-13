import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_grab/app/modules/welcome/views/welcome_view.dart';

import '../../../routes/app_pages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          duration: 3000,
          splash: Image.asset("assets/splash_logo.jpg"),
          splashIconSize: 150,
          nextScreen: const WelcomeView(),
          splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
