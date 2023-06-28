// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  
  double rating = 0;
  TextEditingController feedbackController = TextEditingController();
  CollectionReference ratingsCollection = FirebaseFirestore.instance.collection('ratings');

  void submitRating() {
    String feedbackText = feedbackController.text;

    ratingsCollection.add({
      'rating': rating,
      'feedback': feedbackText,
    })
    .then((value) {
      print('Rating and feedback stored successfully in Firestore!');
    })
    .catchError((error) {
      print('Error storing rating and feedback: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData? queryData;
    queryData = MediaQuery.of(context);
    return Sizer(
      builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Feedback'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:4.h, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               SizedBox(height: 8.h,),
                Center(child: Text('Rate your refil experience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),)), 
                SizedBox(height: 3.h,),
                Center(
                  child: RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 40.0,
                    unratedColor: Colors.grey,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      size: 32,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                ),
                SizedBox(height: 8.h,),
                Text(rating <= 3 ? 'What went wrong?' : 'Tell us what you love about the refill experience, or what we could be doing better', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                SizedBox(height: 3.h,),
                TextField(
                  controller: feedbackController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'write your feedback'
                  ),
                ),
                SizedBox(height: 5.h),
                Center(
                  child: ElevatedButton(
                    // style: ButtonStyle(backgroundColor: Colors.white),
                    onPressed: submitRating,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      }
    );
  }
}
