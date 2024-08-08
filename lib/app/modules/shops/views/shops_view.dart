// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
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
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/types/gf_alert_type.dart';
import 'package:lottie/lottie.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wallet/app/modules/shops/views/vehicle_rating.dart';
import 'package:wallet/models/realstate_model.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../global/global.dart';
import '../../../../models/vehicle_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../products/views/show_products_view.dart';
import '../../realstate/views/show_realstate.dart';
import '../../realstate/views/tabbar/realstate_view_page.dart';
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
    // PushNotificationSys pushNotificationSys = PushNotificationSys();
    // pushNotificationSys.generateDeviceToken();
    // pushNotificationSys.whenNotificationReceived();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          drawer: MyDrawer(),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () {
              _buildDialogProducts(context);
            },
            label: wText('Sale'.tr, color: Colors.white),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: Text(''),
                title: wText('ZubiPay'.tr, size: 20),
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
          body: _buildShops()),
    );
  }

  _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Lottie.asset('assets/lottie/home.json',
                    width: 100, height: 100),
              ),
              Lottie.asset('assets/lottie/earn.json', width: 100, height: 100),
              Lottie.asset('assets/lottie/sale.json', width: 100, height: 100),
            ],
          ),
          SizedBox(height: 10.0),
          _buildCategories(),
          SizedBox(height: 10.0),
          // _buildRealState(),
          Expanded(child: _buildRealState()),
          // SizedBox(height: 10.0),
          // aText(
          //     "Vehicle's".tr),
          // Expanded(child: _buildAvatar()),

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
                      selected: true))
              .animate()
              .rotate(duration: Duration(seconds: 2))
              .slide(
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
                      // platform

                      GFRating(
                        size: 30,
                        borderColor: Colors.amber,
                        color: Colors.amber,
                        onChanged: (value) {
                          Get.to(() => VehicleRating(
                                sellerId: model['sellerId'],
                                image: model['image'],
                                name: model['showroomName'],
                                sellerImage: model['sellerImage'],
                                // model: model,
                              ));
                        },
                        value: sharedPreferences?.getString('rating') != null
                            ? double.parse(
                                sharedPreferences!.getString('rating')!)
                            : 4.1,
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
      {required String name, bool selected = false, Function()? onTap}) {
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
            title: 'Sale your Products'.tr,
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
                      label: wText('Sale Real state'.tr,
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
                      label: wText('Sale Vehicle'.tr,
                          color: Get.theme.primaryColor)),
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
                      label: wText('Sale Products'.tr,
                          color: Get.theme.primaryColor)),
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
    return StreamBuilder<QuerySnapshot>(
      stream: controller.allRealStateStream(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasData) {
            return GridView(
              controller: ScrollController(),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
              children: List.generate(snapshot.data!.docs.length, (index) {
                var data = snapshot.data!.docs[index].data() as Map;
                RealStateModel model = RealStateModel.fromJson(data as Map<String, dynamic>);
                return _buildCard(
                  onTap: () {
                    Get.to(() => RealstateViewPage(
                        rsModel: RealStateModel.fromJson(model.toJson()), doc: ''));

                  },
                  image: model.image.toString(),
                  label: "${model.realStateType.toString()}\n"
                      "For: ${model.realStateStatus.toString()}",
                );
              }),
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


  _buildCard({required String image, required String label, required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all( 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10)
                  ),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAvatar() {
    // return StreamBuilder<QuerySnapshot>(
    //   stream: controller.allVehicleStream(),
    //   builder: (context, snapshot) {
    //     try {
    //       if (snapshot.hasData) {
    //         return GridView(
    //           controller: ScrollController(),
    //           scrollDirection: Axis.horizontal,
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 1,
    //           crossAxisSpacing: 10,
    //           mainAxisSpacing: 10,
    //         ),
    //           children: List.generate(snapshot.data!.docs.length, (index) {
    //             var data = snapshot.data!.docs[index].data() as Map;
    //             VehicleModel model = VehicleModel.fromJson(data as Map<String, dynamic>);
    //             return _buildAvatarItem(
    //               onTap: () {
    //                 Get.to(() => VehiclePageView(
    //                     vModel: VehicleModel.fromJson(model.toJson()), doc: model.toString()));
    //               },
    //               image: model.image.toString(),
    //               label: "${model.showroomName.toString()}\n"
    //                   "${model.vehicleName.toString()}",
    //             );
    //           }),
    //         );
    //       } else {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     } catch (e) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //   },
    // );
    return Row(
      children: [
        Expanded(child: Lottie.asset('assets/lottie/home.json', width: 300, height: 300)),
        Expanded(child: GestureDetector(
          onTap: (){
            Get.to(() => ShowRealstate());

          },
            child: Lottie.asset('assets/lottie/realState.json', width: 300, height: 300))),
      ],
    );
  }

  _buildAvatarItem({required Null Function() onTap, required String image, required String label}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all( 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10)
                  ),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
