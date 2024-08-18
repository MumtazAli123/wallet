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

class ProductView extends GetView<ProductsController> {
  final String? data;
  final ProductsModel vModel;

  const ProductView({super.key, required this.data, required this.vModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('${vModel.pName}'),
      //   centerTitle: true,
      // ),
      body: _buildBody(vModel),
    );
  }

  _buildBody(ProductsModel model) {
    return PageView.builder(
        itemCount: 2,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(vModel.pImages.toString()),
                  fit: BoxFit.fill,
                ),
                color: Colors.blue),
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
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vModel.pName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${vModel.pDescription}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Brand: ${vModel.pBrand}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Quantity: ${vModel.pQuantity}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Discount: ${vModel.pDiscount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Color: ${vModel.pColor}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Size: ${vModel.pSize}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Address: ${vModel.address}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'City: ${vModel.city}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // show price and cross after show discount price

                            Positioned(
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    '\Rs:${vModel.pPrice}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 50,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: wText(
                                        vModel.pPrice == "Percentage"
                                            ? '\Rs: ${double.parse(vModel.pPrice!) - (double.parse(vModel.pPrice!) * double.parse(vModel.pDiscount!) / 100)}'
                                            : '\Rs: ${double.parse(vModel.pPrice!) - double.parse(vModel.pDiscount!)}',
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
                    ],
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // seller Image and name
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(vModel.pSellerPhoto.toString()),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${vModel.pSellerName}',
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
                          text: 'Add to Cart',
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
                ),
              ],
            ),
          );
        });
  }
}
