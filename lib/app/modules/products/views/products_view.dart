// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:wallet/app/modules/products/views/show_products_view.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 17,
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  GFIconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10.0),
                  GFIconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.to(() => ShowProductsView());
                    },
                  ),
                  SizedBox(width: 10.0),
                ],
                centerTitle: false,
                title: wText('Products', size: 24),
                floating: true,
                snap: true,
                pinned: true,
                bottom: TabBar(
                  tabAlignment: TabAlignment.center,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.all_inbox),
                        text: 'All'),
                    // Phones 2
                    Tab(
                      icon: Icon(Icons.phone_android),
                        text: 'Phones'),
                    // Laptops 3
                    Tab(
                      icon: Icon(Icons.laptop),
                        text: 'Laptops'),
                    // Electronics 4
                    Tab(
                      icon: Icon(Icons.electrical_services_outlined),
                        text: 'Electronics'),
                    // Clothes 5
                    Tab(
                      icon: Icon(Icons.shopping_bag),
                        text: 'Clothes'),
                    // Shoes 6
                    Tab(
                      icon: Icon(Icons.snowshoeing_sharp),
                        text: 'Shoes'),
                  //Bags  7
                    Tab(
                      icon: Icon(Icons.shopping_bag),
                        text: 'Bags'),
                  //Fashion 8
                    Tab(
                      icon: Icon(EvaIcons.shoppingBag),
                        text: 'Fashion'),
                  //Home 9
                    Tab(
                      icon: Icon(EvaIcons.home),
                        text: 'Home'),
                  //Appliances 10
                    Tab(
                      icon: Icon(EvaIcons.thermometer),
                        text: 'Appliances'),
                  //Beauty 11
                    Tab(
                      icon: Icon(EvaIcons.heart),
                        text: 'Beauty'),
                  //Toys 12
                    Tab(
                      icon: Icon(EvaIcons.gift),
                        text: 'Toys'),

                  //Grocery 13
                    Tab(
                      icon: Icon(EvaIcons.shoppingCart),
                        text: 'Grocery'),
                  //Sports 14
                    Tab(
                      icon: Icon(EvaIcons.umbrella),
                        text: 'Sports'),
                  //Books 15
                    Tab(
                      icon: Icon(EvaIcons.bookOpen),
                        text: 'Books'),
                  //Stationery 16
                    Tab(
                      icon: Icon(EvaIcons.archive),
                        text: 'Stationery'),
                  //Others 17
                    Tab(
                      icon: Icon(EvaIcons.options),
                        text: 'Others'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Container(color: Colors.red),
              Container(color: Colors.green),
              Container(color: Colors.blue),
              Container(color: Colors.yellow),
              Container(color: Colors.orange),
              Container(color: Colors.purple),
              Container(color: Colors.pink),
              Container(color: Colors.teal),
              Container(color: Colors.brown),
              Container(color: Colors.grey),
              Container(color: Colors.indigo),
              Container(color: Colors.lime),
              Container(color: Colors.amber),
              Container(color: Colors.cyan),
              Container(color: Colors.deepOrange),
              Container(color: Colors.deepPurple),
              Container(color: Colors.lightGreen),
              // AllRealState(),
              // HouseView(),
              // ApartmentView(),
              // OfficesView(),
              // LandView(),
              // ShopsView(),
            ],
          )),
    );
  }
}
