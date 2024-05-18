// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  String? qrResult = 'Not Yet Scanned';
  bool isQrScannedCompleted = false;

  void closedScanner() {
    isQrScannedCompleted = false;
  }

  // when the user scans the QR code, the data will be displayed in the ResultScreen data get from the firebase

  void getResultsFromFirebase() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${sharedPreferences!.getString('name')!}"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(children: <Widget>[
              Text(
                'QR Code Scanner',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Scan the QR code to get the details',
                style: TextStyle(fontSize: 15),
              ),
            ])),
            Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: QrImageView(
                    data: sharedPreferences!.getString('phone')!,
                    version: QrVersions.auto,
                    size: 300.0,
                  ),
                )),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 40),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
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
                child: wText('Scan QR Code', color: Colors.white, size: 20),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
