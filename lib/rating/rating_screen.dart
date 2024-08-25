// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/realstate_model.dart';

import '../widgets/mix_widgets.dart';

class RatingScreen extends StatefulWidget {
  final String? sellerId;
  final RealStateModel? model;
  const RatingScreen({super.key, this.sellerId, this.model});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final ratingController = TextEditingController();

  double countStarsRating = 0.0;

  @override
  void dispose() {
    ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
          title: wText('Rate Seller', size: 24, color: Colors.white),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        body: _buildDialog(),
      ),
    );
  }

  _buildDialog() {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              wText('Rate the seller'),
              SizedBox(height: 20),
              Divider(
                thickness: 3,
              ),
              Row(
                children: [],
              ),
              SmoothStarRating(
                rating: countStarsRating.toDouble(),
                size: 50,
                color: Colors.amber,
                borderColor: Colors.amber,
                starCount: 5,
                allowHalfRating: true,
                spacing: 2.0,
                onRatingChanged: (value) {
                  setState(() {
                    countStarsRating = value.toDouble();
                    if (countStarsRating == 0) {
                      titleStarsRating = 'Very Bad';
                    }
                    if (countStarsRating == 1) {
                      titleStarsRating = 'Very Bad';
                    }
                    if (countStarsRating == 2) {
                      titleStarsRating = 'Bad';
                    }
                    if (countStarsRating == 3) {
                      titleStarsRating = 'Good';
                    }
                    if (countStarsRating == 4) {
                      titleStarsRating = 'Very Good';
                    }
                    if (countStarsRating == 5) {
                      titleStarsRating = 'Excellent';
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              wText(titleStarsRating, size: 30),
              SizedBox(height: 20),
              wInput(hint: 'Comment', maxLines: 2),
              SizedBox(height: 20),
              wButton(
                  'Submit', Colors.blue,
                  size: 50,
                  onPressed: () {
                // Navigator.pop(context);
                //     if same current user have own profile then not allow to rate
                if (sharedPreferences?.getString('uid') == widget.sellerId) {
                  Get.back();
                  QuickAlert.show(
                      context: Get.context!,
                      title: 'Rating',
                      text: 'You can not reviews add yourself',
                      type: QuickAlertType.error);
                  return;
                }else{
                  _saveRating(ratingController.text);
                }
              }),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  wInput({required String hint, required int maxLines}) {
    return TextField(
      controller: ratingController,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  void _saveRating(String value) async {
    // save rating to database
    try {
      if (countStarsRating == 0.0) {
        QuickAlert.show(
            context: Get.context!,
            title: 'Rating',
            text: 'Please rate',
            type: QuickAlertType.error);
        return;
      }
      if (ratingController.text.isEmpty) {
        QuickAlert.show(
            context: Get.context!,
            title: 'Rating',
            text: 'Please comment',
            type: QuickAlertType.error);
        return;
      }
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(widget.sellerId)
          .get()
          .then((snap) async {
        if (snap.data()!["rating"] == null) {
          FirebaseFirestore.instance
              .collection('sellers')
              .doc(widget.sellerId)
              // realstate
              .update({
            'rating': countStarsRating.toString(),
          });
          await sharedPreferences?.setString('rating', countStarsRating.toString());
          await FirebaseFirestore.instance
              .collection('sellers')
              .doc(widget.sellerId)
              .collection('rating')
              .doc(sharedPreferences?.getString('uid'))
              .set({
            'rating': countStarsRating.toString(),
            "totalRating": countStarsRating.toString(),
            "title": titleStarsRating,
            'comment': ratingController.text,
            'name': sharedPreferences?.getString('name'),
            "image": sharedPreferences?.getString('image'),
            "email": sharedPreferences?.getString('email'),
            'phone': sharedPreferences?.getString('phone'),
            'date': DateTime.now().toString(),
          });
        } else {
          double pastRating = double.parse(snap.data()!["rating"].toString());
          double newRating = double.parse(countStarsRating.toString());
          double totalRating = (pastRating + newRating) / 2;
          FirebaseFirestore.instance
              .collection('sellers')
              .doc(widget.sellerId)
              .update({
            'rating': totalRating.toString(),
          });
          await sharedPreferences?.setString('rating', totalRating.toString());
          await FirebaseFirestore.instance
              .collection('sellers')
              .doc(widget.sellerId)
              .collection('rating')
              .doc(sharedPreferences?.getString('uid'))
              .set({
            'rating': countStarsRating.toString(),
            "totalRating": totalRating.toString(),
            "title": titleStarsRating,
            'comment': ratingController.text,
            'name': sharedPreferences?.getString('name'),
            "image": sharedPreferences?.getString('image'),
            "email": sharedPreferences?.getString('email'),
            'phone': sharedPreferences?.getString('phone'),
            'date': DateTime.now().toString(),
          });
        }
      });

      Get.back();
      Get.snackbar('Rating', 'Rating saved successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
      setState(() {
        countStarsRating = 0.0;
        titleStarsRating = '';
      });
    } catch (e) {
      Get.snackbar('Rating', 'Error saving rating',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  wBuildRatingCard(doc) {
    // return ListTile(
    //   title: Row(
    //     children: [
    //       doc['image'] != null
    //           ? GFAvatar(
    //         backgroundImage: NetworkImage(doc['image']),
    //       )
    //           : GFAvatar(
    //         size: 15,
    //         child: Text("${doc['name'][0]}"),
    //       ),
    //       SizedBox(width: 10.0),
    //       Text(doc['name']),
    //     ],
    //   ),
    //   subtitle: Padding(
    //     padding: const EdgeInsets.only(top: 8.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SmoothStarRating(
    //           rating: double.parse(doc['rating']),
    //           size: 20,
    //           color: Colors.amber,
    //           borderColor: Colors.amber,
    //           starCount: 5,
    //           allowHalfRating: true,
    //           spacing: 2.0,
    //         ),
    //         Text(doc['title']),
    //         Text(doc['comment']),
    //       ],
    //     ),
    //   ),
    //   // trailing: Text(DateTime.parse(doc['date']).toString()),
    // );
    return ListTile(
      title: Text("Name: ${doc['name'].toString()}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmoothStarRating(
            rating: double.parse(doc['rating'].toString()),
            size: 20,
            color: Colors.amber,
            borderColor: Colors.amber,
            starCount: 5,
            allowHalfRating: true,
            spacing: 2.0,
          ),
          Text(doc['title'].toString()),
          Text(doc['comment'].toString()),
        ],
      ),
    );
  }
}
