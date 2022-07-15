import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_grab/app/data/models/user/user_entity.dart';

import 'app/routes/app_pages.dart';
import 'app/themes/theme.dart';

late Box box;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(!Hive.isAdapterRegistered(0)){
    Hive.registerAdapter(UserEntityAdapter());
  }
  await Hive.initFlutter();
  box = await Hive.openBox("box");

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: theme,
      builder: EasyLoading.init(),
      smartManagement: SmartManagement.keepFactory,
    ),
  );
}
