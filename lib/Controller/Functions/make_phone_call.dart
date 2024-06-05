/*
  Call Number Utility Function

  This Dart file defines the `callNumber` utility function, which uses the `url_launcher` package to initiate a phone call.

  Functionality:
  - Takes a phone number as a parameter.
  - Constructs a URL with the phone number to initiate a phone call.
  - Launches the URL if the device supports the calling action.

  Note: Ensure that the `url_launcher` package is included in your project's dependencies.

*/

import 'package:url_launcher/url_launcher.dart';

void callNumber(String phoneNumber) async {
  String url = "tel://$phoneNumber";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not call $phoneNumber';
  }
}
