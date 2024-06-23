// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/shops_controller.dart';

class ShopsView extends GetView<ShopsController> {
  ShopsView({super.key});

  @override
  final controller = Get.put(ShopsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          _buildDialogProducts( context);
        }, label: wText('Add',color: Colors.white),
        icon: Icon(Icons.add,color: Colors.white,),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        _buildShops(),
      ],
    );
  }

  _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shops',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.search),
                  //   onPressed: () {},
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.notifications),
                  //   onPressed: () {},
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.shopping_cart),
                  //   onPressed: () {
                  //     // Get.toNamed(Routes.CART);
                  //   },
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.account_balance_wallet),
                  //   onPressed: () {
                  //     // Get.to(WalletView());
                  //   },
                  // ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildCategories(),
        ],
      ),
    );
  }

  _buildShops() {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildShopItem();
        },
      ),
    );
  }

  _buildCategories() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildCategoryItem();
        },
      ),
    );
  }

  _buildShopItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shop Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'This is the cheapest shop in town\nYou can find anything you want here\nWe are open 24/7\nCome and visit us',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ratingBar(5),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  _buildCategoryItem() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('Category'),
    );
  }

  ratingBar(int i) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < i ? Icons.star : Icons.star_border,
          color: Colors.orange,
        ),
      ),
    );
  }

  void _buildDialogProducts(BuildContext context) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Add Product',
        width: 400,
        text: 'Add Product to your shop',
        confirmBtnColor: Colors.red,
        confirmBtnText: 'Cancel',
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            // Add Real state
            TextButton.icon(onPressed: (){
              Get.toNamed('/realstate');

            }, icon: Icon(Icons.home), label: Text('Add Real state')),
            SizedBox(height: 10.0),
            // Add Car
            TextButton.icon(onPressed: (){}, icon: Icon(Icons.car_rental), label: Text('Add Vehicle')),
            SizedBox(height: 10.0),
            // Add Product
            TextButton.icon(onPressed: (){}, icon: Icon(Icons.shopping_cart), label: Text('Add Product')),
            SizedBox(height: 10.0),
          ],
        ),
    );
  }
}
