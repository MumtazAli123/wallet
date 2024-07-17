// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:like_button/like_button.dart';
import 'package:wallet/app/modules/realstate/views/tabbar/realstate_view_page.dart';

import '../../../../../models/realstate_model.dart';
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

  Widget   _buildRealstateCard(doc) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RealstateViewPage(
          rsModel: RealStateModel.fromJson(doc.data()), doc: 'apartment'));

      },
      child: GFCard(
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
          subTitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 10.0),
                Text('City: ${doc['city']}'),
              ],
            ),
          ),
          icon: LikeButton(
            countPostion: CountPostion.top,
            likeCount: doc['likeCount'] ?? 0,
            isLiked: false,
            onTap: (bool isLiked) async {
              final user = controller.user;
              if (user != null) {
                if (isLiked) {
                  await controller.removeLike(doc['realStateId'], user.uid);
                } else {
                  await controller.addLike(doc['realStateId'], user.uid);
                }
              }
              return !isLiked;
            },
          ),
        ),
        image: Image.network(doc['image']),
        content: Text('Realstate Agent: ${doc['sellerName']}'),
        buttonBar: GFButtonBar(
          children: [
            GFButton(
              onPressed: () {
                Get.to(() => RealstateViewPage(
                  rsModel: RealStateModel.fromJson(doc.data()), doc: 'apartment'));
              },
              text: 'View',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }


}

