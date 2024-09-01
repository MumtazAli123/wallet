// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/products/views/show_products_view.dart';
import 'package:wallet/app/modules/realstate/views/show_realstate.dart';
import 'package:wallet/widgets/nav_appbar.dart';

import '../../../../models/realstate_model.dart';
import '../../../../models/user_model.dart';
import '../../../../models/vehicle_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../vehicle/views/vehicle_page_view.dart';
import '../../wallet/views/web_wallet.dart';
import '../controllers/home_controller.dart';

class WebHomeView extends GetView<HomeController> {
  final UserModel? userModel;
  WebHomeView({super.key, this.userModel});

  @override
  final controller = Get.put(HomeController());
  final DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  UserModel? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      appBar: NavAppBar(
        title: 'Home',
      ),
      body: Row(
        children: [
          // Expanded(flex: 3, child: _buildSideBody()),
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  _buildBanner(),
                  SizedBox(height: 10.0),
                  _buildCategory(),
                  SizedBox(height: 10.0),
                  SizedBox(height: 10.0),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 400,
                      maxWidth: 1000,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                      image: DecorationImage(
                        image: AssetImage('assets/images/salewithus.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Vehicles',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildVehicles(),
                  SizedBox(height: 10.0),
                  Text(
                    'Real State',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildRealState(),
                  SizedBox(height: 10.0),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 400,
                      maxWidth: 1000,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                      image: DecorationImage(
                        image: AssetImage('assets/images/zubipay.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),

                  // _buildRealState(),

                  // Expanded(child: _buildRealState()),

                  // _buildHeader(),
                  // _buildContent(),
                  // _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  _buildCategory() {
    return Container(
      color: Get.theme.primaryColor.withOpacity(0.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // sale
            SizedBox(height: 13.0),
            // realState
            Container(
              width: 1100,
              margin: EdgeInsets.only(bottom: 12.0, top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ShowProductsView());
                      },
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 150,
                              maxWidth: 150,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                              image: DecorationImage(
                                image: AssetImage('assets/images/products.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //   Wallet
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => WebWalletView());
                      },
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 150,
                              maxWidth: 150,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                              image: DecorationImage(
                                image: AssetImage('assets/images/wallet.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          wText(
                            'Wallet',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ShowRealstate());
                      },
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 150,
                              maxWidth: 150,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                              image: DecorationImage(
                                image: AssetImage('assets/realstate.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            'Real State',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //   car
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ShowProductsView());
                      },
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 150,
                              maxWidth: 150,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                              image: DecorationImage(
                                image: AssetImage('assets/images/vehicle.jpg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            'Vehicles',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // vehicle
                ],
              ),
            ),
            SizedBox(height: 20.0),
            //   products
          ],
        ),
      ),
    );
  }

  _buildBanner() {
    return SingleChildScrollView(
      child: Container(
        color: Get.theme.primaryColor.withOpacity(0.0),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 400,
                maxWidth: 1000,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/images/salewith.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  _buildRealState(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('realState')
          .orderBy('publishedDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        try {
          if(snapshot.hasError){
            return const Center(
              child: Text('Error'),
            );
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            if (snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    height: 300,
                    width: 1000,
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.withOpacity(0.0),
                    ),
                    child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      controller: ScrollController(),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ), itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data!.docs[index].data() as Map;
                      RealStateModel model =
                      RealStateModel.fromJson(data as Map<String, dynamic>);
                      return _buildCard(
                        onTap: () {
                          // Get.to(() => RealStateViewPage(
                          //     rModel: RealStateModel.fromJson(data), doc: model.toString()));
                        },
                        image: model.image.toString(),
                        label: "${model.realStateType.toString()}\n"
                            "For: ${model.realStateStatus.toString()}",
                      );
                    },
                    ),

                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
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
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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

  _buildVehicles() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('vehicle')
          .orderBy('publishedDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        try {
          if(snapshot.hasError){
            return const Center(
              child: Text('Error'),
            );
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
          if (snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  height: 300,
                  width: 1000,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor.withOpacity(0.0),
                  ),
                  child: GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    controller: ScrollController(),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ), itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data!.docs[index].data() as Map;
                      VehicleModel model =
                          VehicleModel.fromJson(data as Map<String, dynamic>);
                      return _buildCard(
                        onTap: () {
                          Get.to(() => VehiclePageView(
                              vModel: VehicleModel.fromJson(data), doc: model.toString()));
                        },
                        image: model.image.toString(),
                        label: "${model.vehicleType.toString()}\n"
                            "For: ${model.vehicleStatus.toString()}",
                      );
                  },
                        ),

                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          }
        } catch (e) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
