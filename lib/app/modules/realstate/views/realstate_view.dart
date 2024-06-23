// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/realstate/views/upload_realstate_view.dart';
import 'package:wallet/global/global.dart';
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
    );
  }

  _buildBody() {
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.offAllNamed('/home');
                  },
                ),
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Real State"),
                  background: Image.network(
                    "${sharedPreferences!.getString('image')}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: _buildRealStateList()),
    );
  }

  _buildRealStateList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.realStateStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final RealStateModel model = RealStateModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return HotelsUiDesignWidget(model: model, context: context);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  HotelsUiDesignWidget(
      {required RealStateModel model, required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: controller.isUpLoading.isTrue
            ? Colors.grey.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(model.image.toString()),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  controller.deleteRealState(model.realStateId.toString());
                  controller.realStateList.remove(model);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.orange,
                ),
                title: aText(model.realStateType.toString(), size: 20),
                subtitle: aText(model.condition.toString(), size: 16),
                trailing: aText(model.description.toString(), size: 16),
              ),
              ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.orange,

                ),
                title: aText(model.city.toString(), size: 20),
                trailing: aText(model.state.toString(), size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
