import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_grab/app/data/common/api_handler.dart';

import '../../../data/models/voucher/voucher.dart';

class VoucherController extends GetxController {
  //TODO: Implement VoucherController
  APIHandlerImp apiHandlerImp = APIHandlerImp();
  ScrollController scrollController = ScrollController();
  var scrollPosition = 0.0.obs;
  final count = 0.obs;
  RxList<Voucher> vouchers = <Voucher>[].obs;
  var isLoading  = false.obs;
  Voucher? selectedVoucher;

  @override
  void onInit() async{
    super.onInit();
    isLoading.value = true;
    scrollController.addListener(() {
      scrollPosition.value = scrollController.position.pixels;
      print(scrollPosition.value);
    });
    selectedVoucher = await Get.arguments["voucher"];

    var response = await apiHandlerImp.get("user/getListDiscount", {});
    for(int i = 0 ; i < response.data["data"].length; i++){
      vouchers.add(Voucher.fromJson(response.data["data"][i]));
    }
    isLoading.value = false;

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
