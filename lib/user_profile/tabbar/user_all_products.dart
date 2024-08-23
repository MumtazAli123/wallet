import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/app/modules/products/views/show_products_view.dart';
import 'package:wallet/global/global.dart';

import '../../widgets/mix_widgets.dart';

class MyAllProducts extends StatelessWidget {
  const MyAllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("sellers")
          .doc(sharedPreferences!.getString('uid'))
          .collection('products')
          .snapshots(),
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
              return wMyProductCard(data);
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
  Widget wMyProductCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ShowProductsView(), arguments: data);
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
                            : wText('Rs: ${data['pDiscount']} OFF',
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
                                  'Rs:${data['pPrice']}',
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
                                    data['pDiscountType'] == "Percentage"
                                        ? 'Rs:${double.parse(data['pPrice']) - (double.parse(data['pPrice']) * double.parse(data['pDiscount']) / 100)}'
                                        : 'Rs:${double.parse(data['pPrice']) - double.parse(data['pDiscount'])}',
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

}
