import 'dart:async';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_grab/app/data/common/api_handler.dart';
import 'package:my_grab/app/data/common/location.dart';
import 'package:my_grab/app/data/common/util.dart';
import 'package:my_grab/app/data/models/vehicle.dart';
import 'package:my_grab/app/modules/find_transportation/controllers/find_transportation_controller.dart';
import 'package:my_grab/app/modules/search_page/controllers/search_page_controller.dart';
import 'package:my_grab/app/modules/user/controllers/user_controller.dart';

import '../../../data/common/network_handler.dart';
import '../../../data/common/search_location.dart';
import '../../../data/models/driver.dart';
import '../../../data/models/voucher/voucher.dart';
import '../../../routes/app_pages.dart';

class MapController extends GetxController {
  var id = 0;
  var findTransportationController = Get.find<FindTransportationController>();
  var searchPageController = Get.find<SearchPageController>();
  var userController = Get.find<UserController>();
  var address = ''.obs;
  late GoogleMapController googleMapController;
  var isLoading = false.obs;
  var isDragging = false.obs;
  var isShow = false;
  var pass = false.obs;
  Rx<STATUS> status = STATUS.SELECTVEHICLE.obs;
  RxString text = "Your current location".obs;
  var selectedIndex = 0.obs;
  BitmapDescriptor? mapMarker;
  Voucher? voucher;
  var groupValue = "CASH".obs;

  List<Vehicle> vehicleList = [
    Vehicle(
        name: "Motorbike",
        type: "MOTORBIKE",
        price: "",
        duration: "",
        priceAfterVoucher: "",
        picture: "assets/vehicles/motorcycle.png",
        seatNumber: "2"),
    Vehicle(
        name: "Car4S",
        type: "CAR4S",
        price: "",
        duration: "",
        priceAfterVoucher: "",
        picture: "assets/vehicles/car.png",
        seatNumber: "4"),
    Vehicle(
        name: "Car7S",
        type: "CAR7S",
        price: "",
        duration: "",
        priceAfterVoucher: "",
        picture: "assets/vehicles/car.png",
        seatNumber: "7"),
    Vehicle(
        name: "Car16S",
        type: "CAR16S",
        price: "",
        duration: "",
        priceAfterVoucher: "",
        picture: "assets/vehicles/car.png",
        seatNumber: "16"),
  ];

  //search
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  RxList<LatLng> polylinePoints = <LatLng>[].obs;
  List<PointLatLng> searchResult = [];
  final RxList<Polyline> polyline = <Polyline>[].obs;
  SearchLocation? myLocation;
  SearchLocation? searchingLocation;
  TYPES? types;

  //controller
  Location? from;
  Location? to;

  APIHandlerImp apiHandlerImp = APIHandlerImp();

  Map<dynamic, dynamic> request = {};

  Driver? driver;

  StreamSubscription? listener;
  StreamSubscription? listener1;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    await getCurrentPosition();

    from = Location(
        lat: findTransportationController.position["latitude"],
        lng: findTransportationController.position["longitude"]);

    await getAddress(from);
    await createMarker();

    to = Location(
        lat: findTransportationController.position["latitude"],
        lng: findTransportationController.position["longitude"]);

    polyline.add(Polyline(
      polylineId: const PolylineId('line1'),
      visible: true,
      points: polylinePoints,
      width: 5,
      color: Colors.blue,
    ));

    if (Get.arguments != null) {
      if (Get.arguments["type"] == SEARCHTYPES.LOCATION) {
        isShow = true;
        text.value = "Set pickup location";
        myLocation = Get.arguments["location"];
        await getAddress(myLocation!.location);
        await myLocationMarker("1", myLocation?.location,
            searchPageController.myLocationController);
        types = TYPES.SELECTLOCATION;
      } else {
        if (Get.arguments["location"] != null &&
            Get.arguments["destination"] == null) {
          isShow = true;
          from = Get.arguments["location"];
          text.value = "Set destination";
          await myLocationMarker(
              "2", to, searchPageController.destinationController);
          types = TYPES.SELECTEVIAMAP;
        } else {
          isShow = true;
          searchingLocation = Get.arguments["destination"];
          text.value = "Set pickup location";
          from = searchPageController.currentLocation;
          await myLocationMarker(
              "1", from, searchPageController.myLocationController);
          types = TYPES.SELECTDESTINATION;
        }
      }
    }

