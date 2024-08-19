// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:wallet/app/modules/profile/controllers/profile_controller.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../../../widgets/nav_appbar.dart';

class UserDetailsView extends StatefulWidget {
  final String? userID;
  const UserDetailsView({super.key, this.userID});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  final ProfileController controller = Get.put(ProfileController());

  String? name;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? image;
  String? rating;
  String? status;


  bool isEmpty = false;

  // slider images
  String? image1 =
      "https://firebasestorage.googleapis.com/v0/b/myapp-97691.appspot.com/o/Place%20Holder%2F%20burger.png?alt=media&token=f064d385-ea57-443b-8e73-14b3b5a7d617";
  String? image2 =
      "https://firebasestorage.googleapis.com/v0/b/myapp-97691.appspot.com/o/Place%20Holder%2Fpay.png?alt=media&token=1c7c62be-3958-47da-bb49-14e9a7f8d91c";
  String? image3 =
      "https://firebasestorage.googleapis.com/v0/b/myapp-97691.appspot.com/o/Place%20Holder%2Fsalewith.png?alt=media&token=79a7016a-3776-43e2-92d8-cdaaf9e2fc02";
  String? image4 =
      "https://firebasestorage.googleapis.com/v0/b/myapp-97691.appspot.com/o/Place%20Holder%2Fshopping.png?alt=media&token=e1548a3e-9bd0-433d-b40e-9feab911e1ed";
  String? image5 =
      "https://firebasestorage.googleapis.com/v0/b/myapp-97691.appspot.com/o/Place%20Holder%2F%20burger.png?alt=media&token=f064d385-ea57-443b-8e73-14b3b5a7d617";

  retrieveUserInfo() async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.userID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data()!["image1"] != null) {
          setState(() {
            image = snapshot.data()!['image'];
            image1 = snapshot.data()!['image1'];
            image2 = snapshot.data()!['image2'];
            image3 = snapshot.data()!['image3'];
            image4 = snapshot.data()!['image4'];
          });
        }
        setState(() {
          name = snapshot.data()!['name'];
          email = snapshot.data()!['email'];
          phone = snapshot.data()!['phone'];
          address = snapshot.data()!['address'];
          city = snapshot.data()!['city'];
          rating = snapshot.data()!['rating'];
          status = snapshot.data()!['status'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavAppBar(title: 'User Details'),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // user image
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: CarouselView(
                  scrollDirection: Axis.horizontal,
                  shrinkExtent: 0.5,
                  itemExtent: MediaQuery.of(context).size.height * 0.4,
                  children: [
                    Image.network(image1.toString(), fit: BoxFit.cover),
                    Image.network(image2.toString(), fit: BoxFit.cover),
                    Image.network(image3.toString(), fit: BoxFit.cover),
                    Image.network(image4.toString(), fit: BoxFit.cover),
                    Image.network(image5.toString(), fit: BoxFit.cover),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              wText('User Info:', size: 20),
              Text(''),
              // Table of user info
              Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Name:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("$name"),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Email:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("$email"),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Phone:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("$phone"),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Address:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("$address"),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('City:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("$city"),
                      ),
                    ),
                  ]),
                //   user rating
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Rating:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("$rating"),
                      ),
                    ),
                  ]),
                ],
              ),
              //   user rating
              SizedBox(height: 20.0),
              // rating comment
              Text(
                "Great Seller",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            //   status
              Text(
                // if status is active text show excellent else show poor
                status == "active" ? "Poor" : "Excellent",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),

              //   rating
              SmoothStarRating(
                rating: double.parse("4.5"),
                size: 20,
                color: Colors.amber,
                borderColor: Colors.amber,
                starCount: 5,
                allowHalfRating: false,
                spacing: 2.0,
              ),
              //   rating count
              Text(
                "Rating: ${rating.toString()}",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 20.0),
            ]),
      ),
    );
  }
  
}
