import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rating_system/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Componants/custom_snackBar.dart';
import '../Componants/glass_box.dart';
import '../Componants/post_images.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  bool? rememberMe = false;

  Future<void> _login() async {
    bool success = await login(context);
    if (success) {
      // Only navigate if login is successful and the account is activated
      Navigator.of(context).pushNamed('/home');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.appBarColor,
        toolbarHeight: 85.0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Rating Community',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 300,
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: searchController,
                onChanged: (String value) {
                  // Implement your filtering logic here if needed
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Share Your',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            )
          ],
        ),


        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 25),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                  // Action when button is pressed
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16,color: Colors.black,),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 20),
                  backgroundColor: Colors.white, // Set the background color to green
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(30), // Set the border radius
                  ),
                ),
              ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 25),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
                // Action when button is pressed
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16,color: Colors.white,),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 20),
                backgroundColor: Colors.blue, // Set the background color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(30), // Set the border radius
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 25),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      child: SingleChildScrollView(
                        child: Container(
                          color: Colors.black,
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
                                  style: TextStyle(color: Colors.white),
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
                                  style: TextStyle(color: Colors.white),
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
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Post Your Item',
                style: TextStyle(fontSize: 16,color: Colors.white,),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(160, 20),
                backgroundColor: Colors.amberAccent, // Set the background color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(30), // Set the border radius
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(25),
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('images/topImage.jpg'), // Replace with your image path
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Find the Best Products',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
        
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Discover the World of Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        
            ImageDisplayPage(postId: '000003'),

            Image.network(
    'http://api.workspace.cbs.lk/uploads/000007/scaled_ser02.png'),
        
          ],
        ),
      ),

    );
  }
}
