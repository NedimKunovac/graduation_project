import 'package:flutter/material.dart';
import 'package:flash/flash.dart';

///Flashbar that pops up on the bottom of the page
///Mostly used for errors
///Two functions showBasicsFlashSuccessful[Green] and showBasicsFlashFailed showBasicsFlashFailed[Red]

class flashBar {
  static showBasicsFlashFailed(
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
          position: FlashPosition.top,
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

  static showBasicsFlashSuccessful(
      {Duration? duration,
      flashStyle = FlashBehavior.floating,
      context,
      String? message}) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          backgroundColor: Colors.green,
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.top,
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
