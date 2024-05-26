// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/user_model.dart';
import 'package:wallet/qrcode/result_screen.dart';

import '../widgets/mix_widgets.dart';

class QrcodePage extends StatefulWidget {
  const QrcodePage({super.key});

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  String? qrData;
  String scanQrCode = '';
  String? qrResult = 'Not Yet Scanned'.tr;
  bool isQrScannedCompleted = false;

  void closedScanner() {
    isQrScannedCompleted = false;
  }

 final ScreenshotController screenshotController = ScreenshotController();


  // when the user scans the QR code, the data will be displayed in the ResultScreen data get from the firebase

  void getResultsFromFirebase() {
    if (qrResult == sharedPreferences!.getString('phone')) {
      QuickAlert.show(context: context,
          type: QuickAlertType.error,
          autoCloseDuration: Duration(seconds: 4),
          title: 'Error',
      text: 'You cannot scan your own QR code');
      Get.snackbar('Error', 'You cannot scan your own QR code');
    } else {
      FirebaseFirestore.instance
          .collection('sellers')
          .where('phone', isEqualTo: qrResult)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          UserModel userModel =
              UserModel.fromMap(doc.data() as Map<String, dynamic>);
          Get.to(ResultScreen(
            userModel: userModel,
            qrData: '',
          ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        //
      // final image = await screenshotController.captureFromWidget(widgetToImage());
    // Share.shareXFiles([XFile.fromData(image)]);
    // Share.share('Check out this QR code', subject: 'QR Code', sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100));
    // if (image != null) {
    //   print('Image saved to gallery');
    // }
        onPressed: () async{
           // qrcode image share  to other apps
          final image = await screenshotController.captureFromWidget(widgetToImage());
          Share.shareXFiles([XFile.fromData(image)], text: 'Check out this QR code', subject: 'QR Code', sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100));
          if (image != null) {
            print('Image saved to gallery');
          }
        },
        child: Icon(Icons.share),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 60, right: 60, bottom: 40),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            FlutterBarcodeScanner.scanBarcode(
                '#ff6666', 'Cancel', true, ScanMode.QR)
                .then((value) {
              setState(() {
                qrResult = value;
                isQrScannedCompleted = true;
                getResultsFromFirebase();
              });
            });
          },
          child: wText('Scan QR Code'.tr, color: Colors.white, size: 20),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome".tr, style: TextStyle(color: Colors.black, fontSize: 20),),
            SizedBox(width: 10,),
            wText(sharedPreferences!.getString('name')!.tr),
    ],
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'QR Code Scanner'.tr,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Scan the QR code to get the details'.tr,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 50.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrImageView(
                  data: sharedPreferences!.getString('phone')!,
                  version: QrVersions.auto,
                  size: 300.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetToImage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: QrImageView(
              data: sharedPreferences!.getString('phone')!,
              version: QrVersions.auto,
              size: 300.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Scan the QR code to get the details'.tr,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

}
