import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePopUp extends StatefulWidget {
  const ProfilePopUp({super.key});

  @override
  State<ProfilePopUp> createState() => _ProfilePopUpState();
}

class _ProfilePopUpState extends State<ProfilePopUp> {
  String userName = "";
  String email = "";
  String password_ = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      email = prefs.getString('email') ?? "";
      password_ = prefs.getString('password_') ?? "";
      print('Loaded data to profile page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned(
          top: 50, // Adjust this value to change the vertical position
          right: 5, // Adjust this value to change the horizontal position
          child: AlertDialog(
            content: SizedBox(
              height: 380,
              width: 350,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle_sharp, size: 120,)
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "$userName",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        email,
                        style:  TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 180,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            // createUser(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const ResetPasswordOne()),
                            // );

                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            backgroundColor: Colors.blueGrey.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Rounded corners
                            ),
                          ),
                          child: const
                          Text('View Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),


                      ),

                      Container(
                        height: 40,
                        width: 140,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          onPressed: () async {

                            final prefs = await SharedPreferences.getInstance();
                            prefs.remove("login_state"); // Remove the "login_state" key
                            Navigator.of(context).pushNamed('/welcome');

                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            backgroundColor: Colors.blueGrey.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Rounded corners
                            ),
                          ),
                          child: const
                          Text('Logout',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.redAccent
                            ),
                          ),
                        ),


                      ),


                    ],
                  ),

                ],
              ),
            ),


          ),
        ),
      ],
    );
  }
}
