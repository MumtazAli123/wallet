
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/models/vehicle_model.dart';

import 'all_vehicle.dart';


class CarVehicle extends GetView<VehicleController> {
  const CarVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.carVehicleStream(),
      builder: (context, snapshot) {
        try {
          if(snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Vehicle Found'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map;
              VehicleModel model =
              VehicleModel.fromJson(data as Map<String, dynamic>);
              return wBuildVehicleCard(model.toJson());
            },
          );
        } catch (e) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}