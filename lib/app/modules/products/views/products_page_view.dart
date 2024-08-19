// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/models/products_model.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../profile/views/user_details_view.dart';
import '../../shops/views/vehicle_rating.dart';

class ProductPageView extends StatefulWidget {
  final String? data;
  final ProductsModel vModel;

  const ProductPageView({super.key, required this.data, required this.vModel});

  @override
  State<ProductPageView> createState() => _ProductPageViewState();
}

class _ProductPageViewState extends State<ProductPageView> {
  final ProductsController controller = Get.put(ProductsController());
  String? senderName;

  readCurrentUserData() async {
    // ignore: await_only_futures
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.vModel.pSellerId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          senderName = snapshot.data()!['name'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
      body: _buildBody(widget.vModel),
    );
  }

  _buildBody(ProductsModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.vModel.pImages.toString(), scale: 1),
                fit: BoxFit.fill,
              ),
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
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
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: widget.vModel.pDiscountType == "Percentage"
                            ? Text(
                                '${widget.vModel.pDiscount}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : wText('Rs: ${widget.vModel.pDiscount} OFF',
                                color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
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
                        'Rs:${widget.vModel.pPrice}',
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
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
                        child: wText(
                          widget.vModel.pDiscountType == "Percentage"
                              ? 'Rs: ${double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)}'
                              : 'Rs: ${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}',
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product name
                wText(
                  widget.vModel.pName!,
                  color: Colors.black,
                  size: 20,
                ),
                // product description
                Text(
                  "Desc: ${widget.vModel.pDescription!}",
                ),
                SizedBox(
                  height: 10,
                ),
                aText(
                  'Product Details',
                ),
                Table(
                  textBaseline: TextBaseline.ideographic,
                  defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
                  border: TableBorder.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  columnWidths: {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(0.5),
                  },
                  children: [
                    TableRow(children: [
                      Text('Category:'),
                      Text(model.pCategory!),
                    ]),
                    TableRow(children: [
                      Text('Condition:'),
                      Text(model.pCondition!),
                    ]),
                    TableRow(children: [
                      Text('Delivery:'),
                      widget.vModel.pDelivery == "Yes"
                          ? Text(
                              "Free Delivery",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            )
                          : Text(
                              "Delivery: Not Available",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                    ]),
                    TableRow(children: [
                      Text('Return:'),
                      widget.vModel.pReturn == "Yes"
                          ? Text(
                              "Policy: 7 Days",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            )
                          : Text(
                              "Return: Not Available",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                    ]),
                    TableRow(children: [
                      Text('Color:'),
                      Text(model.pColor!),
                    ]),
                    TableRow(children: [
                      Text('Size:'),
                      Text(model.pSize!),
                    ]),
                    //   pQuantity
                    TableRow(children: [
                      Text('Quantity:'),
                      Text(model.pQuantity!),
                    ]),
                    //   pBrand
                    TableRow(children: [
                      Text('Brand:'),
                      Text(model.pBrand!),
                    ]),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'Posted: ${(GetTimeAgo.parse(DateTime.parse(widget.vModel.pCreatedAt!.toDate().toString()).toLocal()))}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
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
                    userID: widget.vModel.pSellerId,
                  ));
            },
            child: widget.vModel.pSellerPhoto!.isEmpty
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
                        NetworkImage(widget.vModel.pSellerPhoto.toString()),
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
                    sellerId: widget.vModel.pSellerId,
                    image: widget.vModel.pImages,
                    name: widget.vModel.pSellerName,
                    sellerImage: widget.vModel.pSellerPhoto,
                  ));
            },
          ),
          //   add to cart
          Spacer(),
          GFButton(
            onPressed: () {
              // send message to seller on whatsapp
              launch(
                  'https://wa.me/${widget.vModel.pSellerPhone}?text=ZubiPay\n'
                  '\n'
                  'I want to buy your product ${widget.vModel.pName}\n'
                  'Rs: ${widget.vModel.pPrice}'
                  '\nDiscount: ${widget.vModel.pDiscountType == "Percentage" ? "${widget.vModel.pDiscount!}%" : widget.vModel.pDiscount}\n'
                  'After Discount: ${widget.vModel.pDiscountType == "Percentage" ? "${double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)}" : "${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}"}\n'
                  '\nColor: ${widget.vModel.pColor}\n'
                  'Description: ${widget.vModel.pDescription}\n'
                  'Brand: ${widget.vModel.pBrand}\n'
                  'Category: ${widget.vModel.pCategory}\n'
                  'Size: ${widget.vModel.pSize}\n');
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
