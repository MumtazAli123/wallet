import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/app/modules/vehicle/views/show_vehicle_view.dart';

import '../../global/global.dart';
import '../../widgets/mix_widgets.dart';

class MyAllVehicles extends StatelessWidget {
  const MyAllVehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString('uid'))
            .collection('vehicle')
            .snapshots(),
        builder: ( context,  snapshot) {
          try {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Vehicles Found'),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                return wMyVehiclesCard(data);
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

  Widget wMyVehiclesCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        _buildDialog( data);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              data['image'],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            eText(data['vehicleName']),
            eText("Model: ${data['vehicleModel']}"),
            data['currency'] == 'USD'
                ? eText("${data["currency"]}: \$${data['vehiclePrice']}")
                : eText("Rs: ${data['vehiclePrice']}"),
          ],
        ),
      ),
    );
  }

  void _buildDialog(Map<String, dynamic> data) {
    Get.defaultDialog(
      title: data['vehicleName'],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(data['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          eText("Model: ${data['vehicleModel']}"),
          eText("Rs: ${data['vehiclePrice']}"),
          eText("Color: ${data['vehicleColor']}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Get.to(()=> const ShowVehicleView(), arguments: data);
          },
          child: const Text('View Details'),
        ),
      ],
    );
  }
}


//GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 4.0,
//               mainAxisSpacing: 4.0,
//             ),
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               return GestureDetector(
//                 onTap: (){
//                   Get.to(()=> const ShowVehicleView(), arguments: snapshot.data!.docs[index]);
//                 },
//                 child: Card(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.network(
//                         snapshot.data!.docs[index]['image'],
//                         height: 100,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       eText(snapshot.data!.docs[index]['vehicleName']),
//                       eText("Model: ${snapshot.data!.docs[index]['vehicleModel']}"),
//                       eText("Rs: ${snapshot.data!.docs[index]['vehiclePrice']}"),
//                       // Text(snapshot.data!.docs[index]['vModel']),
//                       // Text(snapshot.data!.docs[index]['vColor']),
//                       // Text(snapshot.data!.docs[index]['vPrice']),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );