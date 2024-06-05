import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/View/Utils/next_screen.dart';
import 'package:flutter_events_2023/View/theme/extention.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/theme/text_styles.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    authProvider.getDataFromSharedPreferences();
    Timer(const Duration(seconds: 3), () {
      authProvider.isSignedIn ? nextScreenRemoveUntil(context, "/home") : nextScreenRemoveUntil(context, "/signIn");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Opacity(
              opacity: .6,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [LightColor.primaryExtraLight, LightColor.primary],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.mirror,
                      stops: [.5, 6]),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/svg/splash.png",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Time To Organize",
                  style: TextStyles.h1Style.black,
                ),
              ),
              Text(
                "Explore all type of event booking",
                style: TextStyles.bodySm.black.bold,
              ),
            ],
          ).alignTopCenter,
        ],
      ),
    );
  }
}
