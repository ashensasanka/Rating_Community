import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rating_system/Pages/profile_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import 'package:http/http.dart' as http;

class PostItemPage extends StatefulWidget {
  const PostItemPage({super.key});

  @override
  State<PostItemPage> createState() => _PostItemPageState();
}

class _PostItemPageState extends State<PostItemPage> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String userName = "";
  String email = "";
  String password_ = "";

  static int _currentId = 0;

  List<XFile>? _imageFileList;

  void _pickImages() async {
    try {
      final List<XFile>? selectedImages = await ImagePicker().pickMultiImage(
        maxWidth: 500,
        maxHeight: 500,
      );
      if (selectedImages!.isNotEmpty) {
        setState(() {
          _imageFileList = selectedImages;
        });
      }
    } catch (e) {
      // Handle any errors
    }
  }

  Widget _buildImagePreview() {
    if (_imageFileList != null) {
      return SizedBox( // Wrap the ListView with a SizedBox to provide a fixed height
        height: 500.0, // Specify the height of the preview area
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageFileList!.length,
            itemBuilder: (context, index) {
              if (kIsWeb) {
                return Image.network(_imageFileList![index].path);
              } else {
                return Image.file(File(_imageFileList![index].path));
              }
            },
          ),
        ),
      );
    } else {
      return const Text("No images selected.");
    }
  }




  @override
  void initState() {
    super.initState();
    loadData();
    generateNextPostId();
  }

  static String generateNextPostId() {
    // Increment the postId
    _currentId++;
    // Return the postId formatted as a 6-digit string, e.g., "000001"
    return _currentId.toString().padLeft(6, '0');
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      email = prefs.getString('email') ?? "";
      password_ = prefs.getString('password_') ?? "";
      print('Loaded data to Home Page');
    });
  }

  // void createNewPost() async {
  //   String postId = generateNextPostId();
  //   print("Generated Post ID: $postId");
  //   if (_imageFileList != null && _imageFileList!.isNotEmpty) {
  //     await uploadImages(_imageFileList!, postId);
  //     // Additional post creation logic here
  //   } else {
  //     print("No images selected.");
  //   }
  // }
  //
  //
  // Future<void> uploadImages(List<XFile> images, String postId) async {
  //   final uri = Uri.parse('http://api.workspace.cbs.lk/upload.php');
  //
  //   for (var image in images) {
  //     // For Flutter web, use bytes to upload
  //     var bytes = await image.readAsBytes();
  //
  //     // Create a MultipartFile from bytes
  //     var multipartFile = http.MultipartFile.fromBytes(
  //       'image', // Field name for the file
  //       bytes,
  //       filename: image.name, // Filename
  //     );
  //
  //     var request = http.MultipartRequest('POST', uri)
  //       ..fields['post_id'] = postId
  //       ..files.add(multipartFile);
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       print('Image uploaded');
  //     } else {
  //       print('Image upload failed');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
          ],
        ),
        actions: [
          Text(
            userName,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ProfilePopUp();
                    },
                  );
                },
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.white,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
              child: const Text(
                'Back to Home',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(160, 20),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20 ,horizontal: 300),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text('Fill in the details',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Colors.teal
                ),),

                SizedBox(height: 15,),

                Divider(thickness: 1,endIndent: 50,indent: 50,),
                Container(

                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),

                  child: Column(children: [

                    // Add your TextField widgets here
                    DropdownButtonFormField<String>(
                      value: null, // Initial value or selected value
                      onChanged: (newValue) {
                        // Update the state with the new value
                      },
                      items: <String>['Mobile Phone', 'Device Type B', 'Device Type C']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text('Device type'),
                    ),

                    SizedBox(height: 10,),
                    // DropdownButtonFormField<String>(
                    //   value: null, // Initial value or selected value
                    //   onChanged: (newValue) {
                    //     // Update the state with the new value
                    //   },
                    //   items: <String>['Brand A', 'Brand B', 'Brand C']
                    //       .map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   hint: const Text('Brand'),
                    // ),
                    // ... More DropdownButtonFormField widgets for each dropdown

                    TextField(
                      controller: _modelController,
                      decoration: const InputDecoration(labelText: 'Item Type'),

                    ),
                    SizedBox(height: 10,),

                    TextField(
                      controller: _modelController,
                      decoration: const InputDecoration(labelText: 'Model'),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      textAlign: TextAlign.left,
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price (Rs)'),
                    ),
                    // Add photo buttons and other form fields
                    SizedBox(height: 10,),

                    _buildImagePreview(),
                    SizedBox(height: 15,),
                    ElevatedButton(
                      onPressed: () {
                        _pickImages();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // Set the background color
                      ),
                      child: const Text('Upload Images',style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(height: 25),

                    // Contact details section
                    Text(userName),
                    Text(email),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        // createNewPost();
                        // Implement the logic to post the item when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // Set the background color
                      ),
                      child: const Text('Post Item',style: TextStyle(color: Colors.white),),
                    ),
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}
