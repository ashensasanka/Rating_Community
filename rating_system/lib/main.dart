import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rating_system/Pages/post_Item_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_system/Pages/forgetpw_page.dart';
import 'package:rating_system/Pages/home_page.dart';
import 'package:rating_system/Pages/login_page.dart';
import 'package:rating_system/Pages/signup_page.dart';
import 'Pages/landing_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // This should include your databaseURL
  );

  runApp(MyApp()); // Pass SharedPreferences to MyApp
}

class MyApp extends StatelessWidget {

  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/welcome': (context) => LandingPage(),
        '/forget-password': (context) => ForgetPWPage(),
        '/home': (context) => HomePage(),
        '/post-item': (context) => PostItemPage(),
      },
      home: FirebaseAuth.instance.currentUser == null ? LandingPage() :HomePage(), // Use _decideMainPage to determine the initial route
    );
  }


}


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // Use your custom scrollbar here or return the child directly to use the default scrollbar
    return child;
  }

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad
    // Add other device kinds as needed
  };
}
