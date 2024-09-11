// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:wallet/models/user_model.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../app/modules/home/views/wallet_view.dart';
import '../notification/notification_page.dart';
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
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  PickedFile? pickedFile;
  String? imageUrl;
  XFile? image;
  var statusCode = 0;

  var name = sharedPreferences!.getString('name');
  var _email = sharedPreferences!.getString('email');
  var _phone = sharedPreferences!.getString('phone');
  var _image = sharedPreferences!.getString('image');
  var balance = '';

  var fabController;

  FocusNode focusNode = FocusNode();

  final UserModel userModel = UserModel();

  String message = 'Description Updated';
  String city = 'City Updated';

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    // descController.text = sharedPreferences!.getString('description')!;
    // cityController.text = sharedPreferences!.getString('city')!;
    isLoading = false;
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
    descController.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SafeArea(
            child: Scaffold(
              drawer: MyDrawer(),
              body: _buildBody(),
            ),
          ),
        ));
  }

  _buildBody() {
    return Column(
      children: [
        //   app bar
        AppBar(
          title: wText('Profile'.tr),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                  ),
                );
              },
            ),
          ],
        ),

        Expanded(
          child: _buildBodyContent(),
        ),

        //   bottom navigation bar

      ],
    );
  }

  _buildBodyContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Stack(
              children: [
                sharedPreferences!.getString('image')!.isEmpty
                    ? MixWidgets.buildAvatar(
                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                        70.0)
                    : MixWidgets.buildAvatar(
                        sharedPreferences!.getString('image')!, 70.0),
                Positioned(
                  top: 95.0,
                  right: 0.0,
                  bottom: -9.0,
                  child: IconButton(
                      icon: CircleAvatar(
                          radius: 25.0, child: Icon(Icons.camera_alt)),
                      onPressed: () {
                        _buildImageEditAndSave();
                      }),
                ),
              ],
            ),
            SizedBox(height: 10.0),

            wText(
              // name and balance
              sharedPreferences!.getString('name') ?? 'Name',
              size: 16.0,
            ),
            // icon button for update profile whatsapp  fb, inst
            _buildSocialIcons(),
            // build follow and following count and like count
            _buildFollowAndLikeCount(),
            // description add and edit
            _buildDescriptionEdit(),
            // ranking stars

            MixWidgets.buildRatingStars(3.1),

            _buildProfileDetails(),
          ],
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
              name = data['name'];
              _email = data['email'];
              _phone = data['phone'];
              _image = data['image'];
              balance =
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
                  Row(
                    children: [
                      // qr code
                      QrImageView(
                        backgroundColor: Colors.white,
                        data: sharedPreferences!.getString('phone')!,
                        size: 100.0,
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          wText(
                            data['name'],
                            size: 16.0,
                          ),
                        ],
                      ),
                    ],
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
                      Icon(Icons.phone),
                      SizedBox(width: 10.0),
                      wText(
                        data['phone'],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_city),
                      SizedBox(width: 10.0),
                      wText(
                        'City: ${data["city"]}'.tr,
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
                  //   create at
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10.0),
                      wText(
                        // just show date and time not need to show full date
                        'Date: ${data["createdAt"]!.toString().substring(0, 16)}',
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
      child: wText('Sign Out'.tr, color: Colors.white),
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

  _buildSocialIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: urlLauncher('assets/images/whatsapp.png',
                'https://wa.me/$_phone', 'Whatsapp'),
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
            // email
            icon: urlLauncher(
                'assets/images/email.png', 'mailto:$_email', 'Email'),
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
            // call
            icon: urlLauncher('assets/images/call.png', 'tel:$_phone', 'Call'),
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
                '90',
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
                '10',
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
                '100',
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

  void _buildImageEditAndSave() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Update Image'.tr,
      text: "You can update your image here.",
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.blue,
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            onPressed: () {
              _pickImage(ImageSource.camera);
              Get.back();
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.green,
              child: Icon(Icons.image, color: Colors.white),
            ),
            onPressed: () {
              _pickImage(ImageSource.gallery);
              Get.back();
            },
          ),
        ],
      ),
      showConfirmBtn: false,
      cancelBtnText: "Close".tr,
      onCancelBtnTap: () {
        //  when loading show quick alert loading dialog box and get back to the screen
        Get.back();
      },
    );
  }

  void _pickImage(ImageSource camera) {
    imagePicker.pickImage(source: camera).then((value) {
      setState(() {
        image = value;
      });
      if (image != null) {
        _uploadImage();
        //  when loading show quick alert loading dialog box and get back to the screen
        _quickAlertLoading();
      }
    });
  }

  void _uploadImage() async{
    storage
        .child('sellers')
        .child(user!.uid)
        .putFile(File(image!.path))
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        db.doc(user!.uid).update({
          'image': value,
        });
        await sharedPreferences!.setString('image', value);
        // vehicle image updated successfully
        QuickAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          type: QuickAlertType.success,
          title: 'Image Updated'.tr,
          text: "Your image has been updated successfully.",
          showConfirmBtn: true,
          showCancelBtn: false,
          confirmBtnText: "Update".tr,
          onConfirmBtnTap: () {
            // Get.back and refresh the screen
            _refresh();
            Get.back();
          },
        );
      });
    });
  }

  void _quickAlertLoading() {
    QuickAlert.show(
      autoCloseDuration: Duration(seconds: 2),
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading'.tr,
      width: 400,
      text: "Please wait while we are updating your image.",
      showConfirmBtn: false,
      onCancelBtnTap: () {
        // Get.back and refresh the screen
        Get.back();
      },
    );
  }

  void _updateDescription() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Update Data'.tr,
      text: "You can update your data here.",
      widget: Column(
        children: [
          TextField(
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
            controller: descController,
            maxLength: 100,
            maxLines: 1,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                message = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: 'Description'.tr,
              labelStyle: GoogleFonts.poppins(
                color: Colors.black,
              ),
              hintText:
                  'Description: ${sharedPreferences!.getString('description')}'
                      .tr,
            ),
          ),
          SizedBox(height: 10),
          //   city
          TextField(
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
            controller: cityController,
            maxLength: 100,
            onChanged: (value) {
              setState(() {
                city = value;
              });
            },
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0)),
              labelText: 'City'.tr,
              labelStyle: GoogleFonts.poppins(
                color: Colors.black,
              ),
              hintText: 'City: ${sharedPreferences!.getString('city')}'.tr,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
      showConfirmBtn: false,
      cancelBtnText: "Update".tr,
      onCancelBtnTap: () {
        db.doc(sharedPreferences!.getString("uid")).update({
          'description': descController.text.trim(),
          'city': cityController.text.trim()
        });
        sharedPreferences!.setString('description', descController.text);
        sharedPreferences!.setString('city', cityController.text);
        Get.back();
        QuickAlert.show(
          context: context,
          barrierDismissible: false,
          type: QuickAlertType.success,
          title: 'Dat Updated'.tr,
          text: "Your Data has been updated successfully.",
          showConfirmBtn: true,
          showCancelBtn: false,
          confirmBtnText: "Confirm".tr,
          onConfirmBtnTap: () {
            // sendNotification(message);

            _refresh();
            Get.back();
          },
        );
      },
      cancelBtnTextStyle: TextStyle(color: Colors.green),
    );
  }

  void sendNotification(String message) {
    db.doc(user!.uid).get().then((value) {
      var data = value.data() as Map<String, dynamic>;
      var token = data['token'];
      var name = data['name'];
      var image = data['image'];
      var phone = data['phone'];
      var email = data['email'];

      var notification = {
        'title': 'Description Updated',
        'body': message,
        'image': image,
        'name': name,
        'phone': phone,
        'email': email,
        'balance': balance,
      };

      sendPushNotification(token, notification);
    });
  }

  void sendPushNotification(token, Map<String, dynamic> notification) {
    var url = 'https://fcm.googleapis.com/fcm/send';
    var header = {
      'Content-Type': 'application/json',
      'Authorization ': 'key=$NotificationPage.serverKey',
    };
    var request = {
      'notification': {
        'title': notification['title'],
        'body': notification['body'],
        'image': notification['image'],
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'statusN': 'done',
        'name': notification['name'],
        'phone': notification['phone'],
        'email': notification['email'],
        'description': notification['description'],
        'status': notification['status'],
        'createdAt': notification['createdAt'],
        'balance': notification['balance'],
      },
      'to': token,
    };

    http.post(Uri.parse(url), headers: header, body: jsonEncode(request)).then(
      (response) {
        if (response.statusCode == 200) {
          if (kDebugMode) {
            print('Notification sent successfully');
          }
        } else {
          if (kDebugMode) {
            print('Failed to send notification');
          }
        }
      },
    );
  }
}
