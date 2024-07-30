import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../../../rating/rating_screen.dart';
import '../../../../widgets/mix_widgets.dart';

class VehicleRating extends StatelessWidget {
  final String? sellerId;
  final String? image;
  // final VehicleModel? model;
  const VehicleRating({super.key, this.sellerId, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: GestureDetector(
                onTap: () {
                  // page defaultTransition, Transition.leftToRight,
                  Get.to(
                      transition: Transition.cupertinoDialog,
                      () => RatingScreen(

                          // Transition.zoom,
                          sellerId: sellerId));
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
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: wText('Rating'.tr, color: Colors.white),
            ),
            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                image.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('sellers')
              .doc(sellerId)
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: GFAvatar(
          // image is not null then show first letter of name
          backgroundImage: doc['image'] != null
              ? NetworkImage(doc['image'].toString())
              : null,
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
            Text(doc['title'].toString()),
            Text("Comment: ${doc['comment'].toString()}"),
          ],
        ),
      ),
    );
  }
}
