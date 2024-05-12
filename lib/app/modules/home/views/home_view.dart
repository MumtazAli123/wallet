// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/seller_model.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../widgets/currency_format.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});


  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final user = fAuth.currentUser;

  final GetStorage box = GetStorage();
  double someDoubleValue = 10.0;
  String? balance = sharedPreferences?.getString('balance') ?? '10';
  String? name = sharedPreferences?.getString('name');
  String? email = sharedPreferences?.getString('email');
  String? image = sharedPreferences?.getString('image');
  String? phone = sharedPreferences?.getString('phone');

  SellerModel? sellerModel = SellerModel();

  String? uid = fAuth.currentUser!.uid;

  String someStringVariable = map['someKey'].toString();

  static var map = {};



  Future<List>getAllSellers() async {
    final List<DocumentSnapshot> documents = [];
    await FirebaseFirestore.instance.collection('sellers').get().then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        documents.add(element);
      }
    });
    return documents;
  }

  Future<List> getAllData() async {
    // current user data
    final List<DocumentSnapshot> documents = [];
    await FirebaseFirestore.instance.collection('sellers').get().then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        documents.add(element);
      }
    });
    return documents;
  }


  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .get()
        .then((value) {
      balance = value.data()!['balance'];
      name = value.data()!['name'];
      email = value.data()!['email'];
      image = value.data()!['image'];
      phone = value.data()!['phone'];
      setState(() {});
    });

    controller.streamArticle();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();

                },
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(image ?? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                ),
              ),),


              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () {
                  fAuth.signOut();
                  Get.offAllNamed('/login');
                }, icon: Padding(
                  padding:  EdgeInsets.only(bottom: 10, right: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.lock_open, color: Colors.black),
                  ),
                )),],

              title: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                // minimum text length is 0 to 8 ... use shared preference
                child:  Text(
                //   first 8 characters and first letter of the name is capital
                  "Welcome, ${name!.length > 8 ? name!.substring(0, 8) : name!.toUpperCase()[0] + name!.substring(1)}",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              pinned: false,
              floating: false,
              snap: false,
              expandedHeight: 230,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Balance',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // String someStringVariable = map['someKey'].toString();
                      'Rs. ${balance ??<  String > {
                      }}',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  //   in word form 1000 = one thousand rupees
                  ],
                ),
                background: Image.asset(
                  'assets/images/wallet.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: _buildSliverList());

  }

  _buildSliverList() {
    return FutureBuilder(
      future:
      FirebaseFirestore.instance.collection("sellers").doc(uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: <Widget>[
            _buildCategories(),
            _buildStatementList(),
          ],
        );
      },
    );
  }

  currencyFormat(String? balance) {
    return CurrencyFormat.convertToIdr(balance, 2);
  }

  _buildCategories() {
    return Container(
      alignment: Alignment.center,
      height: 100,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8),
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.category,
                  color: Colors.white,
                ),
                Text(
                  "Category",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildStatementList() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("sellers").doc(uid).collection('statement').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['body']),
                trailing: Text(data['balance']),
              );
            },
          );
        },
      ),
    );
  }

}
