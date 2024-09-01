// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/products/views/products_page_view.dart';
import 'package:wallet/app/modules/register/controllers/register_controller.dart';
import 'package:wallet/models/products_model.dart';

import '../../../../widgets/mix_widgets.dart';

class ProductsSearchView extends StatefulWidget {
  const ProductsSearchView({super.key});

  @override
  State<ProductsSearchView> createState() => _ProductsSearchViewState();
}

class _ProductsSearchViewState extends State<ProductsSearchView> {
  final controller = Get.put(RegisterController());
  var searchName = '';



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Products'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(

                textInputAction: TextInputAction.search,
                inputFormatters: [
                  RegisterController().upperCaseTextFormatter,

                ],
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchName = value;
                  });
                },
              ),
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products')
            .orderBy('pName')
            .startAt([searchName]).endAt(['$searchName\uf8ff'])
            .limit(5)
            .snapshots(),

        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.data!.docs.isEmpty){
            return const Center(
              child: Text('No data found'),
            );
          }
          else{
            return ListView.builder(
              // less than 3 items will not show
              // itemCount: snapshot.data!.docs.length,
              itemCount: 5 < 5 ? 5 : snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map;
                ProductsModel model =
                ProductsModel.fromJson(data as Map<String, dynamic>);
                return wProductsCard(model.toJson());
              },
            );
          }
        },
      ),
    );

  }

  wProductsCard(doc) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductPageView(
            vModel: ProductsModel.fromJson(doc), data: doc.toString()));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(doc['pImages']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      // leading: const Icon(Icons.directions_car),
                      title: cText("${doc['pName']}\n"

                          "Price: ${doc['pPrice']}"),
                      subtitle: Column(
                        children: [
                          doc["pDiscountType"] == "Percentage"
                              ? Text(
                            '${doc['pDiscount']}% OFF',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : aText('Rs: ${doc['pDiscount']} OFF',
                              color: Colors.red),
                          const SizedBox(height: 4),
                          Text(
                            doc['pDiscountType'] == "Percentage"
                                ? 'Rs:${double.parse(doc['pPrice']) - (double.parse(doc['pPrice']) * double.parse(doc['pDiscount']) / 100)}'
                                : 'Rs:${double.parse(doc['pPrice']) - double.parse(doc['pDiscount'])}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
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
