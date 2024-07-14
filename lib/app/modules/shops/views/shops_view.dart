// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../realstate/views/show_realstate.dart';
import '../controllers/shops_controller.dart';

class ShopsView extends StatefulWidget {
  ShopsView({super.key});

  @override
  State<ShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends State<ShopsView> {
  final controller = Get.put(ShopsController());
  bool isLoading = false;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    controller.fetchShops();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton.extended(
        //   backgroundColor: Colors.orange,
        //   onPressed: () {
        //     _buildDialogProducts(context);
        //   },
        //   label: wText('Add', color: Colors.white),
        //   icon: Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        // ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              centerTitle: false,
              title: wText('Shops', size: 24),
              floating: true,
              snap: true,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _buildDialogProducts(context);
                  },
                ),
              ],
              bottom: TabBar(
                labelColor: Colors.orange,
                controller: controller.tabController,
                automaticIndicatorColorAdjustment: true,
                isScrollable: true,
                tabs: [
                  Tab(
                    icon: Icon(Icons.all_inbox),
                      text: 'All'),
                  Tab(icon: Icon(Icons.real_estate_agent), text: 'RealState'),
                  Tab(
                      icon: Icon(Icons.car_rental),
                      text: 'Vehicle'),
                  Tab(
                      icon: Icon(Icons.shopping_cart),
                      text: 'Electronics'),
                  Tab(
                      icon: Icon(Icons.chair),
                      text: 'Furniture'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            _buildShops(),
            ShowRealstate(),
            Container(),
            Container(),
            Container(),
          ],
        ));
    // return Column(
    //   children: [
    //     _buildHeader(),
    //     _buildShops(),
    //   ],
    // );
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
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 10),
          _buildCategoryItem(name: 'All', selected: true),
          SizedBox(width: 10),
          _buildCategoryItem(
              icon: Icons.fastfood,
              name: 'RealState',
              onTap: () {
                Get.to(() => ShowRealstate());
              }),
          SizedBox(width: 10),
          _buildCategoryItem(name: 'Vehicle', onTap: () {}),
          SizedBox(width: 10),
          _buildCategoryItem(name: 'Electronics', onTap: () {}),
          SizedBox(width: 10),
          _buildCategoryItem(name: 'Furniture', onTap: () {}),
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

  _buildCategoryItem(
      {required String name,
      bool selected = false,
      Function()? onTap,
      IconData? icon}) {
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
    showDialog(context: context,
        builder: (context) {
          return GFAlert(
            title: 'Add Product',
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:[
                Divider(),
                SizedBox(height: 10.0),
                // Add Real state
                TextButton.icon(
                    onPressed: () {
                      Get.toNamed('/realstate');
                    },
                    icon: Icon(Icons.real_estate_agent, color: Get.theme.primaryColor,),
                    label: wText('Add Real state', color: Get.theme.primaryColor)),
                SizedBox(height: 10.0),
                // Add Car
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.car_rental, color: Get.theme.primaryColor,),
                    label: wText('Add Vehicle', color: Get.theme.primaryColor)),
                SizedBox(height: 10.0),
                // Add Product
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.shopping_cart, color: Get.theme.primaryColor,),
                    label: wText('Add Shop', color: Get.theme.primaryColor)),
                SizedBox(height: 10.0),

              ]
            ),
            bottomBar: GFButtonBar(
              children: [
                GFButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
                  color: Colors.red,
                ),
              ],
            ),
          );
        }
    );
  }
}
