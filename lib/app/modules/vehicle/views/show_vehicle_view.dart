// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/app/modules/vehicle/controllers/vehicle_controller.dart';
import 'package:wallet/app/modules/vehicle/views/upload_vehicle_view.dart';
import 'package:wallet/app/modules/vehicle/views/vehicle_edit_view.dart';
import 'package:wallet/app/modules/vehicle/views/vehicle_page_view.dart';

import '../../../../models/vehicle_model.dart';
import '../../../../widgets/mix_widgets.dart';

class ShowVehicleView extends GetView<VehicleController> {
  const ShowVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.to(() => UploadVehicleView());
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
      title: wText('Vehicle List'),
      centerTitle: true,
    );
  }

  _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: _buildVehicleList(),
      ),
    );
  }

  _buildVehicleList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.vehicleStream(),
      builder: (context, snapshot) {
        try {
         if(snapshot.hasError){
           return Center(
             child: Text('Error: ${snapshot.error}'),
           );
          }if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                VehicleModel model = VehicleModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return wBuildVehicleItem(model);
              },
            );
         }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } catch (e) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  wBuildVehicleItem(VehicleModel model) {
    return GFCard(
      // image list tile

      image: Image.network( model.image!, fit: BoxFit.cover, width: double.infinity, height: 200,),
      showImage: true,
      title: GFListTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange,
              child: wText(model.vehicleName![0], color: Colors.white),
            ),

            SizedBox(width: 4.0),
            Expanded(child: Text(model.vehicleName!)),
            SizedBox(width: 4.0),
            Expanded(child: Text("Model: ${model.vehicleModel!}")),
          ],
        ),
        subTitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                      child:
                      model.currency == "AED"
                          ? aText("${model.currency}: ${model.vehiclePrice}")
                          : aText("Rs: ${model.vehiclePrice}")
                  ),

                ],
              ),
            //   const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(child: aText("City: ${model.city}")),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(child: aText("Area: ${model.address}")),
                ],
              ),
            ],
          ),
        ),
      ),
      buttonBar: GFButtonBar(
        children: <Widget>[
          GFButton(
            onPressed: () {
              Get.to(() => VehiclePageView(
                    vModel: model,
                    doc: '',
                  ));

              //   rsModel: RealStateModel.fromJson(widget.model!.toJson()), doc: '',));
            },
            text: 'View',
            color: Colors.blue,
          ),
          GFButton(
            onPressed: () {
              Get.to(() => VehicleEditView(
                model: model,
              ));
            },
            text: 'Edit',
            color: Colors.green,
          ),
          GFButton(
            onPressed: () {
              _buildAlertDialog(model.vehicleId);
            },
            text: 'Delete',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void _buildAlertDialog(id) {
    QuickAlert.show(
        // delete dialog
        context: Get.context!,
        type: QuickAlertType.warning,
        title: 'Delete Vehicle',
        text: 'Are you sure you want to delete this vehicle?',
        width: 400,
        showConfirmBtn: false,
        widget: Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GFButton(
                  onPressed: () {
                    controller.deleteVehicle(id);
                    Get.back();
                  },
                  text: 'Delete',
                  color: Colors.red,
                ),
                GFButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: 'No',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ));
  }

}
