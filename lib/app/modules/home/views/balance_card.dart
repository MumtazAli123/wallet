// ignore_for_file: file_names , prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/home/views/wallet_view.dart';
import 'package:wallet/models/user_model.dart';
import 'package:wallet/widgets/currency_format.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../statement/views/receive_send.dart';
import '../../statement/views/time_statement_view.dart';

class BalanceCard extends StatefulWidget {
  final UserModel? model;
  const BalanceCard({super.key, this.model});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final user = FirebaseAuth.instance.currentUser;
  final date = DateTime.now();
  final DateTime now = DateTime.now();

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        // design card
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBalanceCard(),
              SizedBox(height: 10.0),
              _buildButton(),
              SizedBox(height: 10.0),
              _buildRecentTransactions(),
              SizedBox(height: 10.0),
              _buildProfile(),
              SizedBox(height: 10.0),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
    // return SafeArea(
    //     child: SingleChildScrollView(
    //           child: Center(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       _buildBalanceCard(),
    //                       SizedBox(height: 10.0),
    //                       _buildButton(),
    //                       SizedBox(height: 10.0),
    //                       _buildRecentTransactions(),
    //                       SizedBox(height: 10.0),
    //                       _buildProfile(),
    //                       SizedBox(height: 10.0),
    //
    //                       _buildFooter(),
    //                       // _buildTransactionCard(),
    //                       //
    //                       // _buildFooter(),
    //                     ],
    //             ),
    //           ),
    //         ));
  }

  _buildBalanceCard() {
    return Container(
      height: 255,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/walleta.png'),
          fit: BoxFit.cover,
        ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              wText("${widget.model!.name}", color: Colors.white),
              Container(
                  height: 18.0,
                  width: 18.0,
                  decoration: BoxDecoration(
                      color: widget.model!.status == 'approved'
                          ? Colors.green
                          : Colors.red,
                      shape: BoxShape.circle),
                  child: Icon(
                    widget.model!.status == 'approved'
                        ? Icons.check
                        : Icons.close,
                    color: Colors.white,
                    size: 14.0,
                  )),
            ],
          ),
          SizedBox(height: 20.0),
          // balance
          wText("Balance".tr, color: Colors.white),
          wText("Rs: ${widget.model!.balance}", color: Colors.white, size: 30),
          Divider(color: Colors.white),
          // number of transactions
          wText(
              "PKR: ${NumberToWord().convert(widget.model!.balance!.toInt())}",
              color: Colors.white,
              size: 12),

          SizedBox(height: 15.0),
          // account number phone first 5 digits and last 4 digits
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              wText("Account Number :".tr, color: Colors.white, size: 12),
              wText(
                  "${widget.model!.phone!.substring(0, 5)}...${widget.model!.phone!.substring(widget.model!.phone!.length - 4)}",
                  color: Colors.white),
            ],
          ),
          SizedBox(height: 10),
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
  _buildButton() {
    return GFCard(
      color: Get.theme.scaffoldBackgroundColor,
      padding: EdgeInsets.all(5.0),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _buildButtonCard("Send Money".tr, Icons.send)),
              Expanded(
                  child: _buildButtonCard("Receive Money".tr, Icons.money)),
              Expanded(child: _buildButtonCard("Add Money".tr, Icons.add)),
            ],
          ),
          SizedBox(height: 10.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     _buildButtonCard("Withdraw Money".tr, Icons.money_off),
          //     _buildButtonCard("Wallet".tr, Icons.account_balance_wallet),
          //     _buildButtonCard("Statement".tr, Icons.sticky_note_2),
          //   ],
          // ),
        ],
      ),
    );
  }

  _buildButtonCard(
    String s,
    IconData send,
  ) {
    return GestureDetector(
      onTap: () {
        if (s == "Send Money".tr) {
          Get.toNamed('/send-money');
        } else if (s == "Receive Money".tr) {
          Get.to(() => ReceiveSendMoney());
        } else if (s == "Add Money".tr) {
          // Get.toNamed('/add-money');
          _buildDialog();
        }
      },
      child: GFCard(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Get.theme.scaffoldBackgroundColor,
        padding: EdgeInsets.all(5.0),
        content: Column(
          children: [
            Icon(send, size: 30.0),
            SizedBox(height: 5.0),
            wText(s, size: 11.0),
          ],
        ),
      ),
    );
  }

  _buildRecentTransactions() {
    final size = MediaQuery.of(Get.context!).size;
    try {
      // return Card(
      //   elevation: 14,
      //   child: Container(
      //     margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      //     height: size.height * 0.6,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(10.0),
      //     ),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         SizedBox(height: 10.0),
      //         Padding(
      //           padding: const EdgeInsets.only(left: 8.0, right: 4.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               wText("Recent Transactions".tr, size: 18.0),
      //               Spacer(),
      //               TextButton(
      //                   onPressed: () {
      //                     Get.to(() => TimeStatementView());
      //                   },
      //                   child: wText('View All'.tr, color: Colors.blue))
      //             ],
      //           ),
      //         ),
      //         // Divider(),
      //         Expanded(
      //           child: StreamBuilder(
      //             stream: FirebaseFirestore.instance
      //                 .collection('sellers')
      //                 .doc(user!.uid)
      //                 .collection('statement')
      //                 .where('created_at',
      //                     isGreaterThanOrEqualTo: DateTime(
      //                         // recent transactions minimum 3 days
      //                         now.year,
      //                         now.month,
      //                         now.day - 3))
      //                 .orderBy('created_at', descending: true)
      //                 .limit(5)
      //                 .snapshots(),
      //             builder: (context, snapshot) {
      //               if (snapshot.hasData) {
      //                 return ListView.builder(
      //                   itemCount: snapshot.data!.docs.length,
      //                   itemBuilder: (context, index) {
      //                     return Padding(
      //                       padding:
      //                           const EdgeInsets.only(left: 8.0, right: 8.0),
      //                       child: Card(
      //                         elevation: 5,
      //                         child: ListTile(
      //                             leading: MixWidgets.buildAvatar(
      //                                 // get user image from firebase
      //                                 isLoading == true
      //                                     ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
      //                                     : snapshot
      //                                         .data?.docs[index]['image']
      //                                         .toString(),
      //                                 20.0),
      //                             title: Text(
      //                                 snapshot.data?.docs[index]['name']),
      //                             subtitle: Column(
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               children: [
      //                                 // balance type cr or dr
      //                                 Row(
      //                                   children: [
      //                                     Text(
      //                                         // amount
      //                                         snapshot.data?.docs[index]
      //                                                     ['type'] ==
      //                                                 'send'
      //                                             ? 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'
      //                                             : 'Rs.${currencyFormat(double.parse(snapshot.data!.docs[index]['balance'].toString()))}'),
      //                                     SizedBox(width: 10.0),
      //                                     Text(snapshot.data?.docs[index]
      //                                                 ['type'] ==
      //                                             'send'
      //                                         ? 'Cr'
      //                                         : 'Dr'),
      //                                   ],
      //                                 ),
      //                                 Text(GetTimeAgo.parse(
      //                                     DateTime.parse(snapshot
      //                                         .data!.docs[index]['created_at']
      //                                         .toDate()
      //                                         .toString()),
      //                                     locale: 'en')),
      //                               ],
      //                             ),
      //
      //                             //   type and amount
      //                             trailing: wText(
      //                               snapshot.data?.docs[index]['type'] ==
      //                                       'send'
      //                                   ? '+ ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
      //                                   : '- ${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
      //                             ),
      //                             onTap: () {
      //                               _buildDialogTran(
      //                                   snapshot.data?.docs[index]['name'],
      //                                   snapshot.data?.docs[index]['amount'],
      //                                   snapshot.data?.docs[index]['type'],
      //                                   snapshot
      //                                       .data?.docs[index]['created_at']
      //                                       .toDate()
      //                                       .toString(),
      //                                   snapshot.data?.docs[index]['phone'],
      //                                   snapshot.data?.docs[index]
      //                                       ['description']);
      //                             }),
      //                       ),
      //                     );
      //                   },
      //                 );
      //               }
      //               return wText('No Transactions');
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
      return FlipCard(
          front: GFCard(
            image: Image.asset('assets/wallet.jpeg'),
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
            content: myWidget.animate(onPlay: (controller) {
              controller.loop(reverse: false, count: 3);
            })
                .fade().shake().slide(
              duration: const Duration(seconds: 5),
            ).saturate(),
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
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                      leading: MixWidgets.buildAvatar(
                                          // get user image from firebase
                                          isLoading == true
                                              ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                                              : snapshot
                                                  .data?.docs[index]['image']
                                                  .toString(),
                                          20.0),
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
                                      ),
                                      onTap: () {
                                        _buildDialogTran(
                                            snapshot.data?.docs[index]['name'],
                                            snapshot.data?.docs[index]['amount'],
                                            snapshot.data?.docs[index]['type'],
                                            snapshot
                                                .data?.docs[index]['created_at']
                                                .toDate()
                                                .toString(),
                                            snapshot.data?.docs[index]['phone'],
                                            snapshot.data?.docs[index]
                                                ['description']);
                                      }),
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

  void _buildDialog() {
    // we're working on this
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Add Money",
      text: ''
          'We are working on this feature',
    );
  }

  currencyFormat(double parse) {
    return parse.toStringAsFixed(2);
  }

  void _buildDialogTran(name, amount, type, date, phone, description) {
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
              eText("Type: ", color: Colors.black),
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
              wText("Profile".tr, size: 18.0),
              SizedBox(height: 10.0),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                  isLoading == true
                      ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                      : widget.model!.image!,
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Name: ${widget.model!.name}',
                ),
              ),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  'Phone: ${widget.model!.phone!.substring(0, 5)}...${widget.model!.phone!.substring(widget.model!.phone!.length - 4)}',
                ),
              ),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text(
                  'Email: ${widget.model!.email}',
                ),
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
                    'Status: ${widget.model!.status == 'approved' ? 'Active' : 'Inactive'}'),
                trailing: Container(
                  height: 18.0,
                  width: 18.0,
                  decoration: BoxDecoration(
                      color: widget.model!.status == 'approved'
                          ? Colors.green
                          : Colors.red,
                      shape: BoxShape.circle),
                  child: Icon(
                    widget.model!.status == 'approved'
                        ? Icons.check
                        : Icons.close,
                    color: Colors.white,
                    size: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildFooter() {
    return Container(
      width: double.infinity,
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
}
