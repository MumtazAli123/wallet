// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/models/user_model.dart';

import '../widgets/mix_widgets.dart';

class ResultScreen extends StatefulWidget {
  final String? qrData;
  final UserModel userModel;

   const ResultScreen({super.key, required this.qrData, required this.userModel});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  String? qrData;
  String scanQrCode = '';
  String? qrResult = 'Not Yet Scanned';
  bool qrScanned = false;

  // result screen




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Qr Code'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Scanned Qr Code'),
          Container(
            padding: EdgeInsets.all(10),
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: NetworkImage(widget.userModel.image!),
                      fit: BoxFit.cover,
                    ),
                  ),

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: QrImageView(
                        data: "${widget.userModel.phone}",
                        version: QrVersions.auto,
                        size: 80.0,
                      ),
                    ),
                    wText('Name: ${widget.userModel.name}'),
                    Text('Phone: ${widget.userModel.phone}'),
                    Text('Email: ${widget.userModel.email}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
