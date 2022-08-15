import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_grab/app/data/common/fake_search.dart';
import 'package:get/get.dart';
import 'package:my_grab/app/modules/find_transportation/controllers/find_transportation_controller.dart';

import '../../routes/app_pages.dart';

class FindTransportationBox extends StatelessWidget {
  FindTransportationBox({Key? key, this.searchTap, this.mapTap})
      : super(key: key);
  Function()? searchTap;
  Function()? mapTap;

  var controller = Get.find<FindTransportationController>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var textTheme = Theme.of(context).textTheme;

    const h = SizedBox(
      height: 10,
    );
    const h_1 = SizedBox(
      height: 40,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(10),
      height: height * 0.6,
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: mapTap,
            child: Container(
              height: height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : IgnorePointer(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  controller.position.value["latitude"],
                                  controller.position.value["longitude"]),
                              zoom: 18),
                          liteModeEnabled: Platform.isAndroid ? true : false,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: false,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: true,
                        ),
                      ),
              ),
            ),
          ),
          h,
          FakeSearch(
            borderColor: Colors.grey[300],
            backgroundColor: Colors.grey[200],
            hint: "Search a location",
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icons.my_location_rounded,
            prefixIconColor: Colors.green,
            suffixIcon: Icons.search,
            onTap: searchTap,
          ),
          h_1,
          const Icon(
            Icons.bookmark_add,
            color: Colors.green,
            size: 50,
          ),
          h,
          Text(
            "Save an address for a faster booking",
            style: textTheme.headline1?.copyWith(fontSize: 15),
          ),
          h,
          Text(
            "Any frequently used address? Let's save it & never type it ever again",
            style: textTheme.headline2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
