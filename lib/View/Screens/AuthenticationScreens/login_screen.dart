import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Functions/sign_in_function.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/View/Components/build_buttons.dart';
import 'package:flutter_events_2023/View/Screens/AuthenticationScreens/signup_screen.dart';
import 'package:flutter_events_2023/View/Utils/snack_bar.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/widgets/text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider authProvider, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/login.svg",
                    height: height * 0.4,
                    width: width * 0.8,
                  ),
                  RoundedTextField(
                    controller: emailController,
                    hint: 'Enter Email',
                    color: Colors.transparent,
                    borderColor: Colors.transparent,
                    pIcon: const Icon(Icons.mail),
                  ),
                  const SizedBox(height: 20),
                  RoundedTextField(
                    controller: passwordController,
                    obscureText: _passwordVisible,
                    hint: 'Password',
                    color: Colors.transparent,
                    borderColor: Colors.transparent,
                    pIcon: const Icon(Icons.lock),
                    sIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: buildRegisterButton(() async {
                        if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
                          authProvider.setLoading(true);
                          await handleSignIn(context, emailController.text, passwordController.text);
                          authProvider.setLoading(false);
                        } else {
                          openSnackBar(context, "Please fill out the credentials", LightColor.primary);
                        }
                      },
                          authProvider.loading
                              ? const SpinKitThreeBounce(
                                  color: LightColor.white,
                                  size: 30.0,
                                )
                              : Text("Login", style: GoogleFonts.poppins(color: LightColor.white, fontSize: 16, fontWeight: FontWeight.w600)))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Have An Account?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: LightColor.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: LightColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
