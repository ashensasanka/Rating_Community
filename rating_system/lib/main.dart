import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rating_system/Pages/post_Item_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_system/Pages/forgetpw_page.dart';
import 'package:rating_system/Pages/home_page.dart';
import 'package:rating_system/Pages/login_page.dart';
import 'package:rating_system/Pages/signup_page.dart';
import 'Pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugin services are initialized
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Initialize SharedPreferences

  runApp(MyApp(prefs: prefs)); // Pass SharedPreferences to MyApp
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs; // Add SharedPreferences to MyApp

  const MyApp({super.key, required this.prefs});

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
      home: _decideMainPage(), // Use _decideMainPage to determine the initial route
    );
  }

  Widget _decideMainPage() {
    // Check if 'login_state' is not null, then navigate to HomePage, otherwise to LandingPage
    if (prefs.getString('login_state') != null) {
      return HomePage();
    } else {
      return LandingPage();
    }
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
