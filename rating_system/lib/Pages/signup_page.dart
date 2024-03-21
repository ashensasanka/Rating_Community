import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Componants/glass_box.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool isObscure = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    // Always remember to dispose of FocusNodes
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }



  // Future<void> createUser(BuildContext context) async {
  //   // Validate input fields
  //   if (userNameController.text.trim().isEmpty ||
  //       passwordController.text.trim().isEmpty ||
  //       emailController.text.trim().isEmpty ||
  //       confirmPasswordController.text.isEmpty ) {
  //     // Show an error message if any of the required fields are empty
  //     showRequiredFieldsSnackBar(context);
  //     return;
  //   }
  //
  //   // Check if password and confirm password match
  //   if (passwordController.text != confirmPasswordController.text) {
  //     // Show an error message if passwords do not match
  //     showPasswordMismatchSnackBar(context);
  //     return;
  //   }
  //   // Other validation logic can be added here
  //
  //   // If all validations pass, proceed with the registration
  //   var url = "http://api.workspace.cbs.lk/createUser.php";
  //
  //   var data = {
  //     "user_name": userNameController.text.trim(),
  //     "email": emailController.text.toString().trim(),
  //     "password_": passwordController.text.toString().trim(),
  //     "active": '1',
  //   };
  //
  //   http.Response res = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     },
  //     encoding: Encoding.getByName("utf-8"),
  //   );
  //
  //   if (res.statusCode.toString() == "200") {
  //     if (jsonDecode(res.body) == "true") {
  //       if (!mounted) return;
  //       showSuccessSnackBar(context); // Show the success SnackBar
  //       Navigator.of(context).pushNamed('/login');
  //     } else {
  //       if (!mounted) return;
  //       showError(context);
  //     }
  //   } else {
  //     if (!mounted) return;
  //     showError(context);
  //   }
  // }


  void showSuccessSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green, // Custom background color
      content: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.white), // Custom icon
          SizedBox(width: 8), // Space between icon and text
          Expanded(
            child: Text(
              'Account created successful! You can login now!',
              style: TextStyle(color: Colors.white, fontSize: 16), // Custom text style
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.white, // Custom text color for the action
        onPressed: () {
          // Handle action (e.g., undo the submission)
        },
      ),
      duration: Duration(seconds: 5), // Custom duration
      behavior: SnackBarBehavior.floating, // Make it floating
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Custom shape
      margin: EdgeInsets.all(10), // Margin from the edges
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Custom padding
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showRequiredFieldsSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red, // Custom background color for emphasis
      content: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: Colors.white), // Custom icon for warning
          SizedBox(width: 8), // Space between icon and text
          Text(
            'Please fill in all required fields', // The message
            style: TextStyle(color: Colors.white, fontSize: 16), // Custom text style
          ),
        ],
      ),
      duration: Duration(seconds: 5), // Custom duration
      behavior: SnackBarBehavior.floating, // Make it floating
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Custom shape
      margin: EdgeInsets.all(10), // Margin from the edges
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Custom padding
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showError(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red, // Custom background color for emphasis
      content: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: Colors.white), // Custom icon for warning
          SizedBox(width: 8), // Space between icon and text
          Text(
            'Error', // The message
            style: TextStyle(color: Colors.white, fontSize: 16), // Custom text style
          ),
        ],
      ),
      duration: Duration(seconds: 5), // Custom duration
      behavior: SnackBarBehavior.floating, // Make it floating
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Custom shape
      margin: EdgeInsets.all(10), // Margin from the edges
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Custom padding
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  void showPasswordMismatchSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red, // Custom background color for emphasis
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white), // Custom icon for error
          SizedBox(width: 8), // Space between icon and text
          Text(
            'Passwords do not match', // The message
            style: TextStyle(color: Colors.white, fontSize: 16), // Custom text style
          ),
        ],
      ),
      duration: Duration(seconds: 5), // Custom duration
      behavior: SnackBarBehavior.floating, // Make it floating
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Custom shape
      margin: EdgeInsets.all(10), // Margin from the edges
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Custom padding
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                              'Roll the Carpet.!',
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
                                      'Skip the Signup',
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
                                fixedSize: const Size(190, 40),
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
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Signup',
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
                                    controller: userNameController,
                                    onChanged: (String value) {
                                      // Implement your filtering logic here if needed
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'User Name',
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
                                    onEditingComplete: () {
                                      // Define what you want to do when editing is complete. For example:
                                      FocusScope.of(context).nextFocus(); // Move focus to the next field
                                    },
                                    controller: emailController,
                                    onChanged: (String value) {
                                      // Implement your filtering logic here if needed
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Your Email',
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
                                    onEditingComplete: () {
                                      // Move focus to the next field explicitly
                                      _confirmPasswordFocusNode.requestFocus();
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

                                  TextField(
                                    focusNode: _confirmPasswordFocusNode,
                                    onEditingComplete: () {
                                      // Define what you want to do when editing is complete. For example:
                                      // createUser(context);
                                    },

                                    controller: confirmPasswordController,
                                    onChanged: (String value) {
                                      // Implement your filtering logic here if needed
                                    },
                                    obscureText:
                                    isObscure, // Set the obscureText property
                                    decoration: InputDecoration(
                                      hintText: 'Confirm your password',
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

                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 20),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // createUser(context);
                                          // Action when button is pressed
                                        },
                                        child: const Text(
                                          'Signup',
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

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  Center(child: Image.asset('images/google.png',width: 240,)),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already Registered? ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),

                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed('/login');
                                        },
                                        child: Text(
                                          "Login",
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
}
