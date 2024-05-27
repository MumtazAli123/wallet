// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:screenshot/screenshot.dart';

import '../../../../widgets/mix_widgets.dart';

class DialogView extends StatefulWidget {
  final QueryDocumentSnapshot data;

  const DialogView({super.key, required this.data});

  @override
  State<DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<DialogView> {
  final ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = false;
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: isLoading
                  ? CircularProgressIndicator()
                  : wText('Share Image', color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {},
              child: isLoading
                  ? CircularProgressIndicator()
                  : wText('Save Image', color: Colors.white),
            ),
          ],
        ),
      ),
      body: _buildBody(),
      appBar: AppBar(
        title: wText('Transaction Details'),
        centerTitle: true,
      ),
    );
  }

  _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Screenshot(
            controller: screenshotController,
            child: AnimatedContainer(
              padding: EdgeInsets.all(20),
              duration: Duration(seconds: 1),
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 255, 0, 255),
                    Color.fromARGB(255, 255 , 0, 0),
                    Colors.black,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Center(
                    child: wText('${widget.data['name']}',
                        color: Colors.white, size: 20),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.white),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      wText('Amount :', color: Colors.white),
                      wText('${widget.data['amount']}', color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      wText('Type :', color: Colors.white),
                      wText('${widget.data['type']}', color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 20),
                  // description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      wText('Purpose :', color: Colors.white),
                      wText('${widget.data['description']}',
                          color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 20),
                  // phone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      wText('Phone :', color: Colors.white),
                      wText('${widget.data['phone']}', color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      wText('Time :', color: Colors.white),
                      Text(
                        'Time: ${GetTimeAgo.parse(DateTime.parse(widget.data['created_at'].toDate().toString()), locale: 'en')}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      wText('Date :', color: Colors.white),
                      Text(
                        //   gate date time just date and time only without timezone
                        'Date: ${DateTime.parse(widget.data['created_at'].toDate().toString()).toString().substring(0, 16)}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
