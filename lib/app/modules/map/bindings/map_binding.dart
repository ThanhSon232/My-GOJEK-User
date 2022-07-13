import 'package:get/get.dart';
import 'package:my_grab/app/modules/search_page/controllers/search_page_controller.dart';

import '../controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(
      () => MapController(),
    );
    Get.lazyPut<SearchPageController>(
          () => SearchPageController(),
    );
  }
}
