// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../shops/controllers/shops_controller.dart';

class ShowRealstate extends StatefulWidget {
  const ShowRealstate({super.key});

  @override
  State<ShowRealstate> createState() => _ShowRealstateState();
}

class _ShowRealstateState extends State<ShowRealstate> {
  final controller = Get.put(ShopsController());
  bool isShopsEmpty = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller.fetchShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: wText('Realstate'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return StreamBuilder(
        stream: controller.realStateStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Realstate found'));
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return _buildRealstateCard(snapshot.data!.docs[index]);
                });
          }
          return Center(child: Text('No Realstate found'));
        });
  }

  _buildRealstateCard(doc) {
    return GFCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      showImage: true,
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),

      title: GFListTile(
          title: Text('Realstate ${doc['realStateType']}'),
          subTitle: Text('For ${doc['realStateStatus']}'),
          icon: Icon(Icons.favorite),
      ),
      image: Image.network(doc['image']),
      content: Text('Realstate Name: ${doc['sellerName']}'),
      buttonBar: GFButtonBar(
        children: [
          // GFButton(
          //   onPressed: onTap,
          //   text: 'Scholarship',
          //   color: Colors.green,
          // ),
        ],
      ),
    );
  }
}
