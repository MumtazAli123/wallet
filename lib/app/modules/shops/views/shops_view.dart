// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/types/gf_alert_type.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../global/global.dart';
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
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () {
            _buildDialogProducts(context);
          },
          label: wText('Add'.tr, color: Colors.white),
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
    // return SafeArea(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       _buildHeader(),
    //       _buildShops(),
    //     ],
    //   ),
    // );
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: Text(''),
                title: wText('ZubiPay'.tr,size: 20),
                expandedHeight: 410.0,
                centerTitle: true,
                floating: true,
                pinned: true,
                snap: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      wBuildLanguageBottomSheet(context);
                    },
                    icon: const Icon(Icons.language),
                  ),

                  IconButton(
                    onPressed: () {
                      _buildDialogProducts(context);
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(),
                ),

              ),
            ];
          },
          body: _buildShops()
      ),
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
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Lottie.asset('assets/lottie/shoping.json',
                    width: 100, height: 100),
              ),
              Lottie.asset('assets/lottie/earn.json',
                  width: 100, height: 100),

              Lottie.asset('assets/lottie/sale.json',
                  width: 100, height: 100),
            ],
          ),
          SizedBox(height: 10.0),
          _buildCategories(),
          SizedBox(height: 10.0),
          _buildRealState(),
        ],
      ),
    );
  }

  _buildShops() {
    return StreamBuilder<QuerySnapshot>(
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
                  name: 'All'.tr,
                  selected: true)).animate().rotate(duration: Duration(seconds: 2)).slide(
              duration: const Duration(seconds: 4),
          ),
          SizedBox(width: 10.0),
          Expanded(
              child: _buildCategoryItem(
                  onTap: () {
                    Get.to(() => ShowRealstate());
                  },
                  name: 'Real State'.tr)),
          SizedBox(width: 10.0),
          Expanded(
              child: _buildCategoryItem(
                  onTap: () {
                    Get.toNamed('/vehicle');
                  },
                  name: 'Vehicle'.tr)),
          SizedBox(width: 10.0),
          Expanded(
              child: _buildCategoryItem(
                  onTap: () {
                    Get.toNamed('/products'.tr);
                  },
                  name: 'Products'.tr)),
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
        color: Get.theme.primaryColor.withOpacity(0.0),
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
                        'Price: ${model['vehiclePrice']}'.tr,
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
      Function()? onTap}) {
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
            type: GFAlertType.rounded,
            title: 'Add Products'.tr,
            titleAlignment: Alignment.center,
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
                      label: wText('Add Real state'.tr,
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
                          wText('Add Vehicle'.tr, color: Get.theme.primaryColor)),
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
                          wText('Add Products'.tr, color: Get.theme.primaryColor)),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/shop.json',
                          width: 300, height: 150),
                    ],
                  ),

                ]),
            bottomBar: GFButtonBar(
              children: [
                GFButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancel'.tr,
                  color: Colors.red,
                ),
              ],
            ),
          );
        });
  }

  _buildRealState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),

      height: 200,
      // color: Colors.black,
      // child: SingleChildScrollView(
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: Column(
      //           children: [
      //            CircleAvatar(
      //              radius: 50,
      //              backgroundColor: Colors.green,
      //              child: IconButton(
      //                onPressed: () {
      //                  // Get.toNamed('/realstate');
      //                },
      //                icon: Lottie.asset('assets/lottie/shop.json',
      //                    width: 100, height: 100),
      //              ),
      //            ),
      //             SizedBox(height: 10),
      //             aText(
      //                 'All'.tr),
      //           ],
      //         ),
      //       ),
      //       SizedBox(width: 10),
      //       Expanded(
      //         child: Column(
      //           children: [
      //             CircleAvatar(
      //               radius: 50,
      //               backgroundColor: Colors.green,
      //               child: IconButton(
      //                 onPressed: () {
      //                   Get.toNamed('/realstate');
      //                 },
      //                 icon: Lottie.asset('assets/lottie/jump.json',
      //                     width: 150, height: 150, fit: BoxFit.fill),
      //               ),
      //             ),
      //             SizedBox(height: 10),
      //             aText('Real State'.tr),
      //           ],
      //         ),
      //       ),
      //       SizedBox(width: 10),
      //       Expanded(
      //         child: Column(
      //           children: [
      //             CircleAvatar(
      //               radius: 50,
      //               backgroundColor: Colors.green,
      //               child: IconButton(
      //                 onPressed: () {
      //                   Get.to(() => ShowVehicleView());
      //                 },
      //                 icon: Lottie.asset('assets/lottie/round.json',
      //                     width: 150, height: 150, fit: BoxFit.cover),
      //               ),
      //             ),
      //             SizedBox(height: 10),
      //             aText('Vehicle'.tr),
      //           ],
      //         ),
      //       ),
      //       SizedBox(width: 10),
      //       Expanded(
      //         child: Column(
      //           children: [
      //             CircleAvatar(
      //               radius: 50,
      //               backgroundColor: Colors.green,
      //               child: IconButton(
      //                 onPressed: () {
      //                   Get.toNamed('/realstate');
      //                 },
      //                 icon: Lottie.asset('assets/lottie/coins.json',
      //                     width: 50, height: 150, fit: BoxFit.cover
      //                 ),
      //               ),
      //             ),
      //             SizedBox(height: 10),
      //             aText('Products'.tr),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      child: CarouselSlider(
          items: itemsList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Image.asset(
                    i,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            // aspectRatio: 2.7,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            viewportFraction: 0.9,
          )),
    );
        // use itemsList


  }

}
