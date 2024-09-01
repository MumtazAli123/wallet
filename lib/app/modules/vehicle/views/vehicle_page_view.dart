// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/app/modules/vehicle/views/offer_view.dart';
import 'package:wallet/app/modules/vehicle/views/vehicle_view.dart';
import 'package:wallet/models/vehicle_model.dart';

import '../../../../models/products_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../products/views/products_page_view.dart';
import '../../profile/views/user_details_view.dart';
import '../../shops/views/vehicle_rating.dart';

class VehiclePageView extends StatefulWidget {
  final String doc;
  final VehicleModel vModel;
  const VehiclePageView({super.key, required this.doc, required this.vModel});

  @override
  State<VehiclePageView> createState() => _VehiclePageViewState();
}

class _VehiclePageViewState extends State<VehiclePageView> {
  final controller = Get.put(VehicleController());

  void urlLauncher(String url, {bool? forceSafariVC}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // List<String> imageUrls = [];

  readCurrentVehicleData() async {
    await FirebaseFirestore.instance
        .collection('vehicle')
        .doc(widget.doc)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          controller.imageUrlPath = snapshot.data()!['image'];
        });
      }
    });
  }

  bool isRating = false;

  @override
  void initState() {
    super.initState();
    // readCurrentVehicleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.green[800],
        // whatsapp
        onPressed: () {
          urlLauncher(
              'https://wa.me/${widget.vModel.phone}'
              '?text=ZubiPay\nHello, I am interested in your\nvehicle Name: ${widget.vModel.vehicleName},'
              '\nType: ${widget.vModel.vehicleTransmission},'
              '\nModel: ${widget.vModel.vehicleModel}'
              '- ${widget.vModel.vehicleType}'
              '\nDescription: ${widget.vModel.vehicleDescription}\n'
              'Price: ${widget.vModel.vehiclePrice}'
              '\nColor: ${widget.vModel.vehicleColor}',
              forceSafariVC: false);
        },
        child: Image.asset('assets/images/whatsapp.png'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            leading: Container(
              margin: const EdgeInsets.only(bottom: 14, top: 1),
              decoration: BoxDecoration(
                color: Colors.green[800],
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                height: 40,
                width: 200,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: widget.vModel.currency == "AED"
                      ? aText(
                          "${widget.vModel.currency}: ${widget.vModel.vehiclePrice}".splitMapJoin(
                            RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                            onMatch: (m) => '${m[1]},',
                          ),
                          color: Colors.white,
                          size: 18,
                        )
                      : aText(
                          "Rs: ${widget.vModel.vehiclePrice}".splitMapJoin(
                            RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                            onMatch: (m) => '${m[1]},',
                          ),
                          color: Colors.white,
                          size: 18,
                        ),
                ),
              ),
              background: Image.network(
                widget.vModel.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: _buildBodyPage()
    );
  }

   _buildBodyPage() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVDetailsAvatar(widget.vModel.vehicleFuelType, widget.vModel.vehicleKm, widget.vModel.vehicleModel, widget.vModel.vehicleTransmission),
          //   vehicle price
          _buildVehicleDetails(),
          //  reviews
          _buildReviews(),

          Card(
            elevation: 5,
            child: ListTile(
              onTap: () {
                urlLauncher('https://paysaw.com/');
              },
              title: Text('Explore car Insurance'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Insurance Start at PKR 105,000. 3rd Party Insurance'),
                  Text(
                    "View plan details",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              trailing: SizedBox(
                height: 60,
                width: 60,
                child: Lottie.asset('assets/lottie/rstate.json'),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          // Explore Tacker GPS
          Card(
            elevation: 5,
            child: ListTile(
              onTap: () {
                urlLauncher('https://paysaw.com/');
              },
              title: Text('Explore Tacker GPS'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tacker GPS Start at PKR 3,000.'),
                  Text(
                    "View plan details",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              trailing: SizedBox(
                height: 60,
                width: 60,
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          // more related vehicles
          SizedBox(height: 20.0),
          rText('More Related Vehicles', size: 20),
          _buildRelatedVehicles(),
          SizedBox(height: 10.0),
          // related products
          rText('Products', size: 20),
          SizedBox(height: 10.0),
          _buildProducts(),

          //       SizedBox(
          //         height: 200,
          //         child: StreamBuilder<QuerySnapshot>(
          //             stream: FirebaseFirestore.instance
          //                 .collection('vehicle')
          //                 .where('vehicleType',
          //                 isEqualTo: widget.vModel.vehicleType)
          //                 .limit(15)
          //                 .snapshots(),
          //             builder: (context, snapshot) {
          //               if (snapshot.hasData) {
          //                 return ListView.builder(
          //                   scrollDirection: Axis.horizontal,
          //                   itemCount: snapshot.data!.docs.length,
          //                   itemBuilder: (context, index) {
          //                     return _buildBox(
          //                         snapshot.data!.docs[index].data());
          //                   },
          //                 );
          //               } else {
          //                 return Center(
          //                   child: CircularProgressIndicator(),
          //                 );
          //               }
          //             }),
          //       ),
          //       //   real state
          //       SizedBox(height: 20.0),
          //       aText('Products'),
          //       SizedBox(height: 10.0),
          //       //   related vehicles
          //       SizedBox(
          //         height: 280,
          //         child: StreamBuilder(
          //             stream: FirebaseFirestore.instance
          //                 .collection("products")
          //                 .orderBy("pCreatedAt", descending: true)
          //                 .snapshots(),
          //             builder: (context, snapshot) {
          //               if (snapshot.hasData) {
          //                 return ListView.builder(
          //                   scrollDirection: Axis.horizontal,
          //                   itemCount: snapshot.data!.docs.length,
          //                   itemBuilder: (context, index) {
          //                     return wBuildProductsC(
          //                         snapshot.data!.docs[index]);
          //                   },
          //                 );
          //               } else {
          //                 return Center(
          //                   child: CircularProgressIndicator(),
          //                 );
          //               }
          //             }),
          //       ),
          //     ],
          //   ),
          // ),

          SizedBox(height: 20.0),
          //   share on facebook, twitter, whatsapp, email as a post or message
        ],
      ),
    );
  }

  _buildVehicleDetails() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 10.0),
          //   vehicle name
          aText(
            '${widget.vModel.vehicleName}',
            size: 24,
          ),
          //   description
          Text(
              "For: ${widget.vModel.vehicleStatus}\n"),
          Divider(),
          aText(
            'Description',
            size: 16,
          ),
          Text('${widget.vModel.vehicleDescription}'),
          SizedBox(height: 10.0),
          Divider(),
          //   details
          SizedBox(
            height: 30,
          ),
          aText(
            'Vehicle Details',
          ),
          Divider(),
          _tableData(
            'Vehicle Type',
            '${widget.vModel.vehicleType}',
          ),
          Divider(),
          Text(
            'Posted: ${(GetTimeAgo.parse(DateTime.parse(widget.vModel.updatedDate!.toDate().toString()).toLocal()))}',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 10.0),
          // location
          aText(
            'Location',
            size: 20,
          ),
          Text(
            'City: ${widget.vModel.city}',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${widget.vModel.address}',
          ),
          SizedBox(height: 10.0),
          Divider(),
          SizedBox(height: 10.0),
          aText('Offers'),
          SizedBox(height: 5.0),
          isRating ? Container() : _buildOffers(widget.vModel.vehicleId),
          //   explore car insurance
          SizedBox(height: 20.0),
          Divider(),
          SizedBox(height: 20.0),
          aText(
            "Seller Details",
          ),
          Text('Name: ${widget.vModel.sellerName}\n'
              'Phone: ${widget.vModel.phone}'),
          SizedBox(height: 20.0),
          Divider(),
          SizedBox(height: 20.0),
          // seller rating
        ],
      ),
    );
  }

  _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 5),
      decoration: BoxDecoration(
          // color: Colors.blue[800],
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // seller Image and name
          GestureDetector(
            onTap: () {
              Get.to(() => UserDetailsView(
                    userID: widget.vModel.sellerId,
                  ));
            },
            child: widget.vModel.sellerImage!.isEmpty
                ? CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  )
                : CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(widget.vModel.sellerImage.toString()),
                  ),
          ),
          SizedBox(
            width: 5,
          ),
          //   add to cart
          Expanded(
            child: Text(
              maxLines: 1,
              '${widget.vModel.sellerName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(onPressed: (){
            Get.to(() => OfferView(vehicle: widget.vModel));

          },style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green[600]),
          ),
              child: aText('Give Offer',color: Colors.white)),
        ],
      ),
    );
  }

  _buildBox(data) {
    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: () {
          //   show on  same page
          Get.to(() => VehicleView());
        },
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                data['image'],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(
                data['vehicleName'],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rs: ${data['vehiclePrice']}',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  wBuildProductsC(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return SizedBox(
      width: 200,
      height: 340,
      child: GestureDetector(
        onTap: () {
          //   show on  same page
          Get.to(() => ProductPageView(
              vModel: ProductsModel.fromJson(doc.data()), data: "products"));
        },
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                doc['pImages'],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                color: Colors.red,
                child: doc['pDiscountType'] == "Percentage"
                    ? Text(
                        '${doc['pDiscount']}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : aText(
                        'Rs: ${doc['pDiscount']} OFF',
                        color: Colors.white,
                        size: 12,
                      ),
              ),
              Text(
                maxLines: 1,
                "${doc['pName']} ",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              eText("${doc['pCondition']}"),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Stack(
                  children: [
                    // show price and cross after show discount price
                    Positioned(
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            'Rs:${doc['pPrice']}',
                            style: const TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              doc['pDiscountType'] == "Percentage"
                                  ? 'Rs:${double.parse(doc['pPrice']) - (double.parse(doc['pPrice']) * double.parse(doc['pDiscount']) / 100)}'
                                  : 'Rs:${double.parse(doc['pPrice']) - double.parse(doc['pDiscount'])}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRatingBar(String? sellerId) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        SizedBox(
          height: 290,
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
                  child: Text('Not available reviews yet'),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
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
      ],
    );
  }

  wBuildRatingCard(Map data) {
    return GestureDetector(
      onTap: () {
        //   show on  same page
        Get.to(() => VehicleRating(
              // Transition.zoom,
              sellerId: widget.vModel.sellerId,
              image: widget.vModel.sellerImage,
              name: widget.vModel.sellerName,
              sellerImage: widget.vModel.sellerImage,
            ));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4.0),
              child: Row(
                children: [
                  data['image'].toString().isNotEmpty
                      ? GFAvatar(
                          backgroundImage: NetworkImage(data['image']),
                        )
                      : GFAvatar(
                          size: 15,
                          child: Text("${data['name'][0]}"),
                        ),
                  SizedBox(width: 10.0),
                  Text(data['name']),
                ],
              ),
            ),
            rText(data['title'].toString()),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 270,
                  child: Text("${data['comment']}".toString())),
            )),
            Row(
              children: [
                SmoothStarRating(
                  rating: double.parse(data['rating'].toString()),
                  size: 20,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                ),
                Text(
                  ' ${data['rating']}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              (GetTimeAgo.parse(DateTime.parse(data['date']).toLocal())),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRating(String? sellerId) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(sellerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          } else if (snapshot.data!.data() != null) {
            return Text('/ ${snapshot.data!.data()!['rating']}'
                .toString()
                .substring(0, 3));
          } else {
            return Text('Rating: 0');
          }
        });
  }

  _buildOffers(String? vehicleId) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
            .doc(widget.vModel.sellerId)
            .collection('vehicle')
            .doc(vehicleId)
            .collection('offers')
            .orderBy('date', descending: true)
            // .where('vehicleId', isEqualTo: vehicleId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading...'),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No offers yet'),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map;
                return _buildOfferCard(data);
              },
            );
          }
        },
      ),
    );
  }

  _buildOfferCard(data) {
    return GestureDetector(
      onTap: () {
        //   show on  same page
        Get.to(() => OfferView(vehicle: widget.vModel));
      },
      child: SizedBox(
        width: 200,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data['buyerPhoto'].toString().isEmpty
                  ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    )
                  : SizedBox(
                      height: 90,
                      width: double.infinity,
                      child: Image.network(
                        data['buyerPhoto'],
                        fit: BoxFit.cover,
                      ),
                    ),
              rText(
                data['buyerName'],
                size: 18,
              ),
              rText(
                "Offers: ${data['buyerOffer']}".splitMapJoin(
                  RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                  onMatch: (m) => '${m[1]},',
                ),
                color: Colors.green[800],
              ),
              rText(
                (GetTimeAgo.parse(DateTime.parse(data['date']).toLocal())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _tableData(String s, String t) {
    return Table(
      // border: TableBorder.all(color: Colors.blue),
      children: [
        TableRow(
          children: [
            eText('Vehicle Type:'),
            eText('${widget.vModel.vehicleTransmission}'),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
            color: Get.theme.primaryColor.withOpacity(0.1),
          ),
          children: [
            eText('Vehicle Body:'),
            eText('${widget.vModel.vehicleBodyType}'),
          ],
        ),
        TableRow(
          children: [
            eText('Km:'),
            eText('${widget.vModel.vehicleKm}'),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
            color: Get.theme.primaryColor.withOpacity(0.1),
          ),
          children: [
            eText('Vehicle Fuel:'),
            eText(
              '${widget.vModel.vehicleFuelType}',
            ),
          ],
        ),
        // condition
        TableRow(
          children: [
            eText('Vehicle Condition:'),
            eText('${widget.vModel.vehicleCondition}'),
          ],
        ),
        // vehicleColor
        TableRow(
          decoration: BoxDecoration(
            color: Get.theme.primaryColor.withOpacity(0.1),
          ),
          children: [
            eText('Vehicle Color:'),
            eText(
              '${widget.vModel.vehicleColor}',
            ),
          ],
        ),
        // status
        TableRow(
          children: [
            eText('Vehicle Status:'),
            eText('${widget.vModel.status}'),
          ],
        ),
      ],
    );
  }

  _buildReviews() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => VehicleRating(
                    // Transition.zoom,
                    sellerId: widget.vModel.sellerId,
                    image: widget.vModel.sellerImage,
                    name: widget.vModel.sellerName,
                    sellerImage: widget.vModel.sellerImage,
                  ));
            },
            child: Row(
              children: [
                aText('Seller Reviews'),
                SizedBox(width: 10.0),
                SmoothStarRating(
                  onRatingChanged: (v) {
                    // add rating
                    Get.to(() => VehicleRating(
                          // Transition.zoom,
                          sellerId: widget.vModel.sellerId,
                          image: widget.vModel.sellerImage,
                          name: widget.vModel.sellerName,
                          sellerImage: widget.vModel.sellerImage,
                        ));
                  },
                  rating: 3.2,
                  size: 20,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                ),
                SizedBox(width: 10.0),
                // _getRating(widget.vModel.sellerId),
                isRating
                    ? Text('Rating: 0.0')
                    : _getRating(widget.vModel.sellerId),
                SizedBox(width: 1.0),
                Text(', Star')
              ],
            ),
          ),
          // if rating is available then show rating or show add rating button
          isRating ? Container() : _buildRatingBar(widget.vModel.sellerId),
          SizedBox(height: 10.0),
          Divider(),
        ],
      ),
    );
  }

  _buildRelatedVehicles() {
    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vehicle')
              .where('vehicleType', isEqualTo: widget.vModel.vehicleType)
              .limit(15)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return _buildBox(snapshot.data!.docs[index].data());
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
    //   real state
    // SizedBox(height: 20.0),
    // aText('Products'),
    // SizedBox(height: 10.0),
    //   related vehicles
    // SizedBox(
    //   height: 280,
    //   child: StreamBuilder(
    //       stream: FirebaseFirestore.instance
    //           .collection("products")
    //           .orderBy("pCreatedAt", descending: true)
    //           .snapshots(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return ListView.builder(
    //             scrollDirection: Axis.horizontal,
    //             itemCount: snapshot.data!.docs.length,
    //             itemBuilder: (context, index) {
    //               return wBuildProductsC(
    //                   snapshot.data!.docs[index]);
    //             },
    //           );
    //         } else {
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //       }),
  }

  _buildProducts() {
    return SizedBox(
      height: 260,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("products")
              .orderBy("pCreatedAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return wBuildProductsC(snapshot.data!.docs[index]);
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }


  _buildVDetailsAvatar(String? vehicleStatus, String? vehicleKm, String? vehicleModel, String? vehicleType) {
    return SizedBox(
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         Expanded(child:  _buildVDetails('Model', vehicleModel, Icons.directions_car)),
          Expanded(child: _buildVDetails('Fuel:', vehicleStatus, Icons.local_gas_station)),
          Expanded(child: _buildVDetails('Type', vehicleType, Icons.directions_car)),
          Expanded(child: _buildVDetails('Km', vehicleKm?.splitMapJoin(
            RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
            onMatch: (m) => '${m[1]},',
          ), (Icons.memory)),
          ),
        ],
      ),
    );
  }

  _buildVDetails(String type, String? vehicleModel, IconData directionsCar) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              directionsCar,
              size: 30,
              color: Colors.green[800],
            ),
            Text(
              type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              maxLines: 1,
              vehicleModel!,

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
