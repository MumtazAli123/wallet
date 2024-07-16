// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/mix_widgets.dart';
import '../../controllers/realstate_controller.dart';

class AllRealstate extends StatefulWidget {
  const AllRealstate({super.key});

  @override
  State<AllRealstate> createState() => _AllRealstateState();
}

class _AllRealstateState extends State<AllRealstate> {
  final controller = Get.put(RealStateController());
  bool isShopsEmpty = false;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    // controller.houseDataStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: controller.allStateStream(),
          builder: (context, AsyncSnapshot snapshot) {
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
          }
      ),

    );
  }
}

