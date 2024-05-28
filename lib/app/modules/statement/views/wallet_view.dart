// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import 'package:screenshot/screenshot.dart';
import 'package:wallet/app/modules/statement/views/time_statement_view.dart';
import 'package:wallet/widgets/currency_format.dart';

import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../send_money/views/send_money_view.dart';

class DigitalWalletView extends StatefulWidget {
  DigitalWalletView({super.key});

  @override
  State<DigitalWalletView> createState() => _DigitalWalletViewState();
}

class _DigitalWalletViewState extends State<DigitalWalletView> {
  final ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = false;
  final Dio dio = Dio();
  final DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  UserModel? model;

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await getUserData();
  }

  Future<void> getUserData() async {
    // get data from firebase
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .get();
    model = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // get user data
    getUserData();
    // get statement
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    // digital wallet design new one new look
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: _refresh,
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/login.png'),
                    fit: BoxFit.cover,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.blue],
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  children: [
                    // build header
                    _buildHeader(),
                    SizedBox(height: 20.0),
                    _buildBalanceCard(),
                    SizedBox(height: 10.0),
                    _buildAddSendMoneyButton(double, model),
                    _buildRecentTransactions(),
                    SizedBox(height: 20.0),
                    // discretion of user

                    _buildProfile(),

                    SizedBox(height: 20.0),
                    _buildFooter(),
                  ],
                ),
              ),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              wText(
                'Balance'.tr,
                color: Colors.white,
              ),
              // MixWidgets.buildAvatar(model!.image, 30.0),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // '₦${model!.balance}',
                "Rs: ${currencyFormat(double.parse(model!.balance.toString()))}"
                    .tr,
                style: GoogleFonts.gabriela(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Divider(),
          // balance details in words
          Row(
            children: [
              wText(
                'PKR - '.tr,
                color: Colors.white,
                size: 12.0,
              ),
              wText(
                // NumberToWord().convert(snapshot.data!['balance'].toInt()),
                NumberToWord().convert((model!.balance!.toInt())),
                color: Colors.white,
                size: 14.0,
              ),
            ],
          ),

          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              wText(
                'Account Number'.tr,
                color: Colors.white,
              ),
              wText(
                // last 0300 *** 4 digit of account number
                "${model!.phone?.substring(0, 4)} *** ${model!.phone?.substring(model!.phone!.length - 4)}",
                color: Colors.white,
                size: 12.0,
              ),
            ],
          ),
          SizedBox(height: 10.0),
        ],
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
            child: isLoading == true
                ? CircularProgressIndicator()
                : wText('Send Money'.tr , color: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              // Get.toNamed('/add-money');
              _buildDialogAddMoney();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: isLoading == true
                ? CircularProgressIndicator()
                : wText('Add Money'.tr, color: Colors.white),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.keyboard_arrow_up_outlined)
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                MixWidgets.buildAvatar(model!.image, 50.0),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    wText(
                      model!.name!,
                    ),
                    wText(
                      model!.phone!,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 10.0),
                wText(
                  model!.email!,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 10.0),
                wText(
                  'Pakistan'.tr,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.account_balance_wallet),
                SizedBox(width: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    wText('Status:  ', size: 14.0),
                    wText(
                        "${model?.status}" == 'approved'
                            ? 'Active'
                            : 'Inactive',
                        size: 14.0),
                    SizedBox(width: 10.0),
                    //    if status is approved then show green color else red color
                    Container(
                      height: 18.0,
                      width: 18.0,
                      decoration: BoxDecoration(
                          color: "${model!.status}" == 'approved'
                              ? Colors.green
                              : Colors.red,
                          shape: BoxShape.circle),
                      child: Icon(
                        "${model!.status}" == 'approved'
                            ? Icons.check
                            : Icons.close,
                        color: Colors.white,
                        size: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            //   crreat at
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 10.0),
                wText(
                  // jsut show date and time not need to show full date
                  'Created At: ${model!.createdAt!.toString().substring(0, 16)}',
                ),
              ],
            ),
          ],
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
                    wText("Recent Transactions".tr,
                         size: 18.0),
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
              isLoading == true
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
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
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Card(
                                    elevation: 12,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text(
                                            // name first letter
                                            snapshot.data?.docs[index]
                                                        ['name'] ==
                                                    null
                                                ? ''
                                                : snapshot.data
                                                    ?.docs[index]['name'][0]
                                                    .toUpperCase()),
                                      ),
                                      title: Text(
                                          snapshot.data?.docs[index]['name']),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              DateTime.parse(snapshot.data!
                                                  .docs[index]['created_at']
                                                  .toDate()
                                                  .toString()),
                                              locale: 'en')),
                                        ],
                                      ),

                                      //   type and amount
                                      trailing: wText(
                                        snapshot.data?.docs[index]['type'] ==
                                                'send'
                                            ? '+ ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                            : '- ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                                      ),
                                      onTap: (){
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
          Text("Purpose: $description",
              style: TextStyle(color: Colors.black)),
          //   phone number

          Row(
            children: [
              Text("Type: "),
              Text(type == 'send' ? 'Credit' : 'Debit',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          Text("Phone: $phone",
              style: TextStyle(color: Colors.black)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: List.generate(5, (index) {
            return Icon(
              index <= d ? Icons.star : Icons.star_border,
              color: Colors.amber,
            );
          }),
        ),
        Text('($d)',
            style: TextStyle(
              color: Colors.grey,
            )),
      ],
    );
  }
}
