import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_grab/app/data/common/bottom_sheets.dart';
import 'package:my_grab/app/data/common/util.dart';

import '../../../data/models/vehicle.dart';
import '../../../routes/app_pages.dart';
import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: Obx(
          () => GoogleMap(
            polylines: controller.polyline.toSet(),
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController control) {
              controller.isLoading.value = true;
              controller.googleMapController = control;
              controller.isLoading.value = false;
            },
            markers: controller.markers.values.toSet(),
            initialCameraPosition: CameraPosition(
                target: controller.searchingLocation == null
                    ? LatLng(
                        controller
                            .findTransportationController.position["latitude"],
                        controller
                            .findTransportationController.position["longitude"])
                    : LatLng(controller.searchingLocation!.location!.lat!,
                        controller.searchingLocation!.location!.lng!),
                zoom: 15),
          ),
        ),
        bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible:
                        controller.status.value != STATUS.FOUND ? true : false,
                    child: roundedButton(
                        icon: Icons.arrow_back,
                        f: () {
                          if (controller.status.value == STATUS.FINDING) {
                            controller.handleBackButton();
                          } else {
                            Get.back();
                          }
                        }),
                  ),
                  roundedButton(
                      icon: Icons.navigation,
                      f: () async {
                        await controller.handleMyLocationButton();
                      })
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => AnimatedContainer(
                  height: controller.pass.value &&
                          controller.status.value != STATUS.FOUND
                      ? height * 0.42
                      : height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: !controller.pass.value ? 10 : 0),
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!,
                          offset: const Offset(0.0, -2.5), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      border: Border.all(color: Colors.grey[300]!)),
                  duration: const Duration(milliseconds: 500),
                  child: controller.isDragging.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.pass.value
                          ? (controller.status.value == STATUS.SELECTVEHICLE ||
                                  controller.status.value == STATUS.HASVOUCHER
                              ? selectVehicle(
                                  context: context, textTheme: textTheme)
                              : controller.status.value == STATUS.FINDING
                                  ? findingDriver(textTheme: textTheme)
                                  : foundDriver(textTheme: textTheme))
                          : searchContainer(textTheme)),
            )
          ],
        ));
  }

  Widget foundDriver({required TextTheme textTheme}) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your driver is coming",
                    style: textTheme.headline1!.copyWith(fontSize: 13),
                  ),
                  Text(
                    "Never go on a bike which doesn't match the information",
                    style: textTheme.headline2!
                        .copyWith(fontSize: 11, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        30), // Image radius
                                    child: Image.asset("assets/face.png",
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Text(
                                  "Tran Thanh Son",
                                  style: textTheme.headline2!
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "60B3-123456",
                                  style: textTheme.headline1!
                                      .copyWith(fontSize: 16),
                                ),
                                Text(
                                  "Sirius",
                                  style: textTheme.headline2!
                                      .copyWith(fontSize: 16),
                                ),
                                Text(
                                  "0912357990",
                                  style: textTheme.headline2!
                                      .copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: () {},
                        child: const Text("Call driver")),
                  )
                ],
              ),
            ),
    );
  }

  Widget findingDriver({required TextTheme textTheme}) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        controller.vehicleList[controller.selectedIndex.value]
                            .picture!,
                        height: 40,
                      ),
                      title: Text(
                        "Finding a driver for you",
                        style: textTheme.headline2,
                      ),
                      subtitle: Text(
                        "We got your order",
                        style: textTheme.headline3,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/cash_icon.jpeg",
                        height: 40,
                      ),
                      title: Text(
                        "Cash",
                        style: textTheme.headline2,
                      ),
                      trailing: Text(
                        "${formatBalance.format(double.parse(controller.vehicleList[controller.selectedIndex.value].price!))}đ",
                        style: textTheme.headline2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                      height: 80,
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 30),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () async {
                            await controller.cancelBooking();
                          },
                          child: const Text("Cancel order"))),
                ],
              ),
            ),
    );
  }

  Widget searchContainer(TextTheme textTheme) {
    const h_2 = SizedBox(
      height: 20,
    );
    return Wrap(
      spacing: 10,
      children: [
        Obx(
          () => Text(
            controller.text.value,
            style: textTheme.headline1
                ?.copyWith(color: Colors.green, fontSize: 15),
          ),
        ),
        h_2,
        Text(
          controller.address.value,
          style: textTheme.headline1,
        ),
        h_2,
        Text(
          controller.address.value,
          style: textTheme.headline2?.copyWith(fontSize: 15),
        ),
        h_2,
        Row(
          children: [
            Visibility(
              visible: controller.isShow,
              child: Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      controller.handleSearch();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: Text(
                      "Next",
                      style: textTheme.headline1!.copyWith(color: Colors.white),
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget selectVehicle(
      {required BuildContext context, required TextTheme textTheme}) {
    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.vehicleList.length,
                padding: const EdgeInsets.only(bottom: 150),
                itemBuilder: (context, itemBuilder) {
                  return Obx(
                    () => ListTile(
                      tileColor: controller.selectedIndex.value == itemBuilder
                          ? Colors.grey[100]
                          : Colors.white,
                      leading: Image.asset(
                        controller.vehicleList[itemBuilder].picture!,
                        height: 30,
                      ),
                      title: Row(
                        children: [
                          Text(
                            controller.vehicleList[itemBuilder].name!,
                            style: textTheme.headline1!.copyWith(fontSize: 12),
                          ),
                          const Spacer(),
                          Text(
                            "${formatBalance.format(double.parse(controller.vehicleList[itemBuilder].price!))}đ",
                            style: textTheme.headline1!.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(controller.vehicleList[itemBuilder].duration!),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.supervisor_account,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${controller.vehicleList[itemBuilder].seatNumber!} seaters",
                          ),
                          const Spacer(),
                          Visibility(
                            visible: controller.vehicleList[itemBuilder]
                                        .priceAfterVoucher !=
                                    ""
                                ? true
                                : false,
                            child: Text(
                              controller.vehicleList[itemBuilder]
                                          .priceAfterVoucher !=
                                      ""
                                  ? "${formatBalance.format(double.parse(controller.vehicleList[itemBuilder].priceAfterVoucher!))}đ"
                                  : "",
                              style: const TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        controller.selectedIndex.value = itemBuilder;
                        await controller.route(controller.from, controller.to);
                      },
                    ),
                  );
                }),
      ),
      bottomSheet: Container(
        height: Get.height * 0.16,
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                offset: const Offset(0.0, -2.5), //(x,y)
                blurRadius: 3.0,
              ),
            ],
            color: Colors.white,
            border: const Border(
              top: BorderSide(
                //
                color: Colors.black,
                width: 0.1,
              ),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showPaymentMethod(
                        context: context, height: Get.height * 0.95);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/cash_icon.jpeg",
                        height: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Cash >",
                        style: textTheme.headline1!.copyWith(fontSize: 13),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
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
                        onPressed: () async {
                          await controller.handleVoucher();
                        },
                        child: Text(
                          "Voucher",
                          style: textTheme.headline2,
                        )))
              ],
            ),
            const Spacer(),
            SizedBox(
                width: double.infinity,
                height: 40,
                child: IgnorePointer(
                  ignoring: controller.isLoading.value,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () async {
                        controller.status.value = STATUS.FINDING;
                        await controller.bookingCar();
                      },
                      child: const Text("Order")),
                )),
          ],
        ),
      ),
    );
  }

  Widget roundedButton({required IconData icon, required Function() f}) {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[350]!,
                offset: const Offset(0.0, 0.0), //(x,y)
                blurRadius: 10.0,
              ),
            ],
            border: Border.all(color: Colors.grey[300]!)),
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          onPressed: f,
        ));
  }
}
