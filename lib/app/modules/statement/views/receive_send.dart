// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet/app/modules/statement/views/statement_view.dart';
import 'package:wallet/global/global.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/statement_controller.dart';

class ReceiveSendMoney extends StatefulWidget {
  const ReceiveSendMoney({super.key});

  @override
  State<ReceiveSendMoney> createState() => _ReceiveSendMoneyState();
}

class _ReceiveSendMoneyState extends State<ReceiveSendMoney> {
  final controller = Get.put(StatementController());
  String? uid = fAuth.currentUser!.uid;
  final user = fAuth.currentUser;

  late var date = DateTime.now();
  final ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = false;
  final Dio dio = Dio();
  // bool loading = false;

  Future<void> getStatement(String query, {required date, String? uid}) async {
    final searchList = List.empty(growable: true);
    if (query.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(uid)
          .collection('statement')
          .where('created_at', isEqualTo: query)
          .get()
          .then((value) => searchList.add(value.docs));
    } else {
      searchList.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    //   isLoading = true load CircularProgressIndicator for 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Get.to(() => StatementView());
              },
            ),
          ],
          title: wText(
            sharedPreferences!.getString('name')!.length > 10
                ? '${sharedPreferences!.getString('name')!.substring(0, 10)}\'s Statement'
                    .tr
                : sharedPreferences!.getString('name')! + '\'s Statement'.tr,
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Receive'.tr),
              Tab(text: 'Send'.tr),

            ],
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return TabBarView(children: [
      _buildSendViewWeek('send'),
      _buildReceiveViewToday('receive'),

    ]);
  }

  wTextButton(String substring, void Function() showDatePicker) {
    return TextButton(
      onPressed: showDatePicker,
      child: Text(substring),
    );
  }

  _buildReceiveViewToday(String s) {
    return StreamBuilder(
      // date wise show data type receive
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(sharedPreferences?.getString('uid'))
                .collection('statement')
                .where('type', isEqualTo: s)
                .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0),
                      child: Card(
                        elevation: 2.5,
                        child: ListTile(
                          onTap: () {
                            _buildDetailMobile(data);
                          },
                          leading: CircleAvatar(
                            child: Text(data['name'][0]),
                          ),
                          title: aText(data['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // balance
                              Row(
                                children: [
                                  Text(
                                      // amount
                                      snapshot.data?.docs[index]['type'] ==
                                              'send'
                                          ? 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'
                                          : 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'),
                                  SizedBox(width: 10.0),
                                  Text(snapshot.data?.docs[index]['type'] ==
                                          'send'
                                      ? 'Cr'
                                      : 'Dr'),
                                ],
                              ),
                              Text(
                                GetTimeAgo.parse(
                                    DateTime.parse(
                                        data['created_at'].toDate().toString()),
                                    locale: 'en'),
                                style: GoogleFonts.gabriela(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          trailing: aText(
                            snapshot.data?.docs[index]['type'] == 'send'
                                ? '+${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                : '-${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
  }

  _buildSendViewWeek(String s) {
    //  show data today from firestore
    return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(sharedPreferences?.getString('uid'))
                .collection('statement')
                .where('type', isEqualTo: s)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0),
                      child: Card(
                        elevation: 2.5,
                        child: ListTile(
                          onTap: () {
                            _buildDetailMobile(data);
                          },
                          leading: CircleAvatar(
                            child: Text(data['name'][0]),
                          ),
                          title: aText(data['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GetTimeAgo.parse(
                                    DateTime.parse(
                                        data['created_at'].toDate().toString()),
                                    locale: 'en'),
                                style: GoogleFonts.gabriela(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          trailing: aText(
                            snapshot.data?.docs[index]['type'] == 'send'
                                ? '+${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                : '-${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
  }

  _buildDetailMobile(param0) {
    MediaQuery.of(context).size.width < 600;
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.values[3],
      title: "${param0['name'.tr]}",
      text: 'Detail of the transaction',
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          wText(
            'Amount: ${currencyFormat(double.parse(param0['amount'].toString()))}',
            color: Colors.black,
          ),
          Text(
            'Type: ${param0['type'] == 'send' ? 'Credit' : 'Debit'}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            // description
            'Purpose: ${param0['description'] ?? 'No Description'}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            param0['phone'] == null
                ? 'Phone: Not Available'
                : 'Phone: ${param0['phone']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            'Time: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            //   gate date time just date and time only without timezone
            'Date: ${DateTime.parse(param0['created_at'].toDate().toString()).toString().substring(0, 16)}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    final image = await screenshotController
                        .captureFromWidget(widgetToImage(param0));
                    // await saveImage(image);
                    saveAndShareImage(image);
                  },
                  icon: Icon(Icons.share)),
            ],
          ),
        ],
      ),
      cancelBtnText: 'Close',
      //     cancel btn false
      showConfirmBtn: false,
    );
  }

  currencyFormat(double parse) {
    return parse.toStringAsFixed(2);
  }

  Widget widgetToImage(param0) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        // screen shot container
        width: 500,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.black,
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // QuickAlert.show dialog screen shot
              child: AnimatedContainer(
                padding: EdgeInsets.all(20),
                duration: Duration(seconds: 1),
                height: 350,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Center(
                      child: wText('${param0['name']}',
                          color: Colors.white, size: 20),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.white),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wText('Amount :', color: Colors.white),
                        wText('${param0['amount']}', color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wText('Type :', color: Colors.white),
                        wText(param0['type'] == 'send' ? 'Credit' : 'Debit',
                            color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    // description
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wText('Purpose :', color: Colors.white),
                        wText('${param0['description']}', color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    // phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wText('Phone :', color: Colors.white),
                        wText('${param0['phone']}', color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wText('Time :', color: Colors.white),
                        Text(
                          'Time: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}',
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
                          'Date: ${DateTime.parse(param0['created_at'].toDate().toString()).toString().substring(0, 16)}',
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
            SizedBox(
              height: 20,
            ),
            Text(
              // "Data to get the details".tr,
              'Details of the transaction'.tr,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void saveAndShareImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/image.png');
    image.writeAsBytesSync(bytes);
    Share.shareXFiles([XFile(image.path)]);
  }
}
