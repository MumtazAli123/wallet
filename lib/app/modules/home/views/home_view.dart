// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/wallet/views/send_view.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/seller_model.dart';
import 'package:wallet/models/user_model.dart';

import '../../../../widgets/currency_format.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  final UserModel? userModel;
  HomeView({super.key, this.userModel});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final user = fAuth.currentUser;

  final GetStorage box = GetStorage();
  String? name = sharedPreferences?.getString('name');
  String? email = sharedPreferences?.getString('email');
  String? image = sharedPreferences?.getString('image');
  String? phone = sharedPreferences?.getString('phone');
  String? balance = sharedPreferences?.getString('balance');

  SellerModel? sellerModel = SellerModel();

  String? uid = fAuth.currentUser!.uid;

  String someStringVariable = map['someKey'].toString();

  static var map = {};

  Future<List> getAllStatement() async {
    final List<DocumentSnapshot> documents = [];
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(user!.uid)
        .collection('statement')
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        documents.add(element);
      }
    });
    return documents;
  }

  UserModel? userModel = UserModel.fromMap(map);

  Future<List> getAllData() async {
    // current user data
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        userModel = UserModel.fromMap(value.data());
      });
    });
    return [];
  }

  bool isLoading = false;
  @override
  // statement data
  void initState() {
    super.initState();
    isLoading = true;
    getAllData().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    getAllStatement().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(
                    name ?? 'name', email ?? 'email', image ?? 'image'),
                _buildBalance(balance ?? 'balance'),
                _buildStatement(),
              ],
            ),
          );
  }

  _buildHeader(String s, String t, String u) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 210,
      width: 400,
      decoration: BoxDecoration(
        // color: Colors.blue,
        image: DecorationImage(
          image: AssetImage("assets/wallet.png"),
          fit: BoxFit.cover,
          alignment: Alignment.topRight,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(u),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // intelliJ IDEA
                    Text(
                      s,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      t,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Balance',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(user!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          return Column(
                            children: [
                              Text(
                                'PKR: ${currencyFormat(double.parse(snapshot.data!['balance'].toString()))}',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 14.0),
                              // snapshot.data!['balance']
                              Text(
                                "Balance, ${NumberToWord().convert(snapshot.data!['balance'].toInt())}",
                                // "${model?.name}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => SendView());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                  ),
                  child: wText(
                    'Send Money',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  _buildBalance(param0) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Total Earnings',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'PKR: 0.00',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Total Withdraw',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'PKR: 0.00',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildStatement() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statement',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(user!.uid)
                  .collection('statement')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _buildStatementItem(snapshot.data!.docs[index]);
                  },
                );
              }),
        ],
      ),
    );
  }

  _buildStatementItem(param0) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          _buildDetailDialog(param0);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            "${param0['name'][0]}",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          "${param0['name']}",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          GetTimeAgo.parse(
              DateTime.parse(param0['created_at'].toDate().toString()),
              locale: 'en'),
        ),
        trailing: Column(
          children: [
            Text(
              "${param0['type'] == 'send' ? '-' : '+'} ${currencyFormat(double.parse(param0['amount'].toString()))}",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              param0['type'] == 'send' ? 'Sent' : 'Received',
            )
          ],
        ),
      ),
    );
  }

  Future<void> _buildDetailDialog(param0) async {
    // is mobile or tablet or desktop
   return isMobile(context)
        ? _buildDetailMobile(param0)
        : _buildDetailDesktop(param0);
  }

  isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  _buildDetailMobile(param0) {
    MediaQuery.of(context).size.width < 600;
    return QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Detail',
        text: 'Detail of the transaction',
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text(
              'Name: ${param0['name']}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              'Amount: ${currencyFormat(double.parse(param0['amount'].toString()))}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              'Type: ${param0['type']}',
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
              // description
              'Purpose: ${param0['description'] ?? 'No Description'}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              'Date: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }

  _buildDetailDesktop(param0) {
    MediaQuery.of(context).size.width > 600;
    return Get.defaultDialog(
      title: 'Detail',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(
            'Name: ${param0['name']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            'Amount: ${currencyFormat(double.parse(param0['amount'].toString()))}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            'Type: ${param0['type']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            param0['phone'] == null
                ? 'Phone: Not Available'
                : 'Phone: ${param0['phone']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            // description
            'Purpose: ${param0['description'] ?? 'No Description'}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            'Date: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class DateFormat {
  static String yMMMd() {
    return 'yMMMd';
  }
}
