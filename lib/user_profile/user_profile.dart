// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';

import '../app/modules/statement/views/wallet_view.dart';
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
  final user = FirebaseAuth.instance.currentUser;

  final descController = TextEditingController();

  bool isLoading = false;

  var _name = '';
  var _email = '';
  var _phone = '';
  var _image = '';
  var _balance = '';

  FocusNode focusNode = FocusNode();
  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
  }


  @override
  void initState() {
    super.initState();
    _refresh();
    // _getUserProfile();
    isLoading = false;
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async{
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Update Description'.tr,
                text: "You can update your description here.",
                widget: TextField(
                  controller: descController,
                  maxLength: 130,
                  focusNode: focusNode,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                      hintText: sharedPreferences!.getString('description' )?? 'Add Description'
                  ),
                ),
                showConfirmBtn: true,
                confirmBtnText: "Update".tr,
                onConfirmBtnTap: () {
                  // update description

                  db.doc(user!.uid).update({
                    'description': descController.text,
                  });
                  sharedPreferences!.setString('description', descController.text);
                  Get.back();
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Description Updated'.tr,
                    text: "Your description has been updated successfully.",
                    showConfirmBtn: false,
                    cancelBtnText: "Close".tr,
                    showCancelBtn: true,

                  );
                },
                cancelBtnTextStyle: TextStyle(color: Colors.green),
              );
            },
          ),

        ],
      )
    );
  }

  _buildBody() {
    return  RefreshIndicator(
            onRefresh: _refresh,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        child: MixWidgets.buildAvatar(
                          sharedPreferences!.getString('image') ?? '',
                          100.0,
                        ),
                      ),
                      wText(
                        _name,
                        size: 20.0,
                      ),
                      // icon button for update profile whatsapp  fb, insta
                      _buildSocialIcons(),
                      // build follow and following count and like count
                      _buildFollowAndLikeCount(),
                      // description add and edit
                      _buildDescriptionEdit(),
                      // ranking stars

                      MixWidgets.buildRatingStars(4.5),


                      _buildProfileDetails(),
                    ],
                  ),
                ),
              ),
            ),
          );

  }

  _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          _buildProfile(),
          SizedBox(height: 20),
          //   profile data show
          _buildProfileData(),
          SizedBox(height: 20),
          // profile data update
          // _buildProfileUpdate(),
        ],
      ),
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
        child: StreamBuilder(
          stream: db.doc(currentUserId).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              _name = data['name'];
              _email = data['email'];
              _phone = data['phone'];
              _image = data['image'];
              _balance =
                  (double.parse(data['balance'].toString())).toStringAsFixed(2);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(
                      children: [
                        MixWidgets.buildAvatar(data['image'] ?? '', 50.0),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            wText(
                              data['name'],
                              size: 16.0,
                            ),
                            wText(
                              data['phone'],
                              size: 14.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 10.0),
                      wText(
                        data['email'],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 10.0),
                      wText(
                        'Pakistan'.tr,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet),
                      SizedBox(width: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          wText('Status:  ', size: 14.0),
                          wText(
                              "${data["status"]}" == 'approved'
                                  ? 'Active'
                                  : 'Inactive',
                              size: 14.0),
                          SizedBox(width: 10.0),
                          //    if status is approved then show green color else red color
                          Container(
                            height: 18.0,
                            width: 18.0,
                            decoration: BoxDecoration(
                                color: "${data["status"]}" == 'approved'
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle),
                            child: Icon(
                              "${data["status"]}" == 'approved'
                                  ? Icons.check
                                  : Icons.close,
                              color: Colors.white,
                              size: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  //   crreat at
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10.0),
                      wText(
                        // jsut show date and time not need to show full date
                        'Created At: ${data["createdAt"]!.toString().substring(0, 16)}',
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  _buildProfileData() {
    return ElevatedButton(
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
    );
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _showUpdateDialog(String s, String balance) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Update Balance'.tr,
      text: "You can update your balance here.",
      widget: TextField(
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

  _buildSocialIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Update Phone'.tr,
                text: "You can update your phone number here.",
                widget: TextField(
                  controller: TextEditingController(text: _phone),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter new phone'.tr,
                  ),
                ),
                showConfirmBtn: false,
                cancelBtnText: "Update".tr,
                cancelBtnTextStyle: TextStyle(color: Colors.green),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Update Email'.tr,
                text: "You can update your email here.",
                widget: TextField(
                  controller: TextEditingController(text: _email),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter new email'.tr,
                  ),
                ),
                showConfirmBtn: false,
                cancelBtnText: "Update".tr,
                cancelBtnTextStyle: TextStyle(color: Colors.green),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Update Image'.tr,
                text: "You can update your image here.",
                widget: TextField(
                  controller: TextEditingController(text: _image),
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Enter new image url'.tr,
                  ),
                ),
                showConfirmBtn: false,
                cancelBtnText: "Update".tr,
                cancelBtnTextStyle: TextStyle(color: Colors.green),
              );
            },
          ),
        ],
      ),
    );
  }

  _buildFollowAndLikeCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              wText(
                '0',
                size: 16.0,
              ),
              wText(
                'Followers'.tr,
                size: 16.0,
              ),

            ],
          ),
          SizedBox(width: 20),
          Column(
            children: [
              wText(
                '0',
                size: 16.0,
              ),
              wText(
                'Following'.tr,
                size: 16.0,
              ),

            ],
          ),
          SizedBox(width: 20),
          Column(
            children: [
              wText(
                '0',
                size: 16.0,
              ),
              wText(
                'Likes'.tr,
                size: 16.0,
              ),

            ],
          ),
        ],
      ),
    );
  }
  _buildDescriptionEdit() {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        sharedPreferences!.getString('description') ?? 'Add Description',
        style: GoogleFonts.poppins(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


}
