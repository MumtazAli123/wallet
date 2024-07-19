import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';

import '../../../../../widgets/mix_widgets.dart';

class AllVehicle extends GetView<VehicleController> {
  const AllVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.allVehicleStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if (snapshot.data.docs.isEmpty) {
              return const Center(child: Text('No Vehicle found'));
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return wBuildVehicleCard(snapshot.data.docs[index]);
                });
          }
          return const Center(child: Text('No Vehicle found'));
        });
  }
}

Widget wBuildVehicleCard(doc) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(doc['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                // leading: const Icon(Icons.directions_car),
                title: Text("Vehicle: ${doc['vehicleName']}"),
                subtitle: Text("Model: ${doc['vehicleModel']}\nCondition: ${doc['vehicleCondition']}"),
              ),
              ListTile(
                // leading: const Icon(Icons.money),
                subtitle: aText("Price: ${doc['vehiclePrice']}"),
                title: Text("Color: ${doc['vehicleColor']}\nFor: ${doc['vehicleStatus']}"),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
