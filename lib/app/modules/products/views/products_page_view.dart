// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/models/products_model.dart';

import '../../../../widgets/mix_widgets.dart';

class ProductView extends StatefulWidget {
  final String? data;
  final ProductsModel vModel;

  const ProductView({super.key, required this.data, required this.vModel});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // seller Image and name
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.vModel.pSellerPhoto.toString()),
            ),
            SizedBox(
              width: 10,
            ),
            // maximum seller name length is 7
            widget.vModel.pSellerName!.length > 7
                ? Text(
                    '${widget.vModel.pSellerName!.substring(0, 7)}...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                : Text(
                    '${widget.vModel.pSellerName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
            IconButton(
              icon: Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                ],
              ),
              onPressed: () {},
            ),
            //   add to cart
            Spacer(),
            GFButton(
              onPressed: () {},
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
      ),
      // appBar: AppBar(
      //   title: Text('${vModel.pName}'),
      //   centerTitle: true,
      // ),
      body: _buildBody(widget.vModel),
    );
  }

  _buildBody(ProductsModel model) {
    // return PageView.builder(
    //     scrollDirection: Axis.vertical,
    //     itemBuilder: (context, index) {
    //       return DecoratedBox(
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: NetworkImage(widget.vModel.pImages.toString()),
    //               fit: BoxFit.fill,
    //             ),
    //             color: Colors.blue),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(
    //               height: 50,
    //             ),
    //             Align(
    //               alignment: Alignment.topLeft,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   color: Colors.black.withOpacity(0.7),
    //                   borderRadius: BorderRadius.only(
    //                     topRight: Radius.circular(20),
    //                     bottomRight: Radius.circular(20),
    //                   ),
    //                 ),
    //                 child: IconButton(
    //                   icon: Icon(Icons.arrow_back, color: Colors.white),
    //                   onPressed: () {
    //                     Get.back();
    //                   },
    //                 ),
    //               ),
    //             ),
    //             Spacer(),
    //             Align(
    //               alignment: Alignment.bottomLeft,
    //               child: Column(
    //                 children: [
    //                   Text(
    //                     '${widget.vModel.pName}',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 30,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Text(
    //                     '${widget.vModel.pDescription}',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 20,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Text(
    //                     'Brand: ${widget.vModel.pBrand}',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 20,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Container(
    //                     padding: EdgeInsets.all(20),
    //                     decoration: BoxDecoration(
    //                       color: Colors.black.withOpacity(0.5),
    //                     ),
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         // seller Image and name
    //                         CircleAvatar(
    //                           backgroundImage:
    //                               NetworkImage(widget.vModel.pSellerPhoto.toString()),
    //                         ),
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         // maximum seller name length is 7
    //                         widget.vModel.pSellerName!.length > 7
    //                             ? Text(
    //                                 '${widget.vModel.pSellerName!.substring(0, 7)}...',
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 20,
    //                                 ),
    //                               )
    //                             : Text(
    //                                 '${widget.vModel.pSellerName}',
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 20,
    //                                 ),
    //                               ),
    //                         IconButton(
    //                           icon: Row(
    //                             children: [
    //                               Icon(Icons.star, color: Colors.yellow),
    //                               Icon(Icons.star, color: Colors.yellow),
    //                               Icon(Icons.star, color: Colors.yellow),
    //                             ],
    //                           ),
    //                           onPressed: () {},
    //                         ),
    //                         //   add to cart
    //                         Spacer(),
    //                         GFButton(
    //                           onPressed: () {},
    //                           text: 'Buy Now',
    //                           textStyle: GoogleFonts.aBeeZee(fontSize: 20),
    //                           type: GFButtonType.solid,
    //                           color: Colors.green,
    //                           textColor: Colors.white,
    //                           size: 50,
    //                           shape: GFButtonShape.standard,
    //                           icon: Icon(
    //                             Icons.shopping_cart,
    //                             color: Colors.white,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     });
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 490,
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
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 1,
                          '${widget.vModel.pName}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.red,
                          child: widget.vModel.pDiscount == "Percentage"
                              ? Text(
                                  '${widget.vModel.pDiscount} OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : wText('Rs: ${widget.vModel.pDiscount} OFF',
                                  color: Colors.white, size: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Table(
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
                    //   pDescription
                    TableRow(children: [
                      Text('Description:'),
                      Text(
                        maxLines: 2,
                        "${model.pDescription}",
                      ),
                    ]),
                  ],
                ),
              ],
            ),
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
                        '\Rs:${widget.vModel.pPrice}',
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: wText(
                          widget.vModel.pDiscountType == "Percentage"
                              ? '\Rs: ${double.parse(widget.vModel.pPrice!) - (double.parse(widget.vModel.pPrice!) * double.parse(widget.vModel.pDiscount!) / 100)}'
                              : '\Rs: ${double.parse(widget.vModel.pPrice!) - double.parse(widget.vModel.pDiscount!)}',
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
        ],
      ),
    );
  }
}
