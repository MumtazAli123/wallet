// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/app/modules/products/views/products_view.dart';
import 'package:wallet/app/modules/vehicle/views/vehicle_page_view.dart';
import 'package:wallet/models/products_model.dart';
import 'package:wallet/models/vehicle_model.dart';

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
    //   counter value is 1
    controller.quantity.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // add product to cart
      //     if (widget.vModel.pQuantity == "0") {
      //       Get.snackbar('Out of Stock', 'Product is out of stock',
      //           snackPosition: SnackPosition.BOTTOM,
      //           backgroundColor: Colors.red,
      //           colorText: Colors.white);
      //     } else {
      //       controller.addToCart(widget.vModel);
      //       Get.snackbar('Added to Cart', 'Product added to cart',
      //           snackPosition: SnackPosition.BOTTOM,
      //           backgroundColor: Colors.green,
      //           colorText: Colors.white);
      //     }
      //   },
      //   child: Icon(Icons.shopping_cart),
      // ),
      bottomNavigationBar: _buildBottomBar(),
      body: _buildBody(widget.vModel),
    );
  }

  _buildBody(ProductsModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _buildVDetailsAvatar(
            model,
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
                        'Rs:${widget.vModel.pPrice}'.splitMapJoin(
                          RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                          onMatch: (m) => '${m[1]},',
                        ),
                        style: const TextStyle(
                          color: Colors.red,
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
                                  .splitMapJoin(
                                  RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                                  onMatch: (m) => '${m[1]},',
                                )
                              : 'Rs: ${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}'
                                  .splitMapJoin(
                                  RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                                  onMatch: (m) => '${m[1]},',
                                ),
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
                Divider(),
                Table(
                  textBaseline: TextBaseline.ideographic,
                  defaultVerticalAlignment:
                      TableCellVerticalAlignment.intrinsicHeight,
                  columnWidths: {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(0.5),
                  },
                  children: [
                    TableRow(children: [
                      eText('Category:'),
                      eText(model.pCategory!),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        children: [
                          eText('Condition:'),
                          eText(model.pCondition!),
                        ]),
                    TableRow(children: [
                      eText('Delivery:'),
                      widget.vModel.pDelivery == "Yes"
                          ? eText(
                              "Free Delivery",
                            )
                          : eText(
                              "Delivery: Not Available",
                            ),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        children: [
                          eText('Return:'),
                          widget.vModel.pReturn == "Yes"
                              ? eText(
                                  "Policy: 7 Days",
                                )
                              : eText(
                                  "Return: Not Available",
                                ),
                        ]),
                    TableRow(children: [
                      eText('Color:'),
                      eText(model.pColor!),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        children: [
                          eText('Size:'),
                          eText(model.pSize!),
                        ]),
                    //   pQuantity
                    TableRow(children: [
                      eText('Quantity:'),
                      eText(model.pQuantity!),
                    ]),
                    //   pBrand
                    TableRow(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        children: [
                          eText('Brand:'),
                          eText(model.pBrand!),
                        ]),
                  ],
                ),
                Divider(),
                Text(
                  'Posted: ${(GetTimeAgo.parse(DateTime.parse(widget.vModel.pCreatedAt!.toDate().toString()).toLocal()))}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 10.0),
                //   city
                wText("Location:", size: 30),
                Text(
                  'City: ${widget.vModel.city}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                //   address
                Text(
                  'Address: ${widget.vModel.address}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 10.0),
                Divider(),
                SizedBox(
                  height: 10.0,
                ),
                //   seller Details
                wText('Seller Details', size: 22),
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserDetailsView(
                          userID: widget.vModel.pSellerId,
                        ));
                  },
                  child: Row(
                    children: [
                      widget.vModel.pSellerPhoto!.isEmpty
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
                              backgroundImage: NetworkImage(
                                  widget.vModel.pSellerPhoto.toString()),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vModel.pSellerName!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Phone: ${widget.vModel.pSellerPhone}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Email: ${widget.vModel.pSellerEmail}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(),
                _buildReviews(),
                cText(
                  'More Products from ${widget.vModel.pSellerName}',
                  size: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                //   more products
                _moreProducts(),
                SizedBox(height: 20.0),
                //   related products
                cText(
                  'Vehicles ',
                  size: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('vehicle')
                        .orderBy('publishedDate', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No Vehicles Found'),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            return _buildVehicleCard(data);
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //   add to cart
          _buildCounter(),

          Spacer(),
          // GFButton(
          //   onPressed: () {
          //     // send message to seller on whatsapp
          //     launch(
          //         'https://wa.me/${widget.vModel.pSellerPhone}?text=ZubiPay\n'
          //         '\n'
          //         'I want to buy your product ${widget.vModel.pName}\n'
          //         'Rs: ${widget.vModel.pPrice}'
          //         '\nDiscount: ${widget.vModel.pDiscountType == "Percentage" ? "${widget.vModel.pDiscount!}%" : widget.vModel.pDiscount}\n'
          //         'After Discount: ${widget.vModel.pDiscountType == "Percentage" ? "${double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)}" : "${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}"}\n'
          //         '\nColor: ${widget.vModel.pColor}\n'
          //         'Description: ${widget.vModel.pDescription}\n'
          //         'Brand: ${widget.vModel.pBrand}\n'
          //         'Category: ${widget.vModel.pCategory}\n'
          //         'Size: ${widget.vModel.pSize}\n');
          //   },
          //   text: 'Buy Now',
          //   textStyle: GoogleFonts.aBeeZee(fontSize: 20),
          //   type: GFButtonType.solid,
          //   color: Colors.green,
          //   textColor: Colors.white,
          //   size: 50,
          //   shape: GFButtonShape.standard,
          //   icon: Icon(
          //     Icons.shopping_cart,
          //     color: Colors.white,
          //   ),
          // ),
          //   price show as per counting
          Container(
            height: 50,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
                onPressed: () {
                  //   if product is out of stock than show message
                  // setState(() {
                  //   if (widget.vModel.pQuantity == "0") {
                  //     Get.snackbar('Out of Stock', 'Product is out of stock',
                  //         snackPosition: SnackPosition.BOTTOM,
                  //         backgroundColor: Colors.red,
                  //         colorText: Colors.white);
                  //   } else {
                  //     controller.addToCart(widget.vModel);
                  //     Get.snackbar('Added to Cart', 'Product added to cart',
                  //         snackPosition: SnackPosition.BOTTOM,
                  //         backgroundColor: Colors.green,
                  //         colorText: Colors.white);
                  //   }
                  // });
                  launch(
                      'https://wa.me/${widget.vModel.pSellerPhone}?text=ZubiPay\n'
                      '\n'
                      'I want to buy your product ${widget.vModel.pName}\n'
                          'Price: ${widget.vModel.pPrice}'
                          '\nDiscount: ${widget.vModel.pDiscountType == "Percentage" ? "${widget.vModel.pDiscount!}%" : widget.vModel.pDiscount}\n'
                          'After Discount: ${widget.vModel.pDiscountType == "Percentage" ? "${double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)}" : "${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}"}\n'
                          '\nQuantity: ${controller.quantity.value}\n'
                      'Total: ${widget.vModel.pDiscountType == "Percentage" ? '${(double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)) * controller.quantity.value}' : '${(double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!) * controller.quantity.value)}'}\n'
                          '\n'
                      '\nColor: ${widget.vModel.pColor}\n'
                      'Description: ${widget.vModel.pDescription}\n'
                      'Brand: ${widget.vModel.pBrand}\n'
                      'Category: ${widget.vModel.pCategory}\n'
                      'Size: ${widget.vModel.pSize}\n');
                },
                child: aText(
                  // when click on counter than show price

                  // 'Buy Now: Rs: ${widget.vModel.pDiscountType == "Percentage" ? '${double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)}' : '${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}'}',
                  controller.quantity.value == 1
                      ? 'Total, Rs: ${widget.vModel.pDiscountType == "Percentage" ? '${double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)}' : '${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}'}'.splitMapJoin(
                          RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                          onMatch: (m) => '${m[1]},',
                  )
                      : 'Total, Rs: ${widget.vModel.pDiscountType == "Percentage" ? '${(double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)) * controller.quantity.value}' : '${(double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)) * controller.quantity.value}'}'.splitMapJoin(
                          RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                          onMatch: (m) => '${m[1]},',

                  ),
                  color: Colors.white,
                  size: 14
                )),
          ),
        ],
      ),
    );
  }

  void _buildBodyDialog(data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['pName']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(data['pImages'],
                    height: 200, width: 400, fit: BoxFit.cover),
                Text('Price: ${data['pPrice']}'),
                Text('Discount: ${data['pDiscount']}'),
                Text('Category: ${data['pCategory']}'),
                Text('Color: ${data['pColor']}'),
                Text('Size: ${data['pSize']}'),
                Text('Brand: ${data['pBrand']}'),
                Text('Description: ${data['pDescription']}'),
                Text(
                    'Posted: ${(GetTimeAgo.parse(DateTime.parse(data['pCreatedAt'].toDate().toString()).toLocal()))}'),
                Text('City: ${data['city']}'),
                Text('Address: ${data['address']}'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: eText('Close', color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.to(() => ProductsView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: eText('View More', color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  _buildVehicleCard(QueryDocumentSnapshot<Object?> data) {
    return GestureDetector(
      onTap: () {
        Get.to(() => VehiclePageView(
            vModel: VehicleModel.fromJson(data.data() as Map<String, dynamic>),
            doc: ''));
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(data['image'].toString()),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.s,
          children: [
            Spacer(),
            //   product name
            Text(
              data['vehicleName'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            //   product price after discount
          ],
        ),
      ),
    );
  }

  _moreProducts() {
    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: controller.getMoreProducts(widget.vModel.pSellerId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    //   show product details page
                    _buildBodyDialog(data);
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data['pImages'].toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.s,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9),
                            ),
                            child: Text(
                              data['pDiscountType'] == "Percentage"
                                  ? '${data['pDiscount']}% OFF'
                                  : 'Rs: ${data['pDiscount']} OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        //   product name
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.9),
                            ),
                            child: Text(
                                maxLines: 1,
                                "${data['pName']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
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
                    sellerId: widget.vModel.pSellerId,
                    image: widget.vModel.pImages,
                    name: widget.vModel.pSellerName,
                    sellerImage: widget.vModel.pSellerPhoto,
                  ));
            },
            child: Row(
              children: [
                Expanded(
                  child: aText('Seller Reviews', size: 14),
                ),
                SizedBox(width: 10.0),
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 10.0),
                // _getRating(widget.vModel.sellerId),
                Expanded(
                    child: isRating
                        ? Text('Rating: 0.0')
                        : _getRating(widget.vModel.pSellerId)),
                SizedBox(width: 1.0),
              ],
            ),
          ),
          // if rating is available then show rating or show add rating button
          isRating ? Container() : _buildRatingBar(widget.vModel.pSellerId),
          SizedBox(height: 10.0),
          Divider(),
        ],
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

  wBuildRatingCard(Map data) {
    return GestureDetector(
      onTap: () {
        //   show on  same page
        Get.to(() => VehicleRating(
              // Transition.zoom,
              sellerId: widget.vModel.pSellerId,
              image: widget.vModel.pImages,
              name: widget.vModel.pSellerName,
              sellerImage: widget.vModel.pSellerPhoto,
            ));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }

  _buildVDetailsAvatar(ProductsModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(children: [
            Expanded(
                child: _buildVDetails(
                    Icons.category, 'Category', model.pCategory)),
            Expanded(
                child: _buildVDetails(Icons.color_lens, 'Color', model.pColor)),
            Expanded(
                child: _buildVDetails(
                    Icons.branding_watermark, 'Brand', model.pBrand)),
          ]),
        ],
      ),
    );
  }

  _buildVDetails(IconData icon, String? title, String? value) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.green[800],
            ),
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              maxLines: 1,
              value!,
              overflow: TextOverflow.ellipsis,
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

  _buildCounter() {
    //   when click new products than remove add to cart just current products work add to cart
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                //   if quantity is 1 than not decrease and price show as per quantity
                if (controller.quantity.value > 1) {
                  controller.decrement();
                }
              });
            },
          ),
          Obx(() => Text(
                '${controller.quantity}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //   if quantity is 1 than not decrease and price show as per quantity

              setState(() {
                if (controller.quantity.value <
                    int.parse(widget.vModel.pQuantity!)) {
                  controller.increment();
                }
              });
            },
          ),
        ],
      ),
    );
  }

}
