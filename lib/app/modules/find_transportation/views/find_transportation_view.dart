import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_grab/app/data/common/find_transportation_box.dart';

import '../../../routes/app_pages.dart';
import '../controllers/find_transportation_controller.dart';

class FindTransportationView extends GetView<FindTransportationController> {
  const FindTransportationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: height * 1 / 3,
                floating: false,
                automaticallyImplyLeading: false,
                title: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    )),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "assets/find_transportation.png",
                    fit: BoxFit.fill,
                  ),
                  title: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Obx(() => controller.userController.isLoading.value ? const Center(child:  CircularProgressIndicator()) : Text(
                          "Up for an adventure,${controller.userController.user?.fullName}?",
                          style: textTheme.bodyText1
                              ?.copyWith(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Text(
                        "We can take you anywhere",
                        style: textTheme.headline2
                            ?.copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(bottom: height * 0.2),
                ),
              ),
            ],
          ),
          Obx(
            () => Positioned(
              top: height * 0.355 -
                  (controller.scrollPosition.value < 0
                      ? 0
                      : controller.scrollPosition.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                height: height -
                    height * 0.355 +
                    (controller.scrollPosition.value < 0
                        ? 0
                        : controller.scrollPosition.value),
                width: MediaQuery.of(context).size.width,
                curve: Curves.linearToEaseOut,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            "assets/background_find_transportation.png"))),
              ),
            ),
          ),
          Obx(
            () => CustomScrollView(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAnimatedOpacity(
                  opacity: controller.scrollPosition.value > 50.0 ? 1.0 : 0.0,
                  sliver: const SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.green,
                    title: Text("Where do you want to go?"),
                  ),
                  duration: const Duration(milliseconds: 600),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: height * 0.1,
                  ),
                ),
                SliverToBoxAdapter(
                  child: FindTransportationBox(
                    mapTap: () {
                      Get.toNamed(Routes.MAP);
                    },
                    searchTap: () {
                      Get.toNamed(Routes.SEARCH_PAGE);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
