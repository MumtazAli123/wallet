// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import 'package:screenshot/screenshot.dart';
import 'package:wallet/app/modules/statement/views/time_statement_view.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/realstate_model.dart';

import '../../../../models/user_model.dart';
import '../../../../rating/rating_screen.dart';
import '../../../../widgets/currency_format.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../send_money/views/send_money_view.dart';
import '../controllers/home_controller.dart';

class DigitalWalletView extends StatefulWidget {
  final UserModel? model;
  DigitalWalletView({super.key, this.model});

  @override
  State<DigitalWalletView> createState() => _DigitalWalletViewState();
}

class _DigitalWalletViewState extends State<DigitalWalletView> {
  final ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = false;
  final Dio dio = Dio();
  final DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  final controller = Get.put(HomeController());

  var name = sharedPreferences!.getString('name');
  var phone = sharedPreferences!.getString('phone');
  var email = sharedPreferences!.getString('email');
  var image = sharedPreferences!.getString('image');
  var status = sharedPreferences!.getString('status');

  final date = DateTime.now();

  UserModel? model;

  Future<void> _refresh() async {
    setState(() {
      isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    // getUserData();
  }

  @override
  Widget build(BuildContext context) {
    // digital wallet design new one new look
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          height: Get.height,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/images/bg.png'),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      _buildBody(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildBody() {
    return Screenshot(
      controller: screenshotController,
      child: Column(
        children: [
          SizedBox(height: 10.0),
          _buildHeader(),
          SizedBox(height: 10.0),
          _buildBalanceCard(),
          SizedBox(height: 10.0),
          _buildAddSendMoneyButton(double, model),
          SizedBox(height: 10.0),
          _buildRecentTransactions(),
          SizedBox(height: 10.0),
          _buildProfile(),
          SizedBox(height: 10.0),

          _buildFooter(),
        ],
      ),
    );
  }

  _buildBalanceCard() {
    return Container(
      height: 230.0,
      width: 400.0,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/walleta.png'),
          fit: BoxFit.cover,
        ),
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rs.${currencyFormat(double.parse(snapshot.data!['balance'].toString()))}',
                      style: GoogleFonts.poppins(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Divider(
                        color: Colors.white),
                    wText(
                      color: Colors.white,
                     size: 14.0,
                     "PKR: ${ NumberToWord().convert(snapshot.data!['balance'].toInt())}"),
                    SizedBox(height: 20.0),
                    Text(
                      // account number first 5 digits and last 4 digits
                      'Account Number: ${snapshot.data!['phone'].toString().substring(0, 5)}****${snapshot.data!['phone'].toString().substring(snapshot.data!['phone'].toString().length - 4)}',
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),

                  ],
                ),
              ],
            );
          }
          return wText('No Data');
        },
      ),
    );
  }

  _buildAddSendMoneyButton(Type double, model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Get.to(() => SendMoneyView());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: wText('Send Money'.tr, color: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              // Get.toNamed('/add-money');
              _buildDialogAddMoney();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: wText('Add Money'.tr, color: Colors.white),
          ),
        ],
      ),
    );
  }

  _buildProfile() {
    return Card(
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MixWidgets.buildAvatar(image, 50.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      wText(
                        "Name: $name",
                      ),
                      wText(
                        // first 5 digits and last 4 digits
                        "Phone: ${phone!.substring(0, 5)}****${phone!.substring(phone!.length - 4)}",
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text(email!),
              ),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Pakistan'.tr),
              ),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text(
                    'Status: ${status == 'approved' ? 'Active' : 'Inactive'}'),
                trailing: Container(
                  height: 18.0,
                  width: 18.0,
                  decoration: BoxDecoration(
                      color: status == 'approved' ? Colors.green : Colors.red,
                      shape: BoxShape.circle),
                  child: Icon(
                    status == 'approved' ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 14.0,
                  ),
                ),
              ),
            //   created at
            //   ListTile(
            //     leading: Icon(Icons.date_range),
            //     title: Text('Created At: ${sharedPreferences!.getString('createdAt').toString().substring(0, 16)}', )
            // //     title: Text('Created At: ${ sharedPreferences!.getString('createdAt').toString().substring(0, 16)}',
            // //   ),
            //   ),
          // if platform is ios  then show created at
              if (defaultTargetPlatform == TargetPlatform.iOS)
                ListTile(
                  leading: Icon(Icons.date_range),
                  title: aText(
                    size: 14.0,
                      "Created @ ${sharedPreferences!.getString('createdAt').toString().substring(0, 16)} ")
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Powered by PaySaw Digital Wallet'.tr,
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '© ${now.year} - paysaw.com.',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Digital Wallet'.tr,
          style: GoogleFonts.gabriela(
            fontSize: 24.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {
            screenshotController
                .capture(delay: Duration(milliseconds: 10))
                .then((value) {
              Get.snackbar(
                'Screenshot Captured'.tr,
                'Screenshot has been saved to gallery'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            });
          },
          icon: Icon(Icons.camera_alt, color: Colors.white),
        ),
      ],
    );
  }

  _buildRecentTransactions() {
    final size = MediaQuery.of(Get.context!).size;
    try {
      return Container(
        height: size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    wText("Recent Transactions".tr, size: 18.0),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          Get.to(() => TimeStatementView());
                        },
                        child: wText('View All'.tr, color: Colors.blue))
                  ],
                ),
              ),
              // Divider(),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('sellers')
                      .doc(user!.uid)
                      .collection('statement')
                      .where('created_at',
                          isGreaterThanOrEqualTo: DateTime(
                              // recent transactions minimum 3 days
                              now.year,
                              now.month,
                              now.day - 3))
                      .orderBy('created_at', descending: true)
                      .limit(5)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Card(
                              elevation: 12,
                              child: ListTile(
                                leading: MixWidgets.buildAvatar(
                                    // get user image from firebase
                                    isLoading == true
                                        ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                                        : snapshot.data?.docs[index]['image']
                                            .toString(),
                                    20.0),
                                title: Text(snapshot.data?.docs[index]['name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // balance type cr or dr
                                    Row(
                                      children: [
                                        Text(
                                            // amount
                                            snapshot.data?.docs[index]
                                                        ['type'] ==
                                                    'send'
                                                ? 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'
                                                : 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'),
                                        SizedBox(width: 10.0),
                                        Text(snapshot.data?.docs[index]
                                                    ['type'] ==
                                                'send'
                                            ? 'Cr'
                                            : 'Dr'),
                                      ],
                                    ),
                                    Text(GetTimeAgo.parse(
                                        DateTime.parse(snapshot
                                            .data!.docs[index]['created_at']
                                            .toDate()
                                            .toString()),
                                        locale: 'en')),
                                  ],
                                ),

                                //   type and amount
                                trailing: wText(
                                  snapshot.data?.docs[index]['type'] == 'send'
                                      ? '+ ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                      : '- ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                                ),
                                onTap: () {
                                  _buildDialog(
                                    snapshot.data?.docs[index]['name'],
                                    snapshot.data?.docs[index]['amount'],
                                    snapshot.data?.docs[index]['type'],
                                    snapshot.data?.docs[index]['created_at']
                                        .toDate()
                                        .toString(),
                                    snapshot.data?.docs[index]['phone'],
                                    snapshot.data?.docs[index]['description'],
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return wText('No Transactions');
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

  }

  void _buildDialog(name, amount, type, date, phone, description) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.values[3],
      title: "$name",
      text: "Transaction Details",
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          wText(
            color: Colors.black,
            "Amount: ${currencyFormat(double.parse(amount.toString()))}",
          ),
          Text("Purpose: $description", style: TextStyle(color: Colors.black)),
          //   phone number

          Row(
            children: [
              Text("Type: "),
              Text(type == 'send' ? 'Credit' : 'Debit',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          Text("Phone: $phone", style: TextStyle(color: Colors.black)),
          Text(
            '$date',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      cancelBtnText: "Close".tr,
      showConfirmBtn: false,
    );
  }

  void _buildDialogAddMoney() {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.info,
      title: 'Add Money',
      text: 'We are working on this feature',
    );
  }
}

class MixWidgets {
  static buildAvatar(String? image, double size) {
    return CircleAvatar(
      radius: size,
      backgroundImage: NetworkImage(image!),
    );
  }

  static buildRatingStars(double d) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(5, (index) {
        //     return Icon(
        //       index <= d ? Icons.star : Icons.star_border,
        //       color: Colors.amber,
        //     );
        //   }),
        // ),
        GFRating(
          color: Colors.amber,
            onChanged: (value) {
              Get.to(() => RatingScreen(
                sellerId: FirebaseAuth.instance.currentUser!.uid,
                model: RealStateModel(),
              ));
            },
            value: d,
        ),
        Text('($d)',
            style: TextStyle(
              color: Colors.grey,
            )),
      ],
    );
  }

  static loading() {
    return Center(
      child: Text('Loading...'),
    );
  }

  static emptyData() {
    return Center(
      child: Text('No Data'),
    );
  }


}
