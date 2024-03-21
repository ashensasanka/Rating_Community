import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rating_system/Componants/custom_snackBar.dart';
import 'package:rating_system/Componants/glass_box.dart';
import 'package:http/http.dart' as http;
import 'package:rating_system/Pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscure = true;
  bool rememberMe = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // margin: EdgeInsets.all(20),
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: AssetImage(
                    'images/background.jpg'), // Replace with your image path
                fit: BoxFit.cover, // Adjust the BoxFit as needed
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 48),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/welcome');
                            // Action when button is pressed
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  'Skip the Login',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(180, 40),
                            backgroundColor: Colors
                                .blue, // Set the background color to green
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Set the border radius
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlassBox(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Glad you are back.!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                onEditingComplete: () {
                                  // Define what you want to do when editing is complete. For example:
                                  FocusScope.of(context).nextFocus(); // Move focus to the next field
                                },
                                controller: emailController,
                                onChanged: (String value) {
                                  // Implement your filtering logic here if needed
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                onSubmitted: (String value) {
                                  _login();
                                },
                                controller: passwordController,
                                onChanged: (String value) {
                                  // Implement your filtering logic here if needed
                                },
                                obscureText:
                                    isObscure, // Set the obscureText property
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObscure =
                                            !isObscure; // Toggle between show and hide password
                                      });
                                    },
                                    icon: Icon(
                                      isObscure
                                          ? Icons.visibility_off_rounded
                                          : Icons.remove_red_eye_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors
                                          .white, // Set the border color to white
                                    ),
                                    child: Checkbox(
                                      value: rememberMe,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          rememberMe = newValue ??
                                              false; // Set the new value or default to false
                                        });
                                      },
                                      checkColor: Colors.white,
                                      activeColor: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    "Remember Me",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _login();
                                      // Action when button is pressed
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(240, 40),
                                      backgroundColor: Colors
                                          .blue, // Set the background color to green
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Set the border radius
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/forget-password');
                                    },
                                    child: Text(
                                      "Forget Password?",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),

                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 2,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              Center(
                                  child: Image.asset(
                                'images/google.png',
                                width: 240,
                              )),

                              SizedBox(
                                height: 15,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Do you haven't account? ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/signup');
                                    },
                                    child: Text(
                                      "Signup",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )

                              // Container(
                              //   margin: EdgeInsets.all(10),
                              //   width: 240,
                              //   decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //       image:/ Replace with your image path
                              //       fit: BoxFit.cover, // Adjust the BoxFit as needed
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        width: 500,
                        height: 600,
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _login() async {
    bool success = await login(context);
    if (success) {
      // Only navigate if login is successful and the account is activated
      Navigator.of(context)
          .pushNamed('/home');
    }
  }

  Future<bool> login(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      showCustomSnackBar(context,
          message: "Email can't be empty",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          icon: Icons.warning_amber_outlined);
      return false;
    }

    if (emailController.text.trim().length < 3) {
      showCustomSnackBar(context,
          message: "Invalid Email!",
          backgroundColor: Colors.yellow,
          textColor: Colors.white,
          icon: Icons.warning_amber_outlined);
      return false;
    }

    var url = "http://api.workspace.cbs.lk/login.php";
    var data = {
      "email": emailController.text.toString().trim(),
      "password_": passwordController.text.toString().trim(),
    };

    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
      bool status = result['status'];
      if (status) {
        if (result['active'] == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login_state', '1');
          prefs.setString('user_name', result['user_name']);
          prefs.setString('email', result['email']);
          prefs.setString('password_', result['password_']);
          prefs.setString('active', result['active']);
          // Successfully logged in and account is activated
          return true;
        } else {
          showCustomSnackBar(context,
              message: "Account Deactivated",
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              icon: Icons.warning_amber_outlined);

          return false; // Account deactivated
        }
      } else {
        showCustomSnackBar(context,
            message: "Incorrect Password",
            backgroundColor: Colors.yellow,
            textColor: Colors.white,
            icon: Icons.warning_amber_outlined);
        return false; // Incorrect password
      }
    } else {
      showCustomSnackBar(context,
          message: "Error",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          icon: Icons.warning_amber_outlined);
      return false; // Error during login
    }
  }
}
