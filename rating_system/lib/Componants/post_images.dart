import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageDisplayPage extends StatefulWidget {
  final String postId;

  const ImageDisplayPage({Key? key, required this.postId}) : super(key: key);

  @override
  _ImageDisplayPageState createState() => _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {
  List<String> imageUrls = [];
  String? url1;
  String? url2;
  String? url3;
  String? url4;
  String? url5;


  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final uri = Uri.parse('http://api.workspace.cbs.lk/getImages.php?post_id=${widget.postId}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> imagesJson = json.decode(response.body);
      List<String> urls = imagesJson.map<String>((url) => url.toString().replaceFirst('https://', 'http://')).toList();

      // Assign URLs to variables, checking list length to avoid index out of range errors
      if (urls.isNotEmpty) {
        url1 = urls.length > 0 ? urls[0] : null;
        url2 = urls.length > 1 ? urls[1] : null;
        url3 = urls.length > 2 ? urls[2] : null;
        url4 = urls.length > 3 ? urls[3] : null;
        url5 = urls.length > 4 ? urls[4] : null;
        // Continue as needed
      }

      // For demonstration, printing the URLs; Replace with your actual usage
      print("URL 1: $url1");
      print("URL 2: $url2");
      print("URL 3: $url3");
      print("URL 4: $url4");
      print("URL 5: $url5");
      // Print more as needed

      setState(() {
        // Trigger UI update if necessary
      });
      print('Images Loaded');
    } else {
      print('Failed to load images. Status code: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: (imageUrls.isNotEmpty)
          ? SizedBox(
        height: 500, // Height of the container
        width: 1000, // Width of the container
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Image.network(
              imageUrls[index],
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                // Log or display the error here
                print(error); // For debugging
                return Icon(Icons.error,color: Colors.white,); // Provide a fallback UI
              },
            );


          },
        ),
      )
          : CircularProgressIndicator(), // Show a loader until images are loaded
    );
  }
}
