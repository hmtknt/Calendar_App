// handling google sign in
// here if user exist the login other sign up the user
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/internet_provider.dart';
import 'package:flutter_events_2023/View/Utils/snack_bar.dart';
import 'package:provider/provider.dart';

Future handleSignIn(
  BuildContext context,
  String email,
  String password,
) async {
  final sp = context.read<AuthProvider>();
  final ip = context.read<InternetProvider>();
  await ip.checkInternetConnection();
  sp.setLoading(true);

  if (ip.hasInternet == false) {
    openSnackBar(context, "Check your Internet connection", Colors.red);
    sp.setLoading(false);
  } else {
    await sp
        .signInWithEmailAndPwd(
      context,
      email,
      password,
    )
        .then((value) async {
      if (sp.hasError == true) {
        openSnackBar(context, sp.errorCode.toString(), Colors.red);
      } else {
        // checking whether user exists or not
        await sp.getUserDataFromFirestore(sp.uid).then((value) => sp.saveDataToSharedPreferences().then((value) => sp.setSignIn().then((value) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            })));
      }
    });
  }
}
