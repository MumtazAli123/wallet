// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';

import '../../../../models/vehicle_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../products/views/show_products_view.dart';
import '../../realstate/views/show_realstate.dart';
import '../../vehicle/controllers/vehicle_controller.dart';
import '../../vehicle/views/show_vehicle_view.dart';
import '../../vehicle/views/vehicle_page_view.dart';

class ShopsView extends StatefulWidget {
  const ShopsView({super.key});

  @override
  State<ShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends State<ShopsView> {
  final controller = Get.put(VehicleController());
  bool isLoading = false;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    controller.allVehicleStream();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () {
            _buildDialogProducts(context);
          },
          label: wText('Add', color: Colors.white),
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          SizedBox(height: 10.0),
          _buildCategories(),
        ],
      ),
    );
  }

  _buildShops() {
    return Expanded(
      // child: ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index) {
      //     return _buildShopItem();
      //   },
      // ),
      child: StreamBuilder<QuerySnapshot>(
        stream: controller.allVehicleStream(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index].data() as Map;
                  VehicleModel model =
                      VehicleModel.fromJson(data as Map<String, dynamic>);
                  return _buildShopItem(model.toJson());
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } catch (e) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _buildCategories() {
    return Center(
      child: SizedBox(
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
              child: _buildCategoryItem(
                  onTap: () {
                    // controller.fetchShops();
                  },
                  name: 'All',
                  selected: true)),
          SizedBox(width: 10.0),
          Expanded(
              child: _buildCategoryItem(
                  onTap: () {
                    Get.to(() => ShowRealstate());
                  },
                  name: 'Real State')),
          SizedBox(width: 10.0),
          Expanded(
              child: _buildCategoryItem(
                  onTap: () {
                    Get.toNamed('/vehicle');
                  },
                  name: 'Vehicle')),
          SizedBox(width: 10.0),
          Expanded(
              child: _buildCategoryItem(
                  onTap: () {
                    Get.toNamed('/products');
                  },
                  name: 'Products')),
          // Expanded(child: _buildCategoryItem(name: 'Others')),
        ]),
      ),
    );
  }

  _buildShopItem(model) {
    return GestureDetector(
      onTap: () {
        Get.to(() => VehiclePageView(
            vModel: VehicleModel.fromJson(model), doc: model.toString()));
      },
      child: Container(
        color: Get.theme.primaryColor.withOpacity(0.1),
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
                      image: NetworkImage(model['image'].toString()),
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
                        'Showroom: ${model['showroomName']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Vehicle ${model['vehicleName']}\nModel: ${model["vehicleModel"]} \n ${model['status']}",
                        style: TextStyle(
                          fontSize: 14,
                          // color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Price: ${model['vehiclePrice']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Upload: ${(GetTimeAgo.parse(DateTime.parse(model['updatedDate'].toDate().toString()).toLocal()))}",
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
    showDialog(
        context: context,
        builder: (context) {
          return GFAlert(
            title: 'Add Product',
            content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(),
                  SizedBox(height: 10.0),
                  // Add Real state
                  TextButton.icon(
                      onPressed: () {
                        Get.toNamed('/realstate');
                      },
                      icon: Icon(
                        Icons.real_estate_agent,
                        color: Get.theme.primaryColor,
                      ),
                      label: wText('Add Real state',
                          color: Get.theme.primaryColor)),
                  SizedBox(height: 10.0),
                  // Add Car
                  TextButton.icon(
                      onPressed: () {
                        Get.to(() => ShowVehicleView());
                      },
                      icon: Icon(
                        Icons.car_rental,
                        color: Get.theme.primaryColor,
                      ),
                      label:
                          wText('Add Vehicle', color: Get.theme.primaryColor)),
                  SizedBox(height: 10.0),
                  // Add Product
                  TextButton.icon(
                      onPressed: () {
                        Get.to(() => ShowProductsView());
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Get.theme.primaryColor,
                      ),
                      label:
                          wText('Add Products', color: Get.theme.primaryColor)),
                  SizedBox(height: 10.0),
                ]),
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
        });
  }
}
