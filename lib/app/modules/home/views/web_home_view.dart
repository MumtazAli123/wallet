// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/widgets/currency_format.dart';

import '../../../../models/balance.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../../../widgets/my_drawer.dart';
import '../controllers/home_controller.dart';

class WebHomeView extends GetView {
  final UserModel? userModel;
  WebHomeView({super.key, this.userModel});

  @override
  final controller = Get.put(HomeController());
  final DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              _buildHeader(),
              _buildContent(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    final size = MediaQuery.of(Get.context!).size;
    return SizedBox(
      // acquires 90% of the height of the screen
      height: size.height * 0.9,
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.3,
            width: 600,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallet.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  wText("Welcome, ${sharedPreferences?.getString('name')}",
                      color: Colors.white, size: 20.0),
                  SizedBox(
                    height: 60.0,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('sellers')
                          .doc(sharedPreferences?.getString('uid'))
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              wText(
                                  "Balance: PKR: ${currencyFormat(double.parse(snapshot.data!['balance'].toString()))}",
                                  color: Colors.white,
                                  size: 20.0),
                              Divider(
                                color: Colors.white,
                              ),
                              Text(
                                NumberToWord()
                                    .convert(snapshot.data!['balance'].toInt()),
                                // "${model?.name}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              wText(
                                  // show first 3 and ... last 4 digits of phone number
                                  "Account Number: ${snapshot.data!['phone'].toString().substring(0, 5)}...${snapshot.data!['phone'].toString().substring(7, 11)}",
                                  color: Colors.white,
                                  size: 14.0),
                            ],
                          );
                        }
                        return wText("Balance: \$0",
                            color: Colors.white, size: 20.0);
                      })
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                label: wText('Add Money', color: Colors.white, size: 18.0),
                icon: Icon(Icons.add, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                label: wText('Send Money', color: Colors.white, size: 18.0),
                icon: Icon(Icons.send, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 600,
                height: size.height * 0.4,
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    wText('Recent Transactions', size: 20.0),
                    Divider(),
                    Expanded(
                      flex: 1,
                      // just recent transactions list 10 items
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(sharedPreferences?.getString('uid'))
                            .collection('statement')
                            .orderBy('created_at', descending: true)
                            .limit(10)
                            .snapshots(),
                        builder: (context, snapshot) {
                          try {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      _buildDetailDialog(
                                          context,
                                          BalanceModel(
                                            name: snapshot.data?.docs[index]
                                                ['name'],
                                            description: snapshot.data?.docs[index]
                                                ['description'],
                                            amount: snapshot.data?.docs[index]
                                                ['amount'],
                                            phone: snapshot.data?.docs[index]
                                                ['phone'],
                                            type: snapshot.data?.docs[index]
                                                ['type'],
                                            created_at:
                                                'Time: ${GetTimeAgo.parse(DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()), locale: 'en')}'
                                                '\nDate: ${DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()).toString().substring(0, 16)}',
                                          ));
                                    },
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
                                    title: Text(
                                        snapshot.data?.docs[index]['name']),
                                    subtitle: Text(snapshot.data?.docs[index]
                                        ['description']),

                                    //   type and amount
                                    trailing: wText(
                                      snapshot.data?.docs[index]['type'] ==
                                              'credit'
                                          ? '+${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                          : '-${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                                    ),
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                          return Text('No Transactions');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    final size = MediaQuery.of(Get.context!).size;
    return Padding(
      padding: const EdgeInsets.only(
          top: 22.0, bottom: 22.0, left: 10.0, right: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          // acquires 90% of the height of the screen
          height: size.height * 0.6,
          width: 600,
          margin: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Statement"),
                  TextButton(onPressed: () {}, child: Text('View All'))
                ],
              ),
              Divider(),
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(sharedPreferences?.getString('uid'))
                            .collection('statement')
                            .orderBy('created_at', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
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
                                  title:
                                      Text(snapshot.data?.docs[index]['name']),
                                  subtitle: Text(snapshot.data?.docs[index]
                                      ['description']),

                                  //   type and amount
                                  trailing: wText(
                                    snapshot.data?.docs[index]['type'] ==
                                            'credit'
                                        ? '+${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                                        : '-${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                                  ),
                                  onTap: () {
                                    _buildDetailDialog(
                                        context,
                                        BalanceModel(
                                          name: snapshot.data?.docs[index]
                                              ['name'],
                                          description: snapshot
                                              .data?.docs[index]['description'],
                                          amount: snapshot.data?.docs[index]
                                              ['amount'],
                                          phone: snapshot.data?.docs[index]
                                              ['phone'],
                                          type: snapshot.data?.docs[index]
                                              ['type'],
                                          created_at:
                                              'Time: ${GetTimeAgo.parse(DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()), locale: 'en')}'
                                              '\nDate: ${DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()).toString().substring(0, 16)}',
                                        ));
                                  },
                                );
                              },
                            );
                          }
                          return Text('No Transactions');
                        },
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
      height: 100,
      color: Colors.red,
      child: Row(
        children: [
          Text('Footer'),
          Text('Footer'),
          Text('Footer'),
          Text('Footer'),
        ],
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
        type: QuickAlertType.info,
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
              "Amount: ${model.type == 'credit' ? '+${currencyFormat(double.parse(model.amount.toString()))}' : '- ${currencyFormat(double.parse(model.amount.toString()))}'}",
            ),
            Text("Purpose: ${model.description}",
                style: TextStyle(color: Colors.black)),
            //   phone number

            Text("Type: ${model.type == 'credit' ? 'Credit' : 'Debit'}",
                style: TextStyle(color: Colors.black)),
            Text("Phone: ${model.phone}",
                style: TextStyle(color: Colors.black)),
            Text(
              '${model.created_at}',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ));
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
}
