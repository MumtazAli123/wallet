// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/app/modules/vehicle/views/upload_vehicle_view.dart';

import '../../../../models/vehicle_model.dart';
import '../../../../widgets/mix_widgets.dart';

class ShowVehicleView extends GetView<VehicleController> {
  ShowVehicleView({super.key});

  @override
  VehicleController controller = Get.put(VehicleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.to(() => UploadVehicleView());
        },
        label: wText('Upload', color: Colors.white),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: _buildBody(),
      appBar: _buildAppBar(),
    );
  }

  _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: wText('Vehicle'),
      centerTitle: true,
    );
  }

  _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: _buildVehicleList(),
      ),
    );
  }

  _buildVehicleList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.vehicleStream(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data() as Map;
                VehicleModel model =
                    VehicleModel.fromJson(data as Map<String, dynamic>);
                return wBuildVehicleItem(model);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } catch (e) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  wBuildVehicleItem(VehicleModel model) {
    return GFCard(
      image: Image.network(model.image!),
      showImage: true,
      title: GFListTile(
        icon: Icon(Icons.directions_car),
        title: wText("Vehicle: ${model.vehicleName!}"),
        subTitle: wText("Model: ${model.vehicleModel!}"),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.money),
            title: aText("Price: ${model.vehiclePrice!}"),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: aText("Km: ${model.vehicleKm!}"),
          ),
        ],
      ),
    );
  }
}
