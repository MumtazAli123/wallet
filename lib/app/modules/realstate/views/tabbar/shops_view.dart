// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

import '../../controllers/realstate_controller.dart';

class ShopsViewPage extends GetView<RealStateController> {
  const ShopsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.shopDataStream(),
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
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      title: GFListTile(
        title: Row(
          children: [
            controller.user!.photoURL != null
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
        subTitle: Text(doc['realStateName']),
      ),
      content: Text(doc['realStateDescription']),
      buttonBar: GFButtonBar(
        children: [
          GFButton(
            onPressed: () {
              Get.toNamed('/realstate/edit_realstate', arguments: doc);
            },
            text: 'Edit',
            icon: Icon(Icons.edit),
          ),
          GFButton(
            onPressed: () {
              controller.deleteRealState(doc.id);
            },
            text: 'Delete',
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      image: Image.network(
        doc['realStateImageUrl'],
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      ),
    );
  }
}
