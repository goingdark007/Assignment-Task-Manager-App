import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';

class PinPutTheme {

  static final defaultTheme = PinTheme(
    width: 80,
    height: 50,
    textStyle: TextStyle(fontSize: 20),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.lightGreen),
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey.shade200,
    ),
  );

  static final focusedTheme = defaultTheme.copyWith(

    decoration: BoxDecoration(
      color: Colors.lightGreen,
      borderRadius: BorderRadius.circular(5),
    ),

  );

}
