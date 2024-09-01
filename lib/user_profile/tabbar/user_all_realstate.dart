import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../app/modules/realstate/controllers/realstate_controller.dart';
import '../../app/modules/realstate/views/tabbar/realstate_view_page.dart';
import '../../global/global.dart';
import '../../models/realstate_model.dart';
import '../../widgets/mix_widgets.dart';

class MyAllRealState extends GetView<RealStateController> {
  const MyAllRealState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("sellers")
          .doc(sharedPreferences!.getString('uid'))
          .collection('realState')
          .snapshots(),
      builder: (context, snapshot) {
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
              child: Text('No Real State Found'),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 0.9,

            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return wMyRealStateCard(data);
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

  Widget wMyRealStateCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        _buildDialog(data);
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
            const SizedBox(height: 5),
            Text(
              data['realStateType'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // for sale
            eText(
              "For ${data['realStateStatus']}",
            ),
            data["currency"] == "AED"
                ? eText("${data["currency"]}: ${data['startingFrom']}")
                : eText("Rs: ${data['startingFrom']}"),
          ],
        ),
      ),
    );
  }

  void _buildDialog(Map<String, dynamic> data) {
    Get.defaultDialog(
      title: data['realStateType'],
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
          const SizedBox(height: 5),
          eText("For ${data['realStateStatus']}"),
          data["currency"] == "AED"
              ? eText("${data["currency"]}: ${data['startingFrom']}")
              : eText("Rs: ${data['startingFrom']}"),
          eText("Location: ${data['city']}"),
          eText("Area: ${data['address']}"),
          eText("Description: ${data['description']}"),
          const SizedBox(height: 20.0),
        //   button
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child:  eText('Close', color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.to(() =>   RealstateViewPage(
                        doc: "",
                        rsModel: RealStateModel.fromJson(data),
                      ), arguments: data);
                    },
                    child:  eText('View', color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
