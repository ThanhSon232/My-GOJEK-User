import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_grab/app/data/common/fake_search.dart';

import '../../../data/common/voucher_ticket.dart';
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
                          return const TicketView();
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

