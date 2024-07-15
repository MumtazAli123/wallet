// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:quickalert/quickalert.dart';

import '../../controllers/realstate_controller.dart';

class OfficesView extends GetView<RealStateController> {
  const OfficesView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.officeDataStream(),
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
                  return _buildRealstateCard(snapshot.data.docs[index]);
                });
          }
          return Center(child: Text('No Realstate found'));
        });
  }

  Widget _buildRealstateCard(doc) {
    return GFCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      semanticContainer: true,
      showImage: true,
      image: Image.network(doc['image']),
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      title: GFListTile(
        title: Row(
          children: [
            controller.countryValue.value == 'India'
                ? GFAvatar(
                    backgroundImage: NetworkImage(controller.user!.photoURL!),
                  )
                : GFAvatar(
                    size: 15,
                    child: Text("${doc['realStateType'][0]}"),
                  ),
            SizedBox(width: 10.0),
            Text(doc['realStateType'] + ' For ' + doc['realStateStatus'])
          ],
        ),
        subTitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(doc['description']),
        ),
      ),
      buttonBar: GFButtonBar(
        children: <Widget>[
          GFButton(
            onPressed: () {
              Get.toNamed('/realstate-detail', arguments: doc);
            },
            text: 'View',
            color: Colors.blue,
          ),
          GFButton(
            onPressed: () {
              Get.toNamed('/realstate-edit', arguments: doc);
            },
            text: 'Edit',
            color: Colors.green,
          ),
          GFButton(
            onPressed: () {
             _buildAlertDialog(doc.id);
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
        title: 'Delete Realstate',
        text: 'Are you sure you want to delete this realstate?',
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
                  controller.deleteRealState(id);
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
      )

    );
  }
}
