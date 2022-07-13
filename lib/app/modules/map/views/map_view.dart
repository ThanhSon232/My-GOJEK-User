import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    const h_2 = SizedBox(
      height: 20,
    );
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
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      )),
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.navigation,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          await controller.getCurrentPosition();
                          // await controller.getCurrentAddress();
                          controller.googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(
                                      controller.findTransportationController
                                          .position.value["latitude"],
                                      controller.findTransportationController
                                          .position.value["longitude"]),
                                  zoom: 15),
                            ),
                          );
                        },
                      )),
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
                    vertical: 20, horizontal: !controller.pass.value ? 10 : 0),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: Colors.white,
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
                            bottomSheet: SizedBox(
                              height: Get.height * 0.15,
                              width: Get.width,
                              child: Card(
                                color: Colors.grey[100],
                                elevation: 20,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 10,
                            children: [
                              Obx(
                                () => Text(
                                  controller.text.value,
                                  style: textTheme.headline1?.copyWith(
                                      color: Colors.green, fontSize: 15),
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
                                style:
                                    textTheme.headline2?.copyWith(fontSize: 15),
                              ),
                              h_2,
                              Row(
                                children: [
                                  Visibility(
                                    visible: controller.isShow,
                                    child: Expanded(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (controller.types ==
                                                TYPES.SELECTLOCATION) {
                                              controller.text.value =
                                                  "Set pickup location";
                                              controller.searchPageController
                                                      .currentLocation =
                                                  controller
                                                      .myLocation!.location!;
                                              controller
                                                      .searchPageController
                                                      .myLocationController
                                                      .text =
                                                  controller.address.value;
                                              controller
                                                  .searchPageController.location
                                                  .clear();
                                              Get.back();
                                            } else if (controller.types ==
                                                TYPES.SELECTDESTINATION) {
                                              await controller.myLocationMarker(
                                                  "2",
                                                  controller.searchingLocation
                                                      ?.location,
                                                  controller
                                                      .searchPageController
                                                      .destinationController);
                                              controller.to = controller
                                                  .searchingLocation?.location;
                                              controller.types = TYPES.HASBOTH;
                                            } else if (controller.types ==
                                                TYPES.SELECTEVIAMAP) {
                                              controller.text.value =
                                                  "Set pickup location";
                                              await controller.myLocationMarker(
                                                  "1",
                                                  controller.from,
                                                  controller
                                                      .searchPageController
                                                      .myLocationController);
                                              controller.types = TYPES.HASBOTH;
                                            } else if (controller.types ==
                                                TYPES.HASBOTH) {
                                              controller.route(controller.from,
                                                  controller.to);
                                              controller.pass.value = true;
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                          child: Text(
                                            "Next",
                                            style: textTheme.headline1!
                                                .copyWith(color: Colors.white),
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
              ),
            )
          ],
        ));
  }
}
