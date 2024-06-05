// handling google sign in
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/internet_provider.dart';
import 'package:flutter_events_2023/View/Utils/next_screen.dart';
import 'package:flutter_events_2023/View/Utils/snack_bar.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:provider/provider.dart';

Future handleSignUp(
  BuildContext context,
  String photoURL,
  String name,
  String phone,
  String email,
  String password,
) async {
  final sp = context.read<AuthProvider>();
  final ip = context.read<InternetProvider>();
  await ip.checkInternetConnection();
  sp.setLoading(true);

  if (!ip.hasInternet) {
    openSnackBar(context, "Check your Internet connection", LightColor.danger);
    sp.setLoading(false);
  } else {
    try {
      await sp.signUpWithEmailPassword(
        context,
        photoURL,
        name,
        phone,
        email,
        password,
      );
      sp.setLoading(false);
      if (sp.hasError) {
        openSnackBar(context, sp.errorCode ?? "An error occurred", LightColor.danger);
      } else {
        // checking whether user exists or not
        final userExists = await sp.checkUserExists();

        if (userExists) {
          // user exists
          openSnackBar(context, "Please SignIn Already Have Account", LightColor.danger);
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            nextScreenRemoveUntil(context, '/signIn');
          });
        } else {
          // user does not exist
          await sp.saveDataToFirestore();
          sp.setLoading(false);
          openSnackBar(context, "You Have Register Successfully! Please SignIn", Colors.green);
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            nextScreenRemoveUntil(context, '/signIn');
          });
        }
      }
    } catch (e) {
      // Handle any exceptions that may occur during the Google sign-in process.
      openSnackBar(context, "$e", LightColor.danger);
      sp.setLoading(false);
    }
  }
}
