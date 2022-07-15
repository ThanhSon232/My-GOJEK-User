import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_grab/app/data/common/api_handler.dart';
import 'package:my_grab/app/data/models/user/user_entity.dart';

import '../../../data/models/user_settings.dart';
import '../../../routes/app_pages.dart';

class UserController extends GetxController {
  //TODO: Implement UserController
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  var box;
  UserEntity? user;
  var isLoading = false.obs;

  List<String> header = [
    "Account",
    "General"
  ];
  List<UserSettings> settings = [
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "My Orders", icons: "assets/setting_icons/my_orders.png", page: Routes.HOME),
    UserSettings(name: "Log out", icons: "assets/setting_icons/log_out.jpeg", page: Routes.WELCOME),
  ];
  @override
  void onInit() async{
    isLoading.value = true;
    box = await Hive.openBox("box");
    if(box.isOpen){
      if(!box.containsKey("user")){
        await getUserData();
      } else {
        user = await box.get("user");
      }
    }
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
    await box.close();
  }

  void logout() async{
    await box.clear();
    await apiHandlerImp.deleteToken();
}

  Future<void> getUserData() async {
    isLoading.value = true;
    var response = await apiHandlerImp.get("user/getInforByToken", {});
    user = UserEntity.fromJson(response.data["data"]);
    await box.put("user", user);
    isLoading.value = false;
  }

}
