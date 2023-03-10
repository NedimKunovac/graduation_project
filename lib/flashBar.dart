import 'package:flutter/material.dart';
import 'package:flash/flash.dart';

class flashBar {
  static showBasicsFlash(
      {Duration? duration,
      flashStyle = FlashBehavior.floating,
      context,
      String? message}) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          backgroundColor: Colors.red,
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Text(
              message.toString(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
