// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/widgets/currency_format.dart';

import '../../../../models/balance.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../home/controllers/home_controller.dart';
import '../../statement/views/receive_send.dart';
import '../../statement/views/time_statement_view.dart';

class WalletView extends GetView<HomeController> {
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
        title: wText(
          "${'ZubiPay'.tr} ${'Wallet'.tr}",
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
                  image: model!.image!.isEmpty
                      ? Image.asset('assets/images/bg.png', height: 300, width: double.infinity, fit: BoxFit.cover,)
                      : Image.network(model!.image!,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,),
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
        _buildButton(),
        // _buildAddSendMoneyButton(double, model),
        SizedBox(
          height: 20.0,
        ),
        _buildRecentTransactions(),
      ],
    );
  }

  _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: _buildButtonCard("Send Money".tr, "assets/lottie/send.json")),
        // Expanded(
        //     child: _buildButtonCard("Receive Money".tr, Icons.money)),
        Expanded(child: _buildButtonCard("Add Money".tr, "assets/lottie/animation.json")),
      ],
    );
  }

  _buildButtonCard(
      String s,
      String send,
      ) {
    return GestureDetector(
      onTap: () {
        if (s == "Send Money".tr) {
          Get.toNamed('/send-money');
        } else if (s == "Receive Money".tr) {
          Get.to(() => ReceiveSendMoney());
        } else if (s == "Add Money".tr) {
          // Get.toNamed('/add-money');
          _buildDialogAddMoney();
        }
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(send,
                height: 80, width: double.infinity),
            // Icon(send, size: 30.0, color: Theme.of(context).primaryColor),
            SizedBox(height: 10.0),
            wText(s, size: 16.0, color: Theme.of(Get.context!).primaryColor),
          ],
        ),
      ),
    );
  }

  _buildRecentTransactions() {
    final size = MediaQuery.of(Get.context!).size;
    try {
      return FlipCard(
        direction: FlipDirection.HORIZONTAL,
        flipOnTouch: true,
        front: GFCard(
          // image: Image.asset('assets/wallet.jpeg', height: 200, width: double.infinity,),
          showImage: true,
          title: GFListTile(
            title: wText('View All Transactions'.tr),
            icon: GFIconButton(
              onPressed: () {
                Get.to(() => TimeStatementView());
              },
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ),
          content: Column(
            children: [
              myWidget.animate(onPlay: (controller) {
                controller.loop(reverse: false, count: 3);
              })
                  .fade().shake().slide(
                duration: const Duration(seconds: 5),
              ).saturate(),
              Lottie.asset('assets/lottie/coins.json',
                  height: 200, width: double.infinity),

            ],
          ),
        ),
        back:  Card(
          elevation: 14,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            height: size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
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
                              child: GestureDetector(
                                onDoubleTap: () {
                                  _buildDetailDialog(
                                      context,
                                      BalanceModel(
                                        name: snapshot.data?.docs[index]['name'],
                                        amount: snapshot.data?.docs[index]['amount'],
                                        type: snapshot.data?.docs[index]['type'],
                                        description: snapshot.data?.docs[index]['description'],
                                        phone: snapshot.data?.docs[index]['phone'],
                                        created_at: snapshot.data?.docs[index]['created_at'].toDate().toString(),
                                      ));
                                },
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                      leading: Icon(Icons.account_balance_wallet, color: Colors.blue),
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
                                              DateTime.parse(snapshot
                                                  .data!.docs[index]['created_at']
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
                                        color: snapshot.data?.docs[index]['type'] ==
                                            'send'
                                            ? Colors.green
                                            : Colors.red,
                                      )),

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
  Widget myWidget = Container(
    width: 500,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.blue[900],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text("Recent Transactions!".tr, style: GoogleFonts.damion(
          fontSize: 30,
          color: Colors.white
      ),),
    ),
  );

  void _buildDialogTran(doc, doc2, doc3, String? string, doc4, doc5) {
    QuickAlert.show(
      textAlignment: TextAlign.start,
      context: Get.context!,
      type: QuickAlertType.info,
      title: doc,
      text: 'Details $doc3',
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          wText(
            color: Colors.black,
            "Amount: $doc2",
          ),
          Text("Type: $doc3",
              style: TextStyle(color: Colors.black)),
          //   phone number

          Text("Phone: $doc4",
              style: TextStyle(color: Colors.black)),
          Text(
            // first later capital
            'Description: $doc5'.tr.substring(0, 1).toUpperCase() +
                'Description: $doc5'.tr.substring(1),
            style: GoogleFonts.gabarito(color: Colors.blue[900]),
          ).animate(
            onPlay: (controller) {
              controller.loop(reverse: false, count: 3);
            },
          ).fadeIn().rotate(
            delay: Duration(seconds: 1),
            duration: const Duration(seconds: 1),
          ),
          Text(GetTimeAgo.parse(
              DateTime.parse(DateTime.parse(string!).toLocal()

                  .toString()),
              locale: 'en')),
        ],
      ),
    );
  }
}
