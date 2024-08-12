// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/app/modules/wallet/controllers/wallet_controller.dart';

import '../../../../models/user_model.dart';
import '../../../../widgets/currency_format.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../../../widgets/nav_appbar.dart';

class WebWalletView extends StatefulWidget {
  const WebWalletView({
    super.key,
  });

  @override
  State<WebWalletView> createState() => _WebWalletViewState();
}

class _WebWalletViewState extends State<WebWalletView> {
  final WalletController controller = Get.put(WalletController());

  final user = FirebaseAuth.instance.currentUser;

  // user_id is the user id of the current user

  bool? convertIntToBool(int? value) {
    if (value == null) return null;
    return value == 1;
  }

  bool? isActive;

  double totalBalanceCredit = 0;
  double totalBalanceDebit = 0;
  double totalBalance = 0;

  getCurrentTotalBalanceCredit() {
    // total credit show from statement collection where type is send and balance is added
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(user!.uid)
        .collection('statement')
        .where('type', isEqualTo: 'send')
        .get()
        .then((allCredit) {
      setState(() {
        totalBalanceCredit = allCredit.docs.fold(0, (previousValue, element) {
          return previousValue + double.parse(element['amount'].toString());
        });
      });
    });
  }

  getCurrentTotalBalanceDebit() {
    // total debit show from statement collection where type is receive and balance is deducted
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(user!.uid)
        .collection('statement')
        .where('type', isEqualTo: 'receive')
        .get()
        .then((allDebit) {
      setState(() {
        totalBalanceDebit = allDebit.docs.fold(0, (previousValue, element) {
          return previousValue + double.parse(element['amount'].toString());
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentTotalBalanceCredit();
    getCurrentTotalBalanceDebit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavAppBar(
        title: "Wallet",
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            color: Get.theme.primaryColor.withOpacity(0.1),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('sellers')
                          .doc(user!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final model =
                              UserModel.fromMap(snapshot.data!.data()!);
                          return GFCard(
                            title: GFListTile(
                              title: wText('Total Balance'),
                              subTitle: Text(
                                "PKR: ${currencyFormat(model.balance!)}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            elevation: 10,
                            color: Get.theme.scaffoldBackgroundColor,
                            padding: EdgeInsets.all(5.0),
                            image: model.image!.isEmpty
                                ? Image.asset(
                                    'assets/images/zubipay.png',
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    model.image!,
                                    height: 200.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                            showImage: true,
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    wText("Name: ${model.name}", size: 14.0),
                                    Container(
                                      height: 18.0,
                                      width: 18.0,
                                      decoration: BoxDecoration(
                                          color: model.status == 'approved'
                                              ? Colors.green
                                              : Colors.red,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        model.status == 'approved'
                                            ? Icons.check
                                            : Icons.close,
                                        color: Colors.white,
                                        size: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Divider(),
                                Row(
                                  children: [
                                    wText(
                                      "PKR: ${NumberToWord().convert(model.balance!.toInt())}",
                                      size: 12.0,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    wText("Account Number :".tr, size: 12.0),
                                    wText(
                                        "${model.phone!.substring(0, 5)}...${model.phone!.substring(model.phone!.length - 4)}"),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        return wText("Balance: \$0".tr,
                            color: Colors.white, size: 20.0);
                      }),
                  _totalCreditDebit(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildPieChart(),

                  // _buildRecentTransactions(),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            flex: 6,
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              color: Get.theme.primaryColor.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      textAlign: TextAlign.start,
                      'Transaction History',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(user!.uid)
                            .collection('statement')
                            .orderBy('created_at', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Text('Loading...'),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Card(
                                      elevation: 0.5,
                                      child: ListTile(
                                        onTap: () {
                                          _buildDetailMobile(
                                              snapshot.data!.docs[index]);
                                        },
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
                                            "${snapshot.data?.docs[index]['name']}\n"
                                            "Balance: ${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}"),
                                        subtitle: Text(
                                            'Time: ${GetTimeAgo.parse(DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()), locale: 'en')}'),

                                        //   type and amount
                                        trailing: wText(
                                          snapshot.data?.docs[index]['type'] ==
                                                  'send'
                                              ? '+${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                              : '-${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text('Loading...'),
                            );
                          }
                        }),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  void _buildDetailMobile(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transaction Detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${doc['name']}'),
              Text(
                  'Amount: ${currencyFormat(double.parse(doc['amount'].toString()))}'),
              Text(
                  'Balance: ${currencyFormat(double.parse(doc['balance'].toString()))}'),
              Text('Type: ${doc['type']}'),
              Text(
                  'Time: ${GetTimeAgo.parse(DateTime.parse(doc['created_at'].toDate().toString()), locale: 'en')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  _totalCreditDebit() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Get.theme.primaryColor.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Credit'),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  width: 125,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green,
                  ),
                  child: wText('${currencyFormat(totalBalanceCredit)}',
                      color: Colors.white),
                ),
              ),
              SizedBox(width: 40),
              Text('Total Debit'),
              SizedBox(width: 10),
              Expanded(
                child: Center(
                  child: Container(
                    width: 124,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                    child: wText(
                        // total debit count show
                        '${currencyFormat(totalBalanceDebit)}',
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  _buildPieChart() {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              titlePositionPercentageOffset: 0.5,
              badgePositionPercentageOffset: 1.8,
              borderSide: BorderSide(color: Colors.green),
              color: Colors.green,
              value: totalBalanceCredit,
              title: 'Credit',
              titleStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              radius: 50,
            ),
            PieChartSectionData(
              titlePositionPercentageOffset: 0.5,
              badgePositionPercentageOffset: 1.8,
              borderSide: BorderSide(color: Colors.red),
              color: Colors.red,
              value: totalBalanceDebit,
              title: 'Debit',
              titleStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}
