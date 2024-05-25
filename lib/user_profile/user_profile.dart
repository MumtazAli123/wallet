// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';

import '../widgets/mix_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // user profile screen
  final db = FirebaseFirestore.instance.collection('sellers');
  final storage = FirebaseStorage.instance.ref();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  bool isLoading = false;

  var _name = '';
  var _email = '';
  var _phone = '';
  var _image = '';
  var _balance = '';


  FocusNode focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    // _getUserProfile();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildSliverAppBar(),
        ];
      },
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      snap: false,
      // title: Text('Profile'.tr),
      flexibleSpace: FlexibleSpaceBar(
        title: isLoading
            ? CircularProgressIndicator()
            : Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: wText('Profile'.tr, color: Colors.white),
        ),
        background: Image.network(
          sharedPreferences!.getString('image')!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          //   profile data show
          _buildProfileData(),
          SizedBox(height: 20),
          // profile data update
          // _buildProfileUpdate(),

        ],
      ),
    );
  }

  _buildProfileData() {
    return StreamBuilder(
        stream: db.doc(currentUserId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            _name = data['name'];
            _email = data['email'];
            _phone = data['phone'];
            _image = data['image'];
            _balance = (double.parse(data['balance'].toString())).toStringAsFixed(2);
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          wText('Balance'.tr, size: 16),
                          wText(_balance, size: 20),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          _showUpdateDialog('balance', _balance);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // save profile data
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          wText('Name'.tr, size: 16),
                          wText(_name, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          wText('Email'.tr, size: 16),
                          wText(_email, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          wText('Phone'.tr, size: 16),
                          wText(_phone, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _signOut();
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : wText('Sign Out'.tr, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(200, 50),

                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }




  void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _showUpdateDialog(String s, String balance) {
    QuickAlert.show(context: context,
        type: QuickAlertType.confirm,
        title: 'Update Balance'.tr,
       text: "You can update your balance here.",
      widget:  TextField(
        controller: TextEditingController(text: balance),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter new balance'.tr,
        ),
      ),
      showConfirmBtn: false,
        cancelBtnText: "Update".tr,
      cancelBtnTextStyle: TextStyle(color: Colors.green),
    );
  }


}


