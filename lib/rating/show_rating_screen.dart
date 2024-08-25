import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:wallet/rating/rating_screen.dart';

import '../../../../widgets/mix_widgets.dart';
import '../models/realstate_model.dart';

class ShowRatingScreen extends StatefulWidget {
  final String? realStateId;
  final String? sellerId;
  final RealStateModel model;
  const ShowRatingScreen(
      {super.key, this.realStateId, this.sellerId, required this.model});

  @override
  State<ShowRatingScreen> createState() => _ShowRatingScreenState();
}

class _ShowRatingScreenState extends State<ShowRatingScreen> {
  bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.to(() => RatingScreen(
              sellerId: widget.sellerId, model: widget.model));
        },
        label: wText('Add Rating', color: Colors.white),
        icon: const Icon(
          Icons.star,
          color: Colors.white,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),

            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: GestureDetector(
                onTap: () {
                  // page defaultTransition, Transition.leftToRight,
                  Get.to(
                    transition: Transition.cupertinoDialog,

                          () => RatingScreen(

                      // Transition.zoom,
                      sellerId: widget.sellerId, model: widget.model

                      ));
                  // Get.to(() => RatingScreen(
                  //     // Transition.zoom,
                  //     sellerId: widget.sellerId, model: widget.model
                  //
                  //     ))
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      wText('Add Rating'.tr, color: Colors.white),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),
                      const Icon(Icons.star, color: Colors.amber),


                    ],
                  ),
                ),
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: wText('Seller : ${widget.model.sellerName}'.tr, color: Colors.white),
            ),

            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(widget.model.image!, fit: BoxFit.cover),
            ),
          ),
        ];
      },
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('sellers')
              .doc(widget.sellerId)
              .collection('rating')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Not available Rating yet'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index].data() as Map;
                  return wBuildRatingCard(data);
                },
              );
            }
          },
        ),
      ),
    );
  }

  wBuildRatingCard(doc) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: GFAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          // if sellerImage is  null then show first letter of name
          child:  Text(
            doc['name'].toString().substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          )

        ),
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
            aText(doc['title'].toString(), size: 14),
            Text(doc['comment'].toString()),
            const SizedBox(height: 10),
            Text(GetTimeAgo.parse(DateTime.parse(doc['date'].toString()))),
          ],
        ),
      ),
    );
  }
}

