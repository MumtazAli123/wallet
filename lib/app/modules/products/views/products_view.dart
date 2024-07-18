// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

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
      length: 6,
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
                    Tab(
                      icon: Icon(Icons.phone_android),
                        text: 'Phones'),
                    Tab(
                      icon: Icon(Icons.laptop),
                        text: 'Laptops'),
                    Tab(
                      icon: Icon(Icons.electrical_services_outlined),
                        text: 'Electronics'),
                    Tab(
                      icon: Icon(Icons.shopping_bag),
                        text: 'Clothes'),
                    Tab(
                      icon: Icon(Icons.snowshoeing_sharp),
                        text: 'Shoes'),
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
