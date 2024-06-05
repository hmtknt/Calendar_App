import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/add_event_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/edit_profile_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/event_scheduale_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/home_screen_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/internet_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/user_provider.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/home_screen.dart';
import 'package:flutter_events_2023/View/Screens/AuthenticationScreens/login_screen.dart';
import 'package:flutter_events_2023/View/Screens/AuthenticationScreens/signup_screen.dart';
import 'package:flutter_events_2023/View/Screens/IntroScreens/splash_page.dart';
import 'package:flutter_events_2023/View/theme/theme.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => InternetProvider())),
        ChangeNotifierProvider(create: ((context) => EditProfileProvider())),
        ChangeNotifierProvider(create: ((context) => HomeScreenProvider())),
        ChangeNotifierProvider(create: ((context) => AddEventProvider())),
        ChangeNotifierProvider(create: ((context) => EventScheduleProvider())),
        ChangeNotifierProvider(create: ((context) => UserProvider())),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Health Care',
          theme: AppTheme.lightTheme,
          routes: {
            '/welcomeScreen': (context) => const SplashPage(),
            '/home': (context) => const HomeScreen(),
            '/signIn': (context) => const LoginScreen(),
            '/signUp': (context) => const SignUpScreen(),
          },
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        );
      }),
    );
  }
}
