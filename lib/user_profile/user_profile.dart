// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/global/global.dart';

import '../utils/utils.dart';
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
            :  Container(
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
            return Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Name'),
                      subtitle: Text(_name),
                      trailing: Icon(Icons.edit),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text(_email),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // _showUpdateDialog('email', _email);
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                      subtitle: Text(_phone),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // _showUpdateDialog('phone', _phone);
                        },
                      ),
                    ),
                  ],
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
}


