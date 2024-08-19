// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/models/vehicle_model.dart';

import '../../../../widgets/currency_format.dart';
import '../../../../widgets/mix_widgets.dart';
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
                            child: wText(
                              'Rs: ${widget.vModel.vehiclePrice}',
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
                  Text(
                    "Vehicle: ${widget.vModel.vehicleName!}",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  //   description
                  Text(
                    "Model: ${widget.vModel.vehicleModel!}, For: ${widget.vModel.vehicleStatus}\n"
                    "Desc: ${widget.vModel.vehicleDescription!}",
                  ),
                  //   details
                  SizedBox(
                    height: 10,
                  ),
                  aText(
                    'Vehicle Details',
                  ),
                  Table(
                    border: TableBorder.all(color: Colors.blue),
                    children: [
                      TableRow(
                        children: [
                          Text('Vehicle Type:'),
                          Text('${widget.vModel.vehicleTransmission}'),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                        ),
                        children: [
                          Text('Vehicle Body:'),
                          Text('${widget.vModel.vehicleBodyType}'),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Km:'),
                          Text('${widget.vModel.vehicleKm}'),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                        ),
                        children: [
                          Text('Vehicle Fuel:'),
                          Text('${widget.vModel.vehicleFuelType}'),
                        ],
                      ),
                      // condition
                      TableRow(
                        children: [
                          Text('Vehicle Condition:'),
                          Text('${widget.vModel.vehicleCondition}'),
                        ],
                      ),
                      // vehicleColor
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                        ),
                        children: [
                          Text('Vehicle Color:'),
                          Text('${widget.vModel.vehicleColor}'),
                        ],
                      ),
                      // status
                      TableRow(
                        children: [
                          Text('Vehicle Status:'),
                          Text('${widget.vModel.status}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Posted: ${(GetTimeAgo.parse(DateTime.parse(widget.vModel.updatedDate!.toDate().toString()).toLocal()))}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  //   showroom
                  SizedBox(height: 10.0),
                  aText('Showroom'),
                  Text(
                    'Name: ${widget.vModel.showroomName!}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  //   location
                  aText('Location'),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green[800],
                      ),
                      Text(
                        ' ${widget.vModel.city!}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  //   address
                  Text(
                    'Address: ${widget.vModel.address!}',
                    style: TextStyle(),
                  ),
                  SizedBox(height: 10.0),
                  //   contact
                  aText('Contact'),
                  GestureDetector(
                    onTap: () {
                      urlLauncher('tel:${widget.vModel.phone}');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.green[800],
                        ),
                        Text(
                          ' ${widget.vModel.phone!}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //   email
                  GestureDetector(
                    onTap: () {
                      urlLauncher('mailto:${widget.vModel.email}');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.green[800],
                        ),
                        Text(
                          ' ${widget.vModel.email!}',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //   date
                  SizedBox(
                    height: 10.0,
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
              radius: 30,
              backgroundImage:
              NetworkImage(widget.vModel.image.toString()),
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
              // send message to seller on whatsapp
              launch(
                  'https://wa.me/${widget.vModel.phone}?text=ZubiPay\n'
                      '\n'
                      'I want to buy your ${widget.vModel.vehicleName}\n'
                      'Rs: ${widget.vModel.vehiclePrice}'
                      '\nColor: ${widget.vModel.vehicleColor}\n'
                      'Description: ${widget.vModel.vehicleDescription}\n'
                      'Model: ${widget.vModel.vehicleModel}\n'
                      'Vehicle Type: ${widget.vModel.vehicleType}\n'
                      'Km: ${widget.vModel.vehicleKm}\n');
            },
            text: 'Buy Now',
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
}
