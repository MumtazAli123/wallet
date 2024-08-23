// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ": ${widget.vModel.showroomName!}",
                  style: const TextStyle(
                    color: Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Stack(
                children: [
                  // show price and cross after show discount price
                  Positioned(
                    left: 0,
                    child: Column(
                      children: [
                        Text(
                          'Vehicle Price',
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green[800],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: widget.vModel.currency == "AED"
                                ? aText(
                                    "${widget.vModel.currency}: ${widget.vModel.vehiclePrice}",
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : aText(
                                    "Rs: ${widget.vModel.vehiclePrice}",
                                    color: Colors.white,
                                    size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // vehicle name
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.directions_car,
                    color: Colors.blue[800],
                  ),
                  SizedBox(width: 10.0),
                  aText(
                    '${widget.vModel.vehicleName}',
                    size: 20,
                  ),
                  //   description
                  Text(
                      "Model: ${widget.vModel.vehicleModel!}, For: ${widget.vModel.vehicleStatus}\n"),
                  aText(
                    'Description',
                    size: 16,
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.description),
                      title: Text('${widget.vModel.vehicleDescription}'),
                    ),
                  ),
                  //   details
                  SizedBox(
                    height: 30,
                  ),
                  aText(
                    'Vehicle Details',
                  ),
                  Divider(),
                  Table(
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
                          color: Colors.blue[100],
                        ),
                        children: [
                          eText('Vehicle Body:', color: Colors.black),
                          eText('${widget.vModel.vehicleBodyType}',
                              color: Colors.black),
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
                          color: Colors.blue[100],
                        ),
                        children: [
                          eText('Vehicle Fuel:'),
                          eText('${widget.vModel.vehicleFuelType}',
                              color: Colors.black),
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
                          color: Colors.blue[100],
                        ),
                        children: [
                          eText('Vehicle Color:', color: Colors.black),
                          eText('${widget.vModel.vehicleColor}',
                              color: Colors.black),
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
                  //
                  //  showroom
                  Divider(),
                  SizedBox(height: 20.0),
                  aText(
                    "Seller Details",
                  ),

                  ListTile(
                    leading: Icon(Icons.person),
                    title: eText('Name: ${widget.vModel.sellerName}'),
                    subtitle: eText('Phone: ${widget.vModel.phone}'),
                  ),
                  //   explore insurance card
                  SizedBox(height: 20.0),
                  Divider(),
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
                          Text(
                              'Insurance Start at PKR 105,000. 3rd Party Insurance'),
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
                  //  more related vehicles
                  SizedBox(height: 20.0),
                  aText('More Related Vehicles'),
                  SizedBox(height: 10.0),
                  //   related vehicles
                  SizedBox(
                    height: 200,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('vehicle')
                            .where('vehicleType',
                                isEqualTo: widget.vModel.vehicleType)
                            .limit(15)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return _buildBox(
                                    snapshot.data!.docs[index].data());
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  //   real state
                  SizedBox(height: 20.0),
                  aText('Products'),
                  SizedBox(height: 10.0),
                  //   related vehicles
                  SizedBox(
                    height: 280,
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
                                return wBuildRealstateC(
                                    snapshot.data!.docs[index]);
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0),
            //   share on facebook, twitter, whatsapp, email as a post or message
          ],
        ),
      ),
    );
  }

  _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.5),
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
          IconButton(
            icon: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                Icon(Icons.star, color: Colors.yellow),
                Icon(Icons.star, color: Colors.yellow),
                Icon(Icons.star, color: Colors.yellow),
                Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            onPressed: () {
              // add rating
              Get.to(() => VehicleRating(
                    // Transition.zoom,
                    sellerId: widget.vModel.sellerId,
                    image: widget.vModel.sellerImage,
                    name: widget.vModel.sellerName,
                    sellerImage: widget.vModel.sellerImage,
                  ));
            },
          ),
          //   add to cart
          Spacer(),
          GFButton(
            onPressed: () {
              Get.to(() => OfferView(vehicle: widget.vModel));
            },
            text: 'Give Offer',
            textStyle: GoogleFonts.aBeeZee(fontSize: 20),
            type: GFButtonType.solid,
            color: Colors.green,
            textColor: Colors.white,
            size: 50,
            shape: GFButtonShape.standard,
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
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

  wBuildRealstateC(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return SizedBox(
      width: 200,
      height: 300,
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
                              color: Colors.grey,
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
}
