// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet/app/modules/statement/views/statement_view.dart';
import 'package:wallet/global/global.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/statement_controller.dart';

class TimeStatementView extends StatefulWidget {
   const TimeStatementView({super.key});

  @override
  State<TimeStatementView> createState() => _TimeStatementViewState();
}

class _TimeStatementViewState extends State<TimeStatementView> {
  final controller = Get.put(StatementController());
  String? uid = fAuth.currentUser!.uid;
  final user = fAuth.currentUser;

  late var date = DateTime.now();

  bool isLoading = false;

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
      length: 3,

      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Get.to(() => StatementView(
                ));
              },
            ),
          ],
          title: wText(
            sharedPreferences!.getString('name')!.length > 10
                ? '${sharedPreferences!.getString('name')!.substring(
                0, 10)}\'s Statement'.tr
                : sharedPreferences!.getString('name')! + '\'s Statement'.tr,

          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Today'.tr),
              Tab(text: 'Last 7 days'.tr),
              Tab(text: 'Last 30 days'.tr),
            ],
          ),
        ),

        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return TabBarView(children: [
      _buildTabViewToday('today'),
      _buildTabViewWeek('week'),
      _buildTabViewLastMonth('month'),
    ]);
  }


  wTextButton(String substring, void Function() showDatePicker) {
    return TextButton(
      onPressed: showDatePicker,
      child: Text(substring),
    );
  }

  _buildTabViewToday(String s) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(sharedPreferences?.getString('uid'))
            .collection('statement')
            .where('created_at', isGreaterThanOrEqualTo: date.subtract(Duration(days: 1)))
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
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
                              Text(
                                  snapshot.data?.docs[index]['type'] ==
                                      'send'
                                      ? 'Cr'
                                      : 'Dr'),
                            ],
                          ),
                          Text(
                            GetTimeAgo.parse(DateTime.parse(data['created_at'].toDate().toString()), locale: 'en'),
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
        }
    );
  }

  _buildTabViewWeek(String s) {
    //  show data today from firestore
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(sharedPreferences?.getString('uid'))
            .collection('statement')
            .where('created_at', isGreaterThanOrEqualTo: date.subtract(Duration(days: 7)))
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
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
                              Text(
                                  snapshot.data?.docs[index]['type'] ==
                                      'send'
                                      ? 'Cr'
                                      : 'Dr'),
                            ],
                          ),
                          Text(
                            GetTimeAgo.parse(DateTime.parse(data['created_at'].toDate().toString()), locale: 'en'),
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
        }
    );

  }

  _buildTabViewLastMonth(String s) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(sharedPreferences?.getString('uid'))
            .collection('statement')
            .where('created_at', isGreaterThanOrEqualTo: date.subtract(Duration(days: 30)))
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
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
                              Text(
                                  snapshot.data?.docs[index]['type'] ==
                                      'send'
                                      ? 'Cr'
                                      : 'Dr'),
                            ],
                          ),
                          Text(
                            GetTimeAgo.parse(DateTime.parse(data['created_at'].toDate().toString()), locale: 'en'),
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
        }
    );
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
              IconButton(onPressed: ()=> _shareDialog(param0),
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


  _shareDialog(param0)async {
    final box = context.findRenderObject() as RenderBox?;
    // share dialog screen shot not a text
    if (box != null) {
      Share.share(
          'Amount: ${currencyFormat(double.parse(param0['amount'].toString()))}\n'
              'Type: ${param0['type'] == 'send' ? 'Credit' : 'Debit'}\n'
              'Purpose: ${param0['description'] ?? 'No Description'}\n'
              'Phone: ${param0['phone'] ?? 'Not Available'}\n'
              'Time: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}\n'
              'Date: ${DateTime.parse(param0['created_at'].toDate().toString()).toString().substring(0, 16)}',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

  }

  
}
