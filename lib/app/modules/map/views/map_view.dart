import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_grab/app/data/common/bottom_sheets.dart';

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
            polylines: controller.polyline.value.toSet(),
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController control) {
              controller.isLoading.value = true;
              controller.googleMapController = control;
              controller.isLoading.value = false;
            },
            markers: controller.markers.value.values.toSet(),
            initialCameraPosition: CameraPosition(
                target: controller.searchingLocation == null
                    ? LatLng(
                        controller.findTransportationController.position
                            .value["latitude"],
                        controller.findTransportationController.position
                            .value["longitude"])
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
                  roundedButton(
                      icon: Icons.arrow_back,
                      f: () {
                        Get.back();
                      }),
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
                  height: controller.pass.value ? height * 0.4 : height * 0.3,
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
                          ? Scaffold(
                              body: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (context, itemBuilder) {
                                    return ListTile(
                                      leading: Text(itemBuilder.toString()),
                                      onTap: () {},
                                    );
                                  }),
                              bottomSheet: Container(
                                height: Get.height * 0.14,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showPaymentMethod(
                                                context: context,
                                                height: Get.height * 0.95);
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
                                                style: textTheme.headline1!
                                                    .copyWith(fontSize: 13),
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
                                                onPressed: () {
                                                  Get.toNamed(Routes.VOUCHER);
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
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () {},
                                            child: const Text("Order"))),
                                  ],
                                ),
                              ),
                            )
                          : searchContainer(textTheme)),
            )
          ],
        ));
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
