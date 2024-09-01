
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:wallet/app/modules/vehicle/views/tabbar/all_vehicle.dart';
import 'package:wallet/models/vehicle_model.dart';

import '../controllers/vehicle_controller.dart';

class RentACar  extends GetView<VehicleController>  {
  final VehicleModel? model;
  const RentACar({super.key,  this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent A Car'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: controller.carStream(),
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
                    VehicleModel model = VehicleModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                    return wBuildVehicleCard(model.toJson());
                  },
                );
              } catch (e) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
        )
    );
  }
}