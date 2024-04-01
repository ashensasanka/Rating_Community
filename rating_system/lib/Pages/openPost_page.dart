import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rating_system/comman_var.dart';

import '../Componants/custom_snackBar.dart';
import '../Componants/loading.dart';
import 'home_page.dart';

class OpenPostPage extends StatefulWidget {
  final Post post;

  OpenPostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<OpenPostPage> createState() => _OpenPostPageState();
}

class _OpenPostPageState extends State<OpenPostPage> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  List<Comment> _comments = [];
  List<Rating> _ratings = [];

  double calculateAverageRating() {
    if (_ratings.isEmpty) return 0;

    double sum = 0;
    for (final rating in _ratings) {
      double value = double.tryParse(rating.ratingValue) ?? 0;
      sum += value; // Assumes ratingValue is already a percentage
    }

    return sum / _ratings.length; // Calculates the average percentage
  }


  @override
  void initState() {
    super.initState();
    loadComments();
    loadRatings();
  }

  void loadComments() async {
    DatabaseReference commentsRef =
        FirebaseDatabase.instance.ref().child("comments/${widget.post.postID}");

    DatabaseEvent event = await commentsRef.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> commentsData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      List<Comment> loadedComments = [];
      commentsData.forEach((key, data) {
        loadedComments.add(Comment.fromMap(Map<String, dynamic>.from(data)));
      });

      setState(() {
        _comments = loadedComments;
      });
    }
  }

  void loadRatings() async {
    DatabaseReference ratingsRef =
    FirebaseDatabase.instance.ref().child("ratings/${widget.post.postID}");

    DatabaseEvent event = await ratingsRef.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> ratingsData =
      Map<String, dynamic>.from(event.snapshot.value as Map);
      List<Rating> loadedRatings = [];
      ratingsData.forEach((key, data) {
        loadedRatings.add(Rating.fromMap(Map<String, dynamic>.from(data)));
      });

      setState(() {
        _ratings = loadedRatings;
      });
    }
  }



  createNewComment() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Posting your comment..."),
    );

    // Corrected reference to the post-specific comments
    DatabaseReference commentsRef =
        FirebaseDatabase.instance.ref().child("comments/${widget.post.postID}");

    Map<String, dynamic> commentDataMap = {
      "comment": _commentController.text, // Use the text from the controller
      "email": userEmail,
      "user": userName,
      "status": '1',
      // Add other details as needed
    };

    try {
      // Using push().set() to add a new comment without overwriting existing ones
      await commentsRef.push().set(commentDataMap);

      Navigator.pop(context); // Close the loading dialog
      showCustomSnackBar(context,
          message: 'Your comment added successfully!',
          backgroundColor: Colors.green.shade500,
          textColor: Colors.white,
          icon: Icons.check_circle_outline_rounded);
      _commentController.clear();
      loadComments();
    } catch (error) {
      Navigator.pop(context); // Close the loading dialog
      showCustomSnackBar(context,
          message: 'Failed to add your comment. Please try again.',
          backgroundColor: Colors.red.shade500,
          textColor: Colors.white,
          icon: Icons.error);
    }
  }

  createNewRating() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Submitting your rating..."),
    );

    DatabaseReference ratingsRef =
    FirebaseDatabase.instance.ref().child("ratings/${widget.post.postID}");

    Map<String, dynamic> ratingDataMap = {
      "ratingValue": _ratingController.text, // Use the text from the rating controller
      "email": userEmail,
      "user": userName,
      "status": '1',
      // Add other details as needed
    };

    try {
      await ratingsRef.push().set(ratingDataMap);

      Navigator.pop(context);
      loadRatings();
      calculateAverageRating();
      showCustomSnackBar(context,
          message: 'Your rating has been added successfully!',
          backgroundColor: Colors.green.shade500,
          textColor: Colors.white,
          icon: Icons.check_circle_outline_rounded);
      _ratingController.clear();
      // Reload ratings if you have a method for it
    } catch (error) {
      Navigator.pop(context); // Close the loading dialog
      showCustomSnackBar(context,
          message: 'Failed to add your rating. Please try again.',
          backgroundColor: Colors.red.shade500,
          textColor: Colors.white,
          icon: Icons.error);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Calculate the average rating
    double averageRatingPercentage = calculateAverageRating();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(50),
              child: PageView.builder(
                itemCount: widget.post.photos.length,
                itemBuilder: (context, index) {
                  return Image.network(widget.post.photos[index],
                      fit: BoxFit.cover);
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Model: ${widget.post.model}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('(Device Type: ${widget.post.deviceType})',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Type: ${widget.post.itemType}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Price: ${widget.post.price}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.post.description}',
                      style: TextStyle(fontSize: 14),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Text('Comments: ',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),

                    Container(
                      height: 180,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _comments.isNotEmpty
                                ? ListView.builder(
                                    itemCount: _comments.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              "${_comments[index].user} : ",
                                              style: TextStyle(
                                                  color: Colors
                                                      .blueAccent.shade700,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              _comments[index].comment,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        // subtitle: Text(_comments[index].user),
                                      );
                                    },
                                  )
                                : Center(child: Text('No comments yet')),
                          ),
                          Expanded(
                            flex: 1,
                            // Ensure the TextField has constraints
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextField(
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                      hintText: "Add your comment",
                                      fillColor: Colors
                                          .grey.shade300, // Gray fill color
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        createNewComment();
                                      },
                                      icon: Icon(
                                        Icons.comment_outlined,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(160, 20),
                                        backgroundColor: Colors
                                            .amberAccent, // Set the background color to green
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30), // Set the border radius
                                        ),
                                      ),
                                      label: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text('Ratings: ',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),

                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      height: 180,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _ratings.isNotEmpty
                                ? ListView.builder(
                              itemCount: _ratings.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    "${_ratings[index].user}: ${_ratings[index].ratingValue}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  // You may add subtitle or trailing widgets if needed
                                );
                              },
                            )
                                : Center(child: Text('No ratings yet')),
                          ),
                          Expanded(
                            flex: 1,
                            // Ensure the TextField has constraints
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2, child: Text('Average Rating: ${averageRatingPercentage.toStringAsFixed(2)}%'),),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _ratingController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Add your rating",
                                      fillColor: Colors
                                          .grey.shade300, // Gray fill color
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        createNewRating();
                                      },
                                      icon: Icon(
                                        Icons.star_border_purple500_rounded,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(160, 20),
                                        backgroundColor: Colors
                                            .amberAccent, // Set the background color to green
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30), // Set the border radius
                                        ),
                                      ),
                                      label: Text(
                                        'Add',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add more details as needed
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment {
  String user;
  String comment;

  Comment({required this.user, required this.comment});

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      user: data['user'] ?? '',
      comment: data['comment'] ?? '',
    );
  }
}

class Rating {
  String user;
  String email;
  String ratingValue;
  String status;

  Rating({required this.user, required this.email, required this.ratingValue, required this.status});

  factory Rating.fromMap(Map<String, dynamic> data) {
    return Rating(
      user: data['user'] ?? '',
      email: data['email'] ?? '',
      ratingValue: data['ratingValue'] ?? '',
      status: data['status'] ?? '',
    );
  }
}

