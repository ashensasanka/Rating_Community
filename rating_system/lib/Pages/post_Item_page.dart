import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rating_system/Pages/profile_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Componants/custom_snackBar.dart';
import '../Componants/loading.dart';
import '../colors.dart';
import 'package:http/http.dart' as http;

import '../comman_var.dart';
import '../commonMethods.dart';

class PostItemPage extends StatefulWidget {
  const PostItemPage({super.key});

  @override
  State<PostItemPage> createState() => _PostItemPageState();
}

class _PostItemPageState extends State<PostItemPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String selectedDeviceType='';

  CommonMethods cMethods = CommonMethods();




  List<XFile>? _imageFileList;
  List<String> _urlOfUploadedImages = [];

  String _currentId = Random().nextInt(999999).toString().padLeft(6, '0');

  String generateNextPostId() {
    // Convert the current ID back to an integer, increment it, and then convert it back to a String.
    int currentIdInt = int.parse(_currentId);
    currentIdInt++;
    _currentId = currentIdInt.toString().padLeft(6, '0');
    // Return the postId formatted as a 6-digit string, e.g., "000002"
    print(_currentId);
    return _currentId;

  }

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
    generateNextPostId();
  }

  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);

    if(_imageFileList != null) //image validation
        {
      signUpFormValidation();
    }
    else
    {
      showCustomSnackBar(context,
          message: 'Please choose images first.',
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          icon: Icons.error);
    }
  }

  signUpFormValidation()
  {
    if(_modelController.text.trim().length < 1)
    {

      showCustomSnackBar(context,
          message: "Model can't be empty!" ,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          icon: Icons.error);
    }
    else if(_titleController.text.trim().length < 1)
    {
      showCustomSnackBar(context,
          message: "Title can't be empty!" ,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          icon: Icons.error);
    }
    else if(_descriptionController.text.length < 1)
    {
      showCustomSnackBar(context,
          message: "Description can't be empty!" ,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          icon: Icons.error);
    }
    else if(_priceController.text.trim().length < 1)
    {
      showCustomSnackBar(context,
          message: "Price can't be empty!" ,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          icon: Icons.error);
    }
    else
    {
      uploadImageToStorage();
    }
  }

  uploadImageToStorage() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) => LoadingDialog(messageText: "Uploading your Images..."),
    );

    if (_imageFileList != null && _imageFileList!.length <= 5) {
      for (var imageFile in _imageFileList!) {
        String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceImage = FirebaseStorage.instance.ref().child("Images/$_currentId/$imageIDName");

        if (kIsWeb) {
          // For Flutter web, read the file as a blob and upload
          final blob = await imageFile.readAsBytes();
          UploadTask uploadTask = referenceImage.putBlob(blob);
          TaskSnapshot snapshot = await uploadTask;
          String imageUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            _urlOfUploadedImages.add(imageUrl);
          });
        } else {
          // For mobile, continue using putFile
          UploadTask uploadTask = referenceImage.putFile(File(imageFile.path));
          TaskSnapshot snapshot = await uploadTask;
          String imageUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            _urlOfUploadedImages.add(imageUrl);
          });
        }
      }

      // After uploading all images, proceed to save post data
      Navigator.pop(context);
      createNewPost();
    } else {
      // Handle the error or show a message if there are no images or too many images
      showCustomSnackBar(context,
          message: 'Failed to upload your Images. Please try again.',
          backgroundColor: Colors.red.shade500,
          textColor: Colors.white,
          icon: Icons.error_outline);
    }
  }



  createNewPost() async {
    // Show loading or progress indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) => LoadingDialog(messageText: "Posting your add..."),
    );

    DatabaseReference postsRef = FirebaseDatabase.instance.ref().child("posts/$_currentId");
    Map<String, dynamic> postsDataMap = {
      "photos": _urlOfUploadedImages,
      "deviceType": selectedDeviceType,
      "itemType": _itemController.text.trim(),
      "model": _modelController.text.trim(),
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "price": _priceController.text.trim(),
      "postID": _currentId,
      // Add other post details as needed
    };

    try {
      await postsRef.set(postsDataMap);
      // If the post is successfully uploaded, first close the loading dialog
      Navigator.pop(context); // This closes the loading dialog

      // Then, show a success message
      showCustomSnackBar(context,
          message: 'Your post uploaded successfully!',
          backgroundColor: Colors.green.shade500,
          textColor: Colors.white,
          icon: Icons.check_circle_outline_rounded);
    } catch (error) {
      // If there's an error, first close the loading dialog
      Navigator.pop(context); // This closes the loading dialog

      // Then, handle errors, such as showing an error message
      // Example error handling:
      showCustomSnackBar(context,
          message: 'Failed to upload your post. Please try again.',
          backgroundColor: Colors.red.shade500,
          textColor: Colors.white,
          icon: Icons.error_outline);
    }
  }



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
                      value: selectedDeviceType.isEmpty ? null : selectedDeviceType, // Use the selectedDeviceType as the current value
                      onChanged: (newValue) {
                        // Update the state with the new value
                        setState(() {
                          selectedDeviceType = newValue ?? ''; // Update the selectedDeviceType with the new value
                        });
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
                      controller: _itemController,
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
                    Text(userEmail),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable();
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
