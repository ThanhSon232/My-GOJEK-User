import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_grab/app/data/common/fake_search.dart';

import '../controllers/voucher_controller.dart';

class VoucherView extends GetView<VoucherController> {
  const VoucherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          color: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Text(
                      "Vouchers",
                      style: textTheme.headline1!.copyWith(color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                FakeSearch(
                  prefixIcon: Icons.search,
                  hint: 'Have a promo code? Enter it here...',
                  suffixIcon: Icons.arrow_forward_ios,
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => AnimatedPositioned(
              top: controller.scrollPosition.value <= 0
                  ? Get.height * 0.2
                  : Get.height * 0.12,
              duration: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16)),
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available vouchers",
                        style: textTheme.headline1!.copyWith(fontSize: 15),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 120),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, itemBuilder) {
                          return TicketView();
                        },
                        itemCount: 10,
                      ),
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }
}

class TicketView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            margin: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "7.000VND discount",
                    style: textTheme.headline1!.copyWith(fontSize: 18),
                  ),
                  Text(
                    "Final trip fare: 8.000VND",
                    style: textTheme.headline2,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.grey[100]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Flex(
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (index) => SizedBox(
                                    height: 1,
                                    width: 5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade400),
                                    ),
                                  )),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
          ),
          Stack(children: [
            Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      "assets/logo_gojek.png",
                      height: 20,
                    )),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      offset: const Offset(1.0, 5), //(x,y)
                      blurRadius: 1.0,
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24))),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.access_time,
                    color: Colors.black,
                    size: 10,
                  ),
                  Text(
                    "Voucher expires on 27-07-22",
                    style: textTheme.headline3!.copyWith(fontSize: 9),
                  ),
                  const Spacer(),
                  SizedBox(
                      width: 100,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(
                                side: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              primary: Colors.white,
                              elevation: 0),
                          onPressed: () {},
                          child: Text(
                            "Apply",
                            style: textTheme.headline2,
                          )))
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
