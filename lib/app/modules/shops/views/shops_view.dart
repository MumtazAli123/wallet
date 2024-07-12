// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../realstate/views/show_realstate.dart';
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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 10),
          _buildCategoryItem(name: 'All', selected: true),
          SizedBox(width: 10),
          _buildCategoryItem(
            icon: Icons.fastfood,
              name: 'RealState', onTap: () {
            Get.to(() => ShowRealstate());
          }),
          SizedBox(width: 10),
          _buildCategoryItem(name: 'Vehicle', onTap: () {
            print('Clothes');
          }),
          SizedBox(width: 10),
          _buildCategoryItem(name: 'Electronics', onTap: () {
            print('Electronics');
          }),
          SizedBox(width: 10),
          _buildCategoryItem(name: 'Furniture', onTap: () {
            print('Furniture');
          }),
        ],
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

  _buildCategoryItem({required String name, bool selected = false, Function()? onTap, IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: GFAvatar(
        backgroundColor: selected ? Colors.green : Colors.grey[200],
        shape: GFAvatarShape.standard,
        size: 60,
        child: wText(name, color: selected ? Colors.white : Colors.black),
      ),
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
