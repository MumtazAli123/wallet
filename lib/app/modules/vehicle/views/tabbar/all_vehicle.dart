import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';

import '../../../../../models/vehicle_model.dart';
import '../../../../../widgets/mix_widgets.dart';
import '../vehicle_page_view.dart';

class AllVehicle extends GetView<VehicleController> {
  const AllVehicle({super.key});

  @override
  Widget build(BuildContext context) {
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
                return wBuildVehicleCard(model.toJson());
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
}

Widget wBuildVehicleCard(doc) {
  bool isDarkMode = Get.isDarkMode;
  return GestureDetector(
    onTap: () {
      Get.to(() => VehiclePageView(
          vModel: VehicleModel.fromJson(doc), doc: doc.toString()

      ));
    },
    child: Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
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
          Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(doc['image'], scale: 1.0, headers: {'User-Agent': 'your_user_agent'}),
                fit: BoxFit.cover,
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
                  iconColor: isDarkMode ? Colors.white : Colors.black,
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
    ),
  );
}

Widget wVehicleCard(doc) {
  return GFImageOverlay(
    height: 200,
    width: double.infinity,
    shape: BoxShape.rectangle,
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
    borderRadius: BorderRadius.circular(8.0),
    image: NetworkImage(doc['image']),
    boxFit: BoxFit.cover,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GFListTile(
            avatar: GFAvatar(
              shape: GFAvatarShape.standard,
              backgroundImage: NetworkImage(doc['image']),
            ),
            title: wText("Vehicle: ${doc['vehicleName']}", color: Colors.white),
            subTitle: wText("Model: ${doc['vehicleModel']}", color: Colors.white),
          ),
          ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.white),
            title: aText("Km: ${doc['vehicleKm']}", color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
