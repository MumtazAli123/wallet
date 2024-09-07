// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/types/gf_alert_type.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/app/modules/shops/views/vehicle_rating.dart';
import 'package:wallet/models/realstate_model.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../global/global.dart';
import '../../../../models/products_model.dart';
import '../../../../models/vehicle_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../partner/views/upload_profile.dart';
import '../../products/views/products_page_view.dart';
import '../../products/views/show_products_view.dart';
import '../../products/views/tabbar/all_products.dart';
import '../../realstate/views/show_realstate.dart';
import '../../realstate/views/tabbar/realstate_view_page.dart';
import '../../vehicle/controllers/vehicle_controller.dart';
import '../../vehicle/views/rent_a_car.dart';
import '../../vehicle/views/show_vehicle_view.dart';
import '../../vehicle/views/vehicle_page_view.dart';

class ShopsView extends StatefulWidget {
  const ShopsView({super.key});

  @override
  State<ShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends State<ShopsView> {
  final controllerVehicle = Get.put(VehicleController());
  final controller = Get.put(ProductsController());
  bool isLoading = false;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    controllerVehicle.allVehicleStream();
    // PushNotificationSys pushNotificationSys = PushNotificationSys();
    // pushNotificationSys.generateDeviceToken();
    // pushNotificationSys.whenNotificationReceived();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
          appBar: AppBar(
            title: wText('ZubiPay'.tr, size: 20),
            centerTitle: true,
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
            bottom: TabBar(
              tabAlignment: TabAlignment.center,
              controller: controller.fabController,
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home'.tr,
                ),
                Tab(
                  icon: Icon(Icons.car_rental),
                  text: 'Vehicles'.tr,
                ),
                Tab(
                  icon: Icon(Icons.shopping_cart),
                  text: 'Products'.tr,
                ),
                Tab(
                  icon: Icon(Icons.real_estate_agent),
                  text: 'Real State'.tr,
                ),
              ],
            ),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      children: [
        _buildHome(),
        _buildVehicleTab(),
        AllProducts(),
        _buildRealState(),
      ],
    );
  }

  _buildHome() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // welcome
                _buildBalance(),
                SizedBox(height: 10.0),
                _buildButton(),
                SizedBox(height: 10.0),
                // rent a car
                _buildRentCar(),
                SizedBox(height: 10.0),
                // vehicle
                // search your partner
                _buildLifePartner(),
                SizedBox(height: 10.0),
                // find job
                _buildFindJob(),
                SizedBox(height: 10.0),
                _buildTackerCard(),

                //   build grid view
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text('Welcome to ZubiPay'.tr,
                            style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Divider(),
                        Text(
                          'ZubiPay is a platform where you can sell your products, real state, and vehicles. You can also find a job, rent a car and find your life partner.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Vehicles'.tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      _buildVehicles(),
                      SizedBox(height: 10.0),
                      Text('Real State'.tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      _buildRealStateBox(),
                      SizedBox(height: 10.0),
                      Text('Products'.tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      _buildProductsBox(),
                      SizedBox(height: 10.0),
                    ],
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildVehicleTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: controllerVehicle.allVehicleStream(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map;
                return _buildVehicleItem(data);
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

  _buildVehicleItem(model) {
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
                        'Price: ${model['vehiclePrice']}'.tr.splitMapJoin(
                              RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                              onMatch: (m) => '${m[1]},',
                            ),
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
                  // Add Job
                  TextButton.icon(
                      onPressed: () {
                        Get.toNamed('/job');
                      },
                      icon: Icon(
                        Icons.work,
                        color: Get.theme.primaryColor,
                      ),
                      label: wText('Find Job'.tr,
                          color: Get.theme.primaryColor)),
                  SizedBox(height: 10.0),
                  // Add Partner
                  TextButton.icon(
                      onPressed: () {
                        Get.to(() => UploadProfile());
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Get.theme.primaryColor,
                      ),
                      label: wText('Find Partner'.tr,
                          color: Get.theme.primaryColor)),
                  SizedBox(height: 10.0),

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
      stream: controllerVehicle.allRealStateStream(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasData) {
            return GridView(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              children: List.generate(snapshot.data!.docs.length, (index) {
                var data = snapshot.data!.docs[index].data() as Map;
                RealStateModel model =
                    RealStateModel.fromJson(data as Map<String, dynamic>);
                return _buildCard(
                  onTap: () {
                    Get.to(() => RealstateViewPage(
                        rsModel: RealStateModel.fromJson(model.toJson()),
                        doc: ''));
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

  _buildCard(
      {required String image,
      required String label,
      required Function() onTap}) {
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
            image: NetworkImage(image.toString()),
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
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  maxLines: 2,
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

  _buildButtonCard(
    String s,
    String send,
  ) {
    return GestureDetector(
      onTap: () {
        if (s == 'Vehicles'.tr) {
          Get.toNamed('/vehicle');
        } else if (s == 'Real State'.tr) {
          Get.to(() => ShowRealstate());
        } else if (s == 'Products'.tr) {
          Get.toNamed('/products');
        }
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 4.0),
        margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(send, height: 80, width: double.infinity),
            // Icon(send, size: 30.0, color: Theme.of(context).primaryColor),
            SizedBox(height: 10.0),
            wText(s, size: 16.0, color: Theme.of(Get.context!).primaryColor),
          ],
        ),
      ),
    );
  }

  _buildVehicles() {
    return SizedBox(
      height: 240,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vehicle')
              .orderBy("updatedDate", descending: true)
              .limit(15)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index].data() as Map;
                  VehicleModel model =
                      VehicleModel.fromJson(data as Map<String, dynamic>);
                  // return _buildCard(
                  //   image: model.image.toString(),
                  //   label: "${model.vehicleName.toString()}\n"
                  //       "For ${model.vehicleStatus.toString()}",
                  //   onTap: () {
                  //     Get.to(() => VehiclePageView(
                  //         vModel: VehicleModel.fromJson(model.toJson()),
                  //         doc: ''));
                  //   },
                  // );
                  return _buildVehicleBox(model);
                },
              );
            } else {
              return Center(
                child: Text('No Data Found'),
              );
            }
          }),
    );
  }

  _buildVehicleBox(model) {
    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: () {
          //   show on  same page
          Get.to(() => VehiclePageView(
                vModel: VehicleModel.fromJson(model.toJson()),
                doc: '',
              ));
        },
        child: Card(
          elevation: 5,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                model.image != null
                    ? Image.network(
                        model.image.toString(),
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(),
                Container(
                  padding: const EdgeInsets.all(3),
                  color: Colors.red,
                  child: model.vehicleStatus == "Sale"
                      ? Text(
                          'For Sale',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : aText(
                          'For Rent',
                          color: Colors.white,
                          size: 12,
                        ),
                ),
                Expanded(
                    child: rText(
                  "${model.vehicleName}",
                  size: 16.0,
                )),
                Expanded(child: rText("Model: ${model.vehicleModel}")),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // show price and cross after show discount price
                        Positioned(
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Rs:${model.vehiclePrice}'.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  _buildProductsBox() {
    return SizedBox(
      height: 280,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("products")
              .orderBy("pCreatedAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index].data();
                  ProductsModel model = ProductsModel.fromJson(data);
                  return wBuildProductsC(model.toJson());
                },
              );
            } else {
              return Center(
                child: Text('No Data Found'),
              );
            }
          }),
    );
  }

  wBuildProductsC(Map<String, dynamic> doc) {
    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: () {
          //   show on  same page
          Get.to(() => ProductPageView(
              vModel: ProductsModel.fromJson(doc), data: "products"));
        },
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              doc["pImages"].isEmpty
                  ? Container(
                      height: 100,
                      color: Colors.blue,
                      child: Align(
                        child: eText("Check Network", color: Colors.white),
                      ),
                    )
                  : Image.network(
                      doc['pImages'].toString(),
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              Container(
                padding: const EdgeInsets.all(3),
                color: Colors.red,
                child: doc['pDiscountType'] == "Percentage"
                    ? Text(
                        '${doc['pDiscount']}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : aText(
                        'Rs: ${doc['pDiscount']} OFF',
                        color: Colors.white,
                        size: 12,
                      ),
              ),
              Text(
                maxLines: 1,
                "${doc['pName']} ",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              eText("${doc['pCondition']}"),
              // rating
              Align(
                alignment: Alignment.bottomLeft,
                child: GFRating(
                  size: 20,
                  borderColor: Colors.amber,
                  color: Colors.amber,
                  value: 3.5,
                  onChanged: (double rating) {
                    if (sharedPreferences?.getString('uid') != null) {
                      FirebaseFirestore.instance
                          .collection('products')
                          .doc(doc['pUniqueId'])
                          .update({
                        'rating': rating,
                      });
                      if (rating == 1) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Very Bad',
                          text: '$rating Star',
                        );
                      } else if (rating == 2) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Bad',
                          text: ' $rating Star',
                        );
                      } else if (rating == 3) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Good',
                          text: '$rating Star',
                        );
                      } else if (rating == 4) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Very Good',
                          text: '$rating Star',
                        );
                      } else if (rating == 5) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Excellent',
                          text: '$rating Star',
                        );
                      }
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Error',
                        text: 'Please Login First',
                      );
                    }
                  },
                ),
              ),
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
                            'Rs:${doc['pPrice']}'.splitMapJoin(
                              RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                              onMatch: (m) => '${m[1]},',
                            ),
                            style: const TextStyle(
                              color: Colors.red,
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
                              doc['pDiscountType'] == "Percentage"
                                  ? 'Rs:${double.parse(doc['pPrice']) - (double.parse(doc['pPrice']) * double.parse(doc['pDiscount']) / 100)}'
                                      .splitMapJoin(
                                      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                                      onMatch: (m) => '${m[1]},',
                                    )
                                  : 'Rs:${double.parse(doc['pPrice']) - double.parse(doc['pDiscount'])}'
                                      .splitMapJoin(
                                      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                                      onMatch: (m) => '${m[1]},',
                                    ),
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
      ),
    );
  }

  _buildRealStateBox() {
    return SizedBox(
      height: 255,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("realState")
              .orderBy("updatedDate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index].data();
                  RealStateModel model = RealStateModel.fromJson(data);
                  return _buildCard(
                    image: model.image.toString(),
                    label: "${model.realStateType.toString()}\n"
                        "For ${model.realStateStatus.toString()}",
                    onTap: () {
                      Get.to(() => RealstateViewPage(
                          rsModel: RealStateModel.fromJson(model.toJson()),
                          doc: "realstate"));
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('No Data Found'),
              );
            }
          }),
    );
  }

  wBuildRealstateBox(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return GestureDetector(
        onTap: () {
          Get.to(() => ShowRealstate());
        },
        child: SizedBox(
            width: 200,
            child: GestureDetector(
                onTap: () {
                  //   show on  same page
                  Get.to(() => RealstateViewPage(
                      rsModel: RealStateModel.fromJson(doc.data()),
                      doc: "realstate"));
                },
                child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        doc["image"] != null
                            ? Image.network(
                                doc["image"],
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.all(3),
                          color: Colors.red,
                          child: doc['realStateStatus'] == "Sale"
                              ? Text(
                                  'For Sale',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : aText(
                                  'For Rent',
                                  color: Colors.white,
                                  size: 12,
                                ),
                        ),
                        Text(
                          maxLines: 1,
                          "${doc['realStateType']} ",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        eText("${doc['city']}"),
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
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Rs:${doc['startingFrom']}',
                                        style: const TextStyle(
                                          color: Colors.white,
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
                    )))));
  }

  void _buildBottomSheet(BuildContext context) {
    showModalBottomSheet(
        barrierLabel: 'Cancel',
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Statement wallet
                ListTile(
                  leading: Icon(EvaIcons.fileText),
                  title: Text('Statement'),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/statement');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Change Language'),
                  onTap: () {
                    Get.back();
                    wBuildLanguageBottomSheet(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Logout'),
                  onTap: () {
                    //  logout user
                    FirebaseAuth.instance.signOut();
                    Get.offAllNamed('/login');
                  },
                ),
                SizedBox(height: 50.0),
              ],
            ),
          );
        });
  }

  _buildBalance() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(sharedPreferences?.getString('uid'))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.0),
                Card(
                  elevation: 5,
                  child: FlipCard(
                    front: ListTile(
                      leading: snapshot.data!["image"].toString().isEmpty
                          ? Icon(Icons.person)
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(snapshot.data!['image']),
                            ),
                      title: Text('Welcome ${snapshot.data!['name']}'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Balance:'.tr),
                          Text(
                            'Rs: ${snapshot.data!['balance']}'.splitMapJoin(
                              RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
                              onMatch: (m) => '${m[1]},',
                            ),
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _buildBottomSheet(context);
                        },
                        icon: Icon(Icons.more_vert),
                      ),
                    ),
                    back: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone: ${snapshot.data!['phone']}'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child:
                _buildButtonCard("Vehicles".tr, "assets/lottie/rstate.json")),
        // Expanded(
        //     child: _buildButtonCard("Receive Money".tr, Icons.money)),
        Expanded(
            child: _buildButtonCard("Real State".tr, "assets/lottie/pro.json")),
        Expanded(
            child: _buildButtonCard("Products".tr, "assets/lottie/shop.json")),
      ],
    );
  }

  _buildTackerCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/inspection');
      },
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/trac.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: cText(
                  'Inspection'.tr,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLifePartner() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/partner');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                'assets/images/life.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFindJob() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/job');
      },
      child: Card(
        elevation: 10,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/job.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: cText(
                  'Find Job'.tr,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildRentCar() {
    return GestureDetector(
      onTap: () {
        Get.to(() => RentACar(
              model: VehicleModel(),
            ));
      },
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/rent.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: cText(
                  'Rent a Car'.tr,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
