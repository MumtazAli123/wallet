// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/models/realstate_model.dart';

import '../app/modules/realstate/views/tabbar/realstate_view_page.dart';

bool isLoading = false;
wText(String text, {Color? color, double size = 16}) {
  return Text(
    textAlign: TextAlign.center,
    text,
    style: GoogleFonts.gabriela(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

eText(String s, {required Color color}) {
  return Text(
    s,
    style: TextStyle(color: color),
  );
}

aText(String text, {Color? color, double size = 16}) {
  return Text(
    text,
    style: GoogleFonts.gabriela(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

wTitleMedium({required String title, required String subtitle}) {
  return Column(
    children: [
      Text(
        title,
        style: GoogleFonts.daiBannaSil(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    ],
  );
}

wCustomButton(
    {required int width,
    required String text,
    required IconData icon,
    required Null Function() onPressed}) {
  return Container(
    width: width.toDouble(),
    padding: const EdgeInsets.all(10),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(
            width: 10,
          ),
          wText(text, color: Colors.white),
        ],
      ),
    ),
  );
}

wAppLoading(BuildContext context) {
  return const SimpleDialog(
    children: [
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 10,
            ),
            Text("Uploading..."),
          ],
        ),
      ),
    ],
  );
}

wLinearProgressBar(BuildContext context) {
  return const LinearProgressIndicator(
    backgroundColor: Colors.red,
  );
}

cText(String text, {Color? color, double size = 16}) {
  return Text(
    textAlign: TextAlign.start,
    text,
    style: GoogleFonts.paprika(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

wButton(String text, {Color? color, double size = 16, Function()? onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: isLoading
        ? const CircularProgressIndicator()
        : Container(
            alignment: Alignment.center,
            width: 250,
            height: 50,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: wText(
              text,
              color: Colors.white,
              size: 20,
            ),
          ),
  );
}

urlLauncher(String imgPath, String url, String title) {
  return Container(
    width: 80,
    height: 80,
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print('Could not launch $url');
        }
      },
      child: Column(
        children: [
          Image.asset(
            imgPath,
            width: 40,
            height: 40,
          ),
          wText(title, size: 10, color: Colors.black),
        ],
      ),
    ),
  );
}
urlLauncherA(String url){
  return GestureDetector(
    onTap: () async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: wText("View", color: Colors.white),
    ),
  );

}


wBuildRealstateCard(doc) {
  return GestureDetector(
    onTap: () {
      Get.to(() => RealstateViewPage(
          rsModel: RealStateModel.fromJson(doc.data()), doc: 'apartment'));

      // Get.to(() => RealstateViewPage(rsModel: RealStateModel.fromJson(doc.data())));
    },
    child: GFCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      semanticContainer: true,
      showImage: true,
      // showOverlayImage: true,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      title: GFListTile(
        title: Row(
          children: [
            GFAvatar(
              size: 14,
              child: Center(child: Text("${doc['realStateType'][0]}")),
            ),
            SizedBox(
              width: 10,
            ),
            Text("${doc['realStateType']} For" " ${doc['realStateStatus']}"),
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
          // likeCount:
          isLiked: false,
        ),
      ),
      image: Image.network(
        doc['image'],
        fit: BoxFit.cover,
      ),
      boxFit: BoxFit.cover,

      content: Text('Realstate Agent: ${doc['sellerName']}'),
      buttonBar: GFButtonBar(
        alignment: WrapAlignment.start,
        children: [
          GFRating(
            size: 30,
            color: Colors.amber,
            onChanged: (value) {},
            value: 3.5,
          ),
        ],
      ),
    ),
  );
}
