import 'package:flutter/material.dart';

final theme = ThemeData(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.white,
      centerTitle: false
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      headline2: TextStyle(color: Colors.black, fontSize: 15),
      headline3: TextStyle(color: Colors.black, fontSize: 12),
      bodyText1: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
    ),

  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),



  backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<StadiumBorder>(
      const StadiumBorder(
        side: BorderSide(
          color: Colors.green,
        )
      ),
    )
        )
    ),
);
