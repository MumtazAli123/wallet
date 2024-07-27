// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/vehicle/views/search_view.dart';
import 'package:wallet/app/modules/vehicle/views/show_vehicle_view.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/all_vehicle.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/bike.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/bus_view.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/car_vehicle.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/others_view.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/truck_view.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/vehicle_controller.dart';

class VehicleView extends GetView<VehicleController> {
  const VehicleView({super.key});

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
                  // search button
                  GFIconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Get.to(() => SearchView());
                      }),
                  SizedBox(width: 10.0),
                  // add button
                  GFIconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _buildAddVehicleDialog(context);
                      }),
                  SizedBox(width: 10.0),
                ],
                centerTitle: false,
                title: wText('Vehicle', size: 24),
                floating: true,
                snap: true,
                pinned: true,
                bottom: TabBar(
                  tabAlignment: TabAlignment.center,
                  controller: controller.fabController,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.all_inbox),
                        text: 'All Vehicle'),
                    Tab(
                      icon: Icon(Icons.directions_car_sharp),
                        text: 'Cars'),
                    Tab(
                      icon: Icon(Icons.motorcycle),
                        text: 'Bikes'),
                    Tab(
                      icon: Icon(Icons.local_shipping),
                        text: 'Truck'),
                    Tab(
                      icon: Icon(Icons.directions_bus),
                        text: 'Bus'),
                    Tab(
                      icon: Icon(Icons.devices_other_sharp),
                        text: 'Others'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              AllVehicle(),
              CarVehicle(),
              BikeView(),
              TruckView(),
              BusView(),
              OthersView(),

              // AllVehicle(),
              // Car(),
              // Bike(),
              // Truck(),
              // Bus(),
              // Other(),
            ],
          )),
    );
  }

  void _buildAddVehicleDialog(BuildContext context) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Add Vehicle',
      text: "Upload your vehicle details",
      width: 500,
      showConfirmBtn: false,
      widget: Column(
        children: [
          Divider(),
          GFButton(onPressed: () {
            Get.back();
            Get.to(() => ShowVehicleView());
          }, text: 'Add Vehicle'),

        ],
      )
    );
  }
}
