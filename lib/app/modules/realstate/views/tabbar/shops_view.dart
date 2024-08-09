// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/mix_widgets.dart';
import '../../controllers/realstate_controller.dart';

class ShopsViewPage extends GetView<RealStateController> {
  const ShopsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.shopDataStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if (snapshot.data.docs.isEmpty) {
              return Center(child: Text('No Realstate found'));
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return wBuildRealstateCard(snapshot.data.docs[index]);
                });
          }
          return Center(child: Text('No Realstate found'));
        });
  }

}
