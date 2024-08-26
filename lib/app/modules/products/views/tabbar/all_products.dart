// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/models/products_model.dart';

import '../../../../../widgets/mix_widgets.dart';
import '../products_page_view.dart';

class AllProducts extends GetView<ProductsController> {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.allProductsStream(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Products Found'),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return wBuildProductCard(data);
            },
          );
        } catch (e) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}

Widget wBuildProductCard(Map<String, dynamic> data) {
  return GestureDetector(
    onTap: () {
      wDialogMoreDetails(Get.context!, data);

      // Get.to(() => VehiclePageView(
      //     vModel: VehicleModel.fromJson(doc), doc: doc.toString()
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 2.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.network(
                    data['pImages'],
                    fit: BoxFit.fill,
                    height: 350,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        // setState(() {
                        //   _isAdded = !_isAdded;
                        // });
                      },
                      icon: Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  //   discount  show advance design
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red,
                      child: data['pDiscountType'] == "Percentage"
                          ? Text(
                        '${data['pDiscount']}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : wText('Rs: ${data['pDiscount']} OFF'.splitMapJoin(
                        RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                        onMatch: (m) => "${m[1]},",
                      ),
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['pName'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Brand: ${data['pBrand']}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                    // description show
                  Text(
                    maxLines: 1,
                    "Desc: ${data['pDescription']}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

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
                                'Rs:${data['pPrice']}'.splitMapJoin(
                                  RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                                  onMatch: (m) => "${m[1]},",
                                ),
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
                                  data['pDiscountType'] == "Percentage"
                                      ? 'Rs:${double.parse(data['pPrice']) - (double.parse(data['pPrice']) * double.parse(data['pDiscount']) / 100)}'.splitMapJoin(
                                    RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                                    onMatch: (m) => "${m[1]},",
                                  )
                                      : 'Rs:${double.parse(data['pPrice']) - double.parse(data['pDiscount'])}'.splitMapJoin(
                                    RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                                    onMatch: (m) => "${m[1]},",
                                  ),
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
          ],
        ),
      ),
    ),
  );
}

void wDialogMoreDetails(BuildContext context, data) {
  Get.dialog(
    AlertDialog(
      title: Text("Product Details"),
      alignment: Alignment.center,
      content: GestureDetector(
        onTap: () {
          Get.back();
          Get.to(() => ProductPageView(
              vModel: ProductsModel.fromJson(data), data: data.toString()));
        },
        child: SizedBox(
          width: 650,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data['pImages']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () {
                          // setState(() {
                          //   _isAdded = !_isAdded;
                          // });
                        },
                        icon: Icon(
                          Icons.favorite_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    //   discount  show advance design
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.red,
                        child: data['pDiscountType'] == "Percentage"
                            ? Text(
                          '${data['pDiscount']}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : wText('Rs: ${data['pDiscount']} OFF',
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        wText(
                          data['pName'],
                          size: 18,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data['pCategory'],
                        ),
                        //   description show
                        const SizedBox(height: 5),
                        Text(
                          "Desc: ${data['pDescription']}",
                        ),
                        const SizedBox(height: 5),
                        // color show
                        Text(
                          "Color: ${data['pColor']}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // size show
                        Text(
                          "Size: ${data['pSize']}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // brand show
                        Text(
                          "Brand: ${data['pBrand']}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        //   stock show
                        const SizedBox(height: 5),
                        Text(
                          "Stock: ${data['pQuantity']}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // condition show
                        Text(
                          "Condition: ${data['pCondition']}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // delivery show
                        data['pDelivery'] == "Yes"
                            ? Text(
                          "Delivery: Available",
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
                        const SizedBox(height: 5),
                        // return show
                        data['pReturn'] == "Yes"
                            ? Text(
                          "Return: Policy Available",
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
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        // detail page show
        TextButton(
            onPressed: () {
              Get.back();
              Get.to(() => ProductPageView(
                  vModel: ProductsModel.fromJson(data), data: data.toString()));
            },
            child: const Text('More Details')
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child:  wText('Close', ),
        ),
      ],
    ),
  );
}
