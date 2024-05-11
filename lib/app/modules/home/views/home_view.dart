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

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});


  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());

  final GetStorage box = GetStorage();
  double someDoubleValue = 10.0;
  String? balance = sharedPreferences?.getString('balance') ?? '10';
  String? name = sharedPreferences?.getString('name');
  String? email = sharedPreferences?.getString('email');
  String? image = sharedPreferences?.getString('image');
  String? phone = sharedPreferences?.getString('phone');

  SellerModel? sellerModel = SellerModel();

  // Future<List>getAllSellers() async {
  //   final List<DocumentSnapshot> documents = [];
  //   await FirebaseFirestore.instance.collection('sellers').get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((element) {
  //       documents.add(element);
  //     });
  //   });
  //   return documents;
  // }

  Future<List> getAllData() async {
    // current user data
    final List<DocumentSnapshot> documents = [];
    await FirebaseFirestore.instance.collection('sellers').get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        documents.add(element);
      });
    });
    return documents;
  }

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      sellerModel = SellerModel.fromMap(value.data());
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
                  padding: const EdgeInsets.only(bottom: 8, left: 8),
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
                  //     minimum text length is 0 to 8 ... use shared preference
                  "Welcome $name"  ?? 'Welcome User',

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
                      'Rs. $balance' ,
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
        future: getAllData(),
        builder: (context, AsyncSnapshot<List> snapshot) {
        try{
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: Text(snapshot.data![index].data()!['balance'].toString()),
                  title: Text(snapshot.data![index].data()?['name']),
                  subtitle: Text(snapshot.data![index].data()?['email']),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data![index].data()?['image']),
                  ),
                );
              },
            );
          }
        } catch (e) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
          return Container();
        }
    );
  }
}
