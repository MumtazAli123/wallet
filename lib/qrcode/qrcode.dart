// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/user_model.dart';
import 'package:wallet/qrcode/result_screen.dart';
import 'dart:typed_data';

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
  final Dio dio = Dio();
  bool loading = false;



  void closedScanner() {
    isQrScannedCompleted = false;
  }

  Random random = new Random();
  List sounds = [
    'SEU4_Kick_31.wav',
    'SEU4_Ride_08.wav',
    'SEU4_Snare_26.wav',
    'SEU4_Tom_07.wav'
  ];
  int soundPosition = 0;
  final player = AudioPlayer();

  final ScreenshotController screenshotController = ScreenshotController();

  // qr code
  void getResultsFromFirebase() {
    if (qrResult == sharedPreferences!.getString('phone')) {
      QuickAlert.show(
          context: context,
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
        // qr code image share box size with 400x400 pixels and share the image to other apps
        onPressed: () async {
          // _captureAndSavePng();
         final image =  await screenshotController.captureFromWidget(widgetToImage());
         // await saveImage(image);
         saveAndShareImage(image);
         setState(() {
            player.play(AssetSource(sounds[soundPosition]));
         });

           
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
                player.play(AssetSource(sounds[soundPosition]));
                getResultsFromFirebase();

              });
            });
          },
          child: wText('Scan QR Code'.tr, color: Colors.white, size: 20),
        ),
      ),
      backgroundColor: Colors.white,
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
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 20.0
              ),
              Text(
                'Scan the QR code to get the details'.tr,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrImageView(
                  data: sharedPreferences!.getString('phone')!,
                  version: QrVersions.auto,
                  size: 300.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Your QR Code'.tr,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20.0,
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetToImage() {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        width: 400,
        height: 400,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List image) async {
    final result = await ImageGallerySaver.saveImage(image);
    if (result['isSuccess']) {
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          autoCloseDuration: Duration(seconds: 4),
          title: 'Success',
          text: 'Image saved successfully');
      Get.snackbar('Success', 'Image saved successfully');
    } else {
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          autoCloseDuration: Duration(seconds: 4),
          title: 'Error',
          text: 'Failed to save image');
      Get.snackbar('Error', 'Failed to save image');
    }
    return result['filePath'];
  }

  void saveAndShareImage(Uint8List bytes) async{
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/image.png');
    image.writeAsBytesSync(bytes);
    Share.shareXFiles([XFile(image.path)]);
  }
}
