// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/widgets/currency_format.dart';

import '../../../../models/balance.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../home/controllers/home_controller.dart';
import '../../send_money/views/send_money_view.dart';
import '../../statement/views/time_statement_view.dart';

class WalletView extends GetView {
  WalletView({super.key});


  @override
  final controller = Get.put(HomeController());
  final DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  UserModel? model;

  var isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${'Wallet'.tr} ${'Balance'.tr}",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    return Column(
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
                model = UserModel.fromMap(snapshot.data!.data()!);
                return GFCard(
                  elevation: 10,
                  color: Get.theme.scaffoldBackgroundColor,
                  padding: EdgeInsets.all(5.0),
                  image: Image.network("${model!.image}", fit: BoxFit.cover,
                    height: 200.0,
                    width: double.infinity,),
                  showImage: true,
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          wText("Name: ${model!.name}", size: 14.0),

                          Container(
                            height: 18.0,
                            width: 18.0,
                            decoration: BoxDecoration(
                                color: model!.status == 'approved'
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle),
                            child: Icon(
                              model!.status == 'approved'
                                  ? Icons.check
                                  : Icons.close,
                              color: Colors.white,
                              size: 14.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      wText("Balance".tr, size: 18.0),
                      wText("Rs: ${model!.balance}", size: 30.0),
                      Divider(),
                      Row(
                        children: [
                          wText(
                            "PKR: ${NumberToWord().convert(model!.balance!.toInt())}",
                            size: 12.0,
                          ),

                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          wText("Account Number :".tr, size: 12.0),
                          wText(
                              "${model!.phone!.substring(0, 5)}...${model!
                                  .phone!.substring(model!.phone!.length - 4)}"),
                        ],
                      ),
                    ],
                  ),
                ).animate(

                ).fadeIn().slide(
                  duration: const Duration(seconds: 5),
                ).rotate(
                  delay: Duration(seconds: 8),
                  duration: const Duration(seconds: 8),
                );
              }
              return wText("Balance: \$0".tr,
                  color: Colors.white, size: 20.0);
            }),
        _buildAddSendMoneyButton(double, model),
        SizedBox(
          height: 20.0,
        ),
        _buildRecentTransactions(),
      ],
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
            child: controller.isLoading.value
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
            child: controller.isLoading.value
                ? CircularProgressIndicator()
                : wText('Add Money'.tr, color: Colors.white),
          ),
        ],
      ),
    );
  }

  _buildRecentTransactions() {
    final size = MediaQuery.of(Get.context!).size;
    try {
      return Container(
        width: 600,
        height: size.height * 0.4,

        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  wText("Recent Transactions".tr,
                      color: Colors.black, size: 18.0),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => TimeStatementView());
                      },
                      child: wText('View All'.tr, color: Colors.blue))
                ],
              ),
            ),
            Divider(),
            controller.isLoading.value
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Card(
                            elevation: 0.5,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  // name first letter
                                    snapshot.data?.docs[index]['name'] ==
                                        null
                                        ? ''
                                        : snapshot
                                        .data?.docs[index]['name'][0]
                                        .toUpperCase()),
                              ),
                              title: Text(snapshot.data?.docs[index]['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // balance type cr or dr
                                  Row(
                                    children: [

                                      Text(
                                        // amount
                                          snapshot.data?.docs[index]['type'] ==
                                              'send'
                                              ? 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'
                                              : 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'),
                                      SizedBox(width: 10.0),
                                      Text(
                                          snapshot.data?.docs[index]['type'] ==
                                              'send'
                                              ? 'Cr'
                                              : 'Dr'),
                                    ],
                                  ),
                                  Text(
                                      GetTimeAgo.parse(DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()), locale: 'en')
                                  ),

                                ],
                              ),

                              //   type and amount
                              trailing: wText(
                                snapshot.data?.docs[index]['type'] == 'send'
                                    ? '+ ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                    : '- ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                              ),
                              onTap: () {
                                _buildDetailDialog(
                                    context,
                                    BalanceModel(
                                      name: snapshot.data?.docs[index]
                                      ['name'.tr],
                                      description: snapshot
                                          .data?.docs[index]['description'.tr],
                                      amount: snapshot.data?.docs[index]
                                      ['amount'.tr],
                                      phone: snapshot.data?.docs[index]
                                      ['phone'.tr],
                                      type: snapshot.data?.docs[index]
                                      ['type'.tr],
                                      created_at:
                                      'Time: ${GetTimeAgo.parse(DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()), locale: 'en')}'
                                          '\nDate: ${DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()).toString().substring(0, 16)}',
                                    ));
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
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _buildFooter() {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      color: Colors.blue,
      // about wallet 10% of the height of the screen
      child: SizedBox(
        height: 100,
        child:  Column(
          children: [
            wText(
              'Powered by ZubiPay Digital Wallet'.tr,
              color: Colors.white,
            ),
            SizedBox(height: 10.0),
            wText(
              '© ${now.year} - ZubiPay Digital Wallet.',
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _buildDetailDialog(BuildContext context, BalanceModel model) {
    if (isMobile(context)) {
      _buildDetailMobile(context, model);
    } else {
      _buildDetailDesktop(context, model);
    }
  }

  isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  _buildDetailMobile(BuildContext context, BalanceModel model) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.values[3],
      title: model.name,
      text: "Details",
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          wText(
            color: Colors.black,
            "Amount: ${model.type == 'send' ? '+${currencyFormat(double.parse(model.amount.toString()))}' : '- ${currencyFormat(double.parse(model.amount.toString()))}'}",
          ),
          Text("Purpose: ${model.description}",
              style: TextStyle(color: Colors.black)),
          //   phone number

          Text("Type: ${model.type == 'send' ? 'Credit' : 'Debit'}",
              style: TextStyle(color: Colors.black)),
          Text("Phone: ${model.phone}",
              style: TextStyle(color: Colors.black)),
          Text(
            '${model.created_at}',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      cancelBtnText: "Close".tr,
      showConfirmBtn: false,
    );

  }

  _buildDetailDesktop(BuildContext context, BalanceModel model) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(model.name ?? ''),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Amount: ${model.amount}"),
                Text(model.type == 'credit' ? 'Credit' : 'Debit'),
                Text("Purpose: ${model.description}"),
                Text("Type: ${model.type}"),
                Text("Phone: ${model.phone}"),
                //   date
                Text(
                  '${model.created_at}',
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'))
            ],
          );
        });
  }

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  void _buildDialogAddMoney() {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.info,
      title: 'Add Money',
      text: 'We are working on this feature',
    );
  }

  _buildContent() {
    return Container(
      alignment: Alignment.center,
      height: 200,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('sellers')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    wText(
                        "Name: ${snapshot.data!['name']}",
                        color: Colors.white,
                        size: 20.0),
                    wText(
                        "Email: ${snapshot.data!['email']}",
                        color: Colors.white,
                        size: 20.0),
                    wText(
                        "Phone: ${snapshot.data!['phone']}",
                        color: Colors.white,
                        size: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        wText('Status:  ', color: Colors.white, size: 20.0),
                        wText(
                            "${snapshot.data!['status']}" == 'approved' ? 'Active' : 'Inactive',
                            color: Colors.white,
                            size: 20.0),
                        SizedBox(width: 10.0),
                        //    if status is approved then show green color else red color
                        Container(
                          height: 18.0,
                          width: 18.0,
                          decoration: BoxDecoration(
                              color: snapshot.data!['status'] == 'approved' ? Colors.green : Colors.red,
                              shape: BoxShape.circle
                          ),
                          child: Icon(
                            snapshot.data!['status'] == 'approved' ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 14.0,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              );
            }
            return wText('No data');
          },
        ),
      ),
    );
  }
}
