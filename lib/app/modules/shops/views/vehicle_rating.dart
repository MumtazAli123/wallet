import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../../../rating/rating_screen.dart';
import '../../../../widgets/mix_widgets.dart';

class VehicleRating extends StatelessWidget {
  final String? sellerId;
  final String? image;
  final String? name;
  final String? sellerImage;
  // final VehicleModel? model;
  const VehicleRating({super.key, this.sellerId, this.image, this.name, this.sellerImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.to(() => RatingScreen(
              sellerId: sellerId));
        },
        label: wText('Add Rating'.tr, color: Colors.white),
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
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Get.back();
                },
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
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  sellerImage!.isEmpty
                      ? Text(
                    name.toString().substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                      : GFAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(sellerImage.toString()),
                  ),
                  const SizedBox(width: 10),
                  wText(name.toString(), color: Colors.white),
                ],
              ),
            ),
            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: sellerImage!.isEmpty

                  ? Image.network(sellerImage!, fit: BoxFit.cover)
                  :Image.network(image!, fit: BoxFit.cover)
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
    return Card(
      elevation: 5,
      child: ListTile(
        leading: doc['image'].toString().isEmpty
            ? const CircleAvatar(
          radius: 30,
          child: Icon(Icons.person),
        )
            : CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(doc['image'].toString()),
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
            aText(doc['title'].toString()),
            Text(doc['comment'].toString()),
          ],
        ),
      ),
    );
  }
}
