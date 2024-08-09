// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/realstate/views/realstate_ui_desigin.dart';
import 'package:wallet/app/modules/realstate/views/upload_realstate_view.dart';
import 'package:wallet/models/realstate_model.dart';
import 'package:wallet/widgets/mix_widgets.dart';

import '../controllers/realstate_controller.dart';

class RealStateView extends GetView<RealStateController> {
  const RealStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.to(() => UploadRealstateView());
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
      title: wText('Real State'),
      centerTitle: true,
    );
  }
  _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: _buildRealStateList(),
      ),
    );
  }

  _buildRealStateList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.realStateStream(),
      builder: (context, snapshot) {
       if(snapshot.hasError){
         return const Text('Something went wrong');
       }else if(snapshot.connectionState == ConnectionState.waiting){
         return const Center(child: CircularProgressIndicator());
       }else if(snapshot.data!.docs.isEmpty){
         return const Center(child: Text('No data found'));
        }else{
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final RealStateModel model = RealStateModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return RealStateUiDesignWidget(model: model, context: context);
            },
          );
       }
      },
    );
  }

}
//  if (snapshot.hasData) {
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final RealStateModel model = RealStateModel.fromJson(
//                   snapshot.data!.docs[index].data() as Map<String, dynamic>);
//               return RealStateUiDesignWidget(model: model, context: context);
//             },
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