    isLoading.value = false;
  }

  getCurrentPosition() async {
    findTransportationController.position.value =
        await findTransportationController.map.getCurrentPosition();
  }

  getAddress(Location? location) async {
    var temp = await findTransportationController.map
        .getCurrentAddress(location?.lat!, location?.lng!);
    address.value =
        "${temp.name}, ${temp.subLocality}, ${temp.subAdministrativeArea}, ${temp.locality},  ${temp.country}";
    location?.address = address.value;
  }

  myLocationMarker(String id, Location? l, TextEditingController t) async {
    await getAddress(l);
    t.text = address.value;
    final Marker marker = Marker(
        markerId: MarkerId(id),
        draggable: true,
        onDrag: (position) {
          isDragging.value = true;
        },
        icon: id == "2"
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onDragEnd: ((newPosition) async {
          isDragging.value = false;
          l?.setLocation(newPosition);
          await getAddress(l);
          t.text = address.value;
        }),
        position: LatLng(
            l?.lat ?? findTransportationController.map.position.latitude,
            l?.lng ?? findTransportationController.map.position.longitude));
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(l!.lat!, l.lng!), zoom: 15),
    ));
    markers[MarkerId(id)] = marker;
  }

  route(Location? from, Location? to) async {
    EasyLoading.show();

    polylinePoints.clear();
    var start = "${from?.lat},${from?.lng}";
    var end = "${to?.lat},${to?.lng}";
    Map<String, String> query = {
      "key": "d2c643ad1e2975f1fa0d1719903704e8",
      "origin": start,
      "destination": end,
      "mode": selectedIndex.value == 0 ? "motorcycle" : "car"
    };

    isLoading.value = true;
    var response = await NetworkHandler.getWithQuery('route', query);
    searchResult = PolylinePoints()
        .decodePolyline(response["result"]["routes"][0]["overviewPolyline"]);
    for (var point in searchResult) {
      polylinePoints.add(LatLng(point.latitude, point.longitude));
    }
    polyline.refresh();

    var response1 = await apiHandlerImp.put({
      "distance": response["result"]["routes"][0]["legs"][0]["distance"]
              ["value"] /
          1000,
      "timeSecond": response["result"]["routes"][0]["legs"][0]["duration"]
          ["value"],
    }, "user/getVehicleAndPrice");

    for (int i = 0;
        i < response1.data["data"]["vehiclesAndPrices"].length;
        i++) {
      vehicleList[i].price =
          response1.data["data"]["vehiclesAndPrices"][i]["price"].toString();
      vehicleList[i].duration = response["result"]["routes"][0]["legs"][0]
              ["duration"]["text"]
          .toString()
          .replaceFirst("phút", "m")
          .replaceFirst("giờ", "h")
          .replaceFirst("giây", "s");
    }

    request["distance"] =
        response["result"]["routes"][0]["legs"][0]["distance"]["value"] / 1000;
    request["timeSecond"] =
        response["result"]["routes"][0]["legs"][0]["duration"]["value"];

    isLoading.value = false;
    EasyLoading.dismiss();
  }

  void dragPosition(MarkerId markerId, CameraPosition position) {
    LatLng newMarkerPosition =
        LatLng(position.target.latitude, position.target.longitude);
    markers[markerId] = Marker(markerId: markerId, position: newMarkerPosition);
  }

  void handleSearch() async {
    if (types == TYPES.SELECTLOCATION) {
      text.value = "Set pickup location";
      searchPageController.currentLocation = myLocation!.location!;
      searchPageController.myLocationController.text = address.value;
      searchPageController.location.clear();
      Get.back();
    } else if (types == TYPES.SELECTDESTINATION) {
      text.value = "Set up destination";
      await myLocationMarker("2", searchingLocation?.location,
          searchPageController.destinationController);
      to = searchingLocation?.location;
      types = TYPES.HASBOTH;
    } else if (types == TYPES.SELECTEVIAMAP) {
      text.value = "Set pickup location";
      await myLocationMarker(
          "1", from, searchPageController.myLocationController);
      types = TYPES.HASBOTH;
    } else if (types == TYPES.HASBOTH) {
      route(from, to);
      pass.value = true;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                (from!.lat! + to!.lat!) / 2, (from!.lng! + to!.lng!) / 2),
            zoom: 15),
      ));
    }
  }

  Future<void> handleMyLocationButton() async {
    await getCurrentPosition();
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(findTransportationController.position["latitude"],
                findTransportationController.position["longitude"]),
            zoom: 15),
      ),
    );
  }

  Future<void> bookingCar() async {
    EasyLoading.show();
    isLoading.value = true;

    // Random random = Random();
    // int randomNumber = random.nextInt(100);

    // print({
    //   "startAddress": {
    //     "address": from?.address,
    //     "longitude": from?.lng,
    //     "latitude": from?.lat
    //   },
    //   "destination": {
    //     "address": to?.address,
    //     "longitude": to?.lng,
    //     "latitude": to?.lat
    //   },
    //   "vehicleAndPrice": {
    //     "vehicleType": vehicleList[selectedIndex.value].type,
    //     "price": vehicleList[selectedIndex.value].price
    //   },
    //   "paymentType": groupValue.value,
    //   "createdTime":
    //   DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now().toLocal()),
    //   "distanceAndTime": {
    //     "distance": request["distance"],
    //     "timeSecond": request["timeSecond"],
    //   },
    //   "discountId": voucher?.discountId,
    //   "note": null
    // });
    var response = await apiHandlerImp.put({
      "startAddress": {
        "address": from?.address,
        "longitude": from?.lng,
        "latitude": from?.lat
      },
      "destination": {
        "address": to?.address,
        "longitude": to?.lng,
        "latitude": to?.lat
      },
      "vehicleAndPrice": {
        "vehicleType": vehicleList[selectedIndex.value].type,
        "price": vehicleList[selectedIndex.value].price
      },
      "paymentType": groupValue.value,
      "createdTime":
          DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now().toLocal()),
      "distanceAndTime": {
        "distance": request["distance"],
        "timeSecond": request["timeSecond"],
      },
      "discountId": voucher?.discountId,
      "note": null
    }, "user/booking");

    if (response.data["status"]) {
      var path = response.data["data"].toString().split("/");
      id = int.parse(path.last);
      status.value = STATUS.FINDING;
      listener = FirebaseDatabase.instance
          .ref(response.data["data"])
          .limitToFirst(1)
          .onChildRemoved
          .listen((event) async {
        var response_2 = await apiHandlerImp
            .get("user/getLinkAfterBooking/${id.toString()}", {});
        var data = await FirebaseDatabase.instance
            .ref(response_2.data["data"])
            .child("DriverAccept")
            .get();
        driver = Driver.fromJson(data.value as Map);
        status.value = STATUS.FOUND;
        listener?.cancel();
        listener1 = FirebaseDatabase.instance
            .ref(response_2.data["data"])
            .onChildChanged
            .listen((event) async {
          if (event.snapshot.exists) {
            var data = event.snapshot.value as Map;
            if (to!.lat!.toStringAsFixed(3) ==
                data["position"]["lat"].toStringAsFixed(3) &&
                to!.lng!.toStringAsFixed(3) ==
                    data["position"]["long"].toStringAsFixed(3)) {
              Get.dialog(
                  AlertDialog(

                    title:
                    const Center(child: Text('Rate your driver')),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          backgroundImage:
                          AssetImage("assets/face.png"),
                        ),
                        const Text("Tran Van Tuan"),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        TextFormField()
                      ],
                    ),
                    actions: [
                      Center(
                        child: TextButton(
                          child: const Text("Send"),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                  useSafeArea: true
              );
              listener1!.cancel();
            }
            final Marker marker = Marker(
                markerId: const MarkerId("3"),
                icon: mapMarker!,
                position:
                LatLng(
                    data["position"]["lat"], data["position"]["long"]));
            markers[const MarkerId("3")] = marker;
          }
        });
      });
    } else {
      Get.snackbar("Order was failed", "Your balance is insufficient",
          backgroundColor: Colors.grey[100]);
    }

    isLoading.value = false;
    EasyLoading.dismiss();
  }

  Future<void> createMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/vehicle_icons/car_icon.png");
  }

  Future<void> handleBackButton() async {
    Get.defaultDialog(
        middleText:
            "You might have to wait longer in next order if you cancel now. Do you still want to cancel?",
        backgroundColor: Colors.white,
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        textConfirm: "Yes",
        onConfirm: () async {
          await cancelBooking();
          Get.close(1);
        },
        radius: 10,
        textCancel: "No, sir");
  }

  Future<void> cancelBooking() async {
    EasyLoading.show();
    isLoading.value = true;

    await apiHandlerImp.put({}, "user/cancelBooking/$id");
    //
    // await FirebaseDatabase.instance
    //     .ref(
    //         "${vehicleList[selectedIndex.value].type}/${double.parse(from!.lat!.toString()).toStringAsFixed(2).replaceFirst(".", ",")}/${double.parse(from!.lng!.toString()).toStringAsFixed(2).replaceFirst(".", ",")}/request/${userController.user!.id.toString()}")
    //     .remove();
    listener!.cancel();
    // listener1!.cancel();
    status.value = STATUS.SELECTVEHICLE;
    isLoading.value = false;

    EasyLoading.dismiss();
  }

  Future<void> handleVoucher() async {
    isLoading.value = true;
    var vo = await Get.toNamed(Routes.VOUCHER, arguments: {"voucher": voucher});

    for (Vehicle v in vehicleList) {
      if (v.priceAfterVoucher != "") {
        v.price = v.priceAfterVoucher;
        v.priceAfterVoucher = "";
      }
    }

    voucher = vo;
    status.value = STATUS.HASVOUCHER;
    if (vo != null) {
      for (Vehicle v in vehicleList) {
        Get.log(v.price!);
        v.priceAfterVoucher = v.price;
        v.price = (double.parse(v.price!) -
                double.parse(v.price!) * voucher!.discountPercent!)
            .toString();
        Get.log(v.price!);
      }
    }
    isLoading.value = false;
  }
}

enum TYPES { SELECTLOCATION, SELECTEVIAMAP, SELECTDESTINATION, HASBOTH }

enum STATUS { SELECTVEHICLE, HASVOUCHER, FINDING, FOUND, COMPLETED, CANCEL }
