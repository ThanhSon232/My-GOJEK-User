import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sticky_headers/sticky_headers.dart';

StickyHeader sticky({required BuildContext context,required String title, String? subtitle, required Widget content}) {
  var textTheme = Theme.of(context).textTheme;
  return StickyHeader(
      header: Column(
        children: [
          Text(
            "title",
            style: textTheme.headline1!.copyWith(fontSize: 12),
          ),
          Text(
            "subtitle",
            style: textTheme.headline2!,
          ),
        ],
      ),
      content: content);
}

void showPaymentMethod(
    {required BuildContext context, required double height}) {
  var textTheme = Theme.of(context).textTheme;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: height,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Select a payment method",
              style: textTheme.headline1,
            ),

            Visibility(
                child: Column(
              children: [
              ],
            ))
          ],
        ),
      );
    },
  );
}
