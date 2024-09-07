// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/models/realstate_model.dart';

import '../app/modules/realstate/views/tabbar/realstate_view_page.dart';
import '../app/modules/register/controllers/register_controller.dart';
import '../rating/show_rating_screen.dart';

bool isRating = false;

bool isLoading = false;
wText(String text, {Color? color, double size = 16}) {
  return Text(
    maxLines: 1,

    textAlign: TextAlign.center,
    text,
    style: GoogleFonts.quando(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

eText(String text, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.only(left: 4.0),
    child: Text(

      text,
      style: TextStyle(color: color, fontSize: 16),

    ),
  );
}
rText(String text, {Color? color, double? size}){
  return Padding(
    padding: const EdgeInsets.only(left: 4.0,top: 3.0),
    child: Text(
      maxLines: 1,
      text,
      style: GoogleFonts.aBeeZee(
          color: color, fontSize: size,
        fontWeight: FontWeight.bold
      ),

    ),
  );
}

aText(String text, {Color? color, double size = 16}) {
  return Text(
      maxLines: 1,
      text,
      style: GoogleFonts.quando(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ));
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
      Color? color,
    required Null Function() onPressed}) {
  return Container(
    width: width.toDouble(),
    padding: const EdgeInsets.all(10),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,
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
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Text(
      textAlign: TextAlign.start,
      text,
      style: GoogleFonts.habibi(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    ),
  );
}

wButton(String text, Color color, { double size = 16, Function()? onPressed}) {
  // return GestureDetector(
  //   onTap: onPressed,
  //   child: isLoading
  //       ? const CircularProgressIndicator()
  //       : Container(
  //           alignment: Alignment.center,
  //           width: 250,
  //           height: 50,
  //           padding: const EdgeInsets.all(8.0),
  //           decoration: BoxDecoration(
  //             color: color,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: wText(
  //             text,
  //             color: Colors.white,
  //             size: 20,
  //           ),
  //         ),
  // );
  return GFButton(
      onPressed: onPressed,
      text: text,
      highlightColor: Colors.red,
      color: color,
      hoverColor: Colors.green,
      borderShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      type: GFButtonType.solid,
      size: size,
      textStyle:  GoogleFonts.salsa(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),);

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

urlLauncherA(String url) {
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
      elevation: 5,
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
        height: 250,
        width: double.infinity,
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
            onChanged: (value) {
              Get.to(() => ShowRatingScreen(
                    sellerId: doc['sellerId'],
                    model: RealStateModel.fromJson(doc.data()),
                  ));
            },
            value: 3.5,
          ),
        ],
      ),
    ),
  );
}

void wBuildLanguageBottomSheet(BuildContext context) {
  Get.bottomSheet(
    Container(
      height: Get.height * 0.5,
      width: 600,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choose Language'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                  var locale = const Locale('en', 'US');
                  Get.updateLocale(locale);
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      wText('English'.tr, color: Colors.white),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  // arabic
                  var locale = const Locale('sd', 'PK');
                  Get.updateLocale(locale);
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      wText('Sindhi'.tr, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                  // hindi
                  var locale = const Locale('hi', 'IN');
                  Get.updateLocale(locale);
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      wText('Hindi'.tr, color: Colors.white),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  // arabic
                  var locale = const Locale('ar', 'SA');
                  Get.updateLocale(locale);
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      wText('Arabic'.tr, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

wTextField(
    {required TextEditingController controller,
    required String keyboardType,
    required String labelText,
    required String hintText,
    required IconData prefixIcon}) {
  return TextField(
    controller: controller,
    inputFormatters: [
      RegisterController.textUpperCaseTextFormatter(),
    ],

    // keyboardType: when number show done on keyboard
    keyboardType:
        keyboardType == "number" ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

void wGetSnackBar(String title, String text, {Color? color}) {
  Get.snackbar(title, text,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white);
}


