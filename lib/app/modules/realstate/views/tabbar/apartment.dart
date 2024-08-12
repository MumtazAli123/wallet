// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/mix_widgets.dart';
import '../../controllers/realstate_controller.dart';

class Apartment extends StatefulWidget {
  const Apartment({super.key});

  @override
  State<Apartment> createState() => _ApartmentState();
}

class _ApartmentState extends State<Apartment> {
  final controller = Get.put(RealStateController());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.apartmentDataStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if (snapshot.data.docs.isEmpty) {
              return Center(child: Text('No Realstate found'));
            }
            return ListView.builder(
              controller: ScrollController(),
              // scrollDirection: Axis.vertical,
              reverse: true,
              shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return wBuildRealstateCard(snapshot.data.docs[index]);
                });
          }
          return Center(child: Text('No Realstate found'));
        });
  }

}

