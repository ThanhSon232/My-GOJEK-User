import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../../data/common/loading.dart';
import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({Key? key}) : super(key: key);

  Widget userLoading() {
    return ListTile(
      leading: Container(
          margin: const EdgeInsets.only(right: 10),
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.red, shape: BoxShape.circle),
          child: Center(
              child: Image.asset(
                "assets/icon_account.png",
                color: Colors.white,
                height: 20,
                width: 20,
              ))),
      title: Loading.circle(width: Get.width, height: 13, borderRadius: 13),
      horizontalTitleGap: 10,
      subtitle:  Padding(
        padding: EdgeInsets.only(right: Get.width*0.15),
        child: Loading.circle(width: Get.width, height: 13, borderRadius: 13),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.auto_fix_normal),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
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
        title: Text(
          "My Profile",
          style: textTheme.headline1,
        ),
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Obx(() =>  controller.isLoading.value ? userLoading() :  ListTile(
                        leading: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Center(
                                child: Image.asset(
                              "assets/icon_account.png",
                              color: Colors.white,
                              height: 20,
                              width: 20,
                            ))),
                        title: Text(
                          controller.user!.fullName!,
                          style: textTheme.headline1,
                        ),
                        horizontalTitleGap: 10,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.user!.email!,
                              style: textTheme.headline2,
                            ),
                            Text(
                              "+84${controller.user!.phoneNumber!}",
                              style: textTheme.headline2,
                            )
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.auto_fix_normal),
                          onPressed: () {},
                        ),
                      )
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return StickyHeader(
                  header: Container(
                    height: 50.0,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.header[index],
                      style: textTheme.headline1!.copyWith(fontSize: 12),
                    ),
                  ),
                  content: ShrinkWrappingViewport(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                if (controller.settings[index].name ==
                                    "Log out") {
                                  Get.offAllNamed(
                                      controller.settings[index].page);
                                  controller.logout();
                                }
                              },
                              leading: Image.asset(
                                controller.settings[index].icons,
                                height: 30,
                              ),
                              horizontalTitleGap: 10,
                              title: Text(
                                controller.settings[index].name,
                                style:
                                    textTheme.headline1!.copyWith(fontSize: 16),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                            );
                          },
                          // 40 list items
                          childCount: controller.settings.length,
                        ),
                      )
                    ],
                    offset: ViewportOffset.zero(),
                  ),
                );
              },
              childCount: controller.header.length,
            ),
          ),
        ],
      ),
    );
  }
}
