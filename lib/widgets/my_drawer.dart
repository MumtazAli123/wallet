import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/home/controllers/home_controller.dart';
import 'package:wallet/widgets/privacy_policy.dart';

import '../addressScreen/address_screen.dart';
import '../global/global.dart';
import 'mix_widgets.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final controller = Get.put(HomeController());
  TextEditingController phoneController = TextEditingController();

  String name = sharedPreferences!.getString('name') ?? '';
  String email = sharedPreferences!.getString('email') ?? '';
  String phoneNumber = sharedPreferences!.getString('phone') ?? '';
  final profileImage = sharedPreferences!.getString('image') ?? '';
  String city = sharedPreferences!.getString('city') ?? '';

  var url_launcher = Get.find<HomeController>();
  bool isSelect = false;
  var hintText = 'Phone';

  @override
  void initState() {
    super.initState();
    phoneController.text = phoneNumber;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Drawer(
        elevation: 10,
        // backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Colors.white,
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return ListView(
      children: [
        _buildHeader(),
        _buildBodyContent(),
      ],
    );
  }

  _buildHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.brown[400]),
      accountName: Text(name),
      accountEmail: Text(phoneNumber),
      otherAccountsPictures: [
        IconButton(
          onPressed: () {
            _editPhoneNum();
          },
          icon: const Icon(Icons.edit),
        ),
      ],
      currentAccountPicture: profileImage.isEmpty
          ? const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.brown,
              ),
            )
          : GFAvatar(
              backgroundImage: NetworkImage(profileImage),
            ),
    );
  }

  _buildBodyContent() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.email, color: Colors.orange),
          title: Text(email),
          onTap: () {
            // url_launcher.launch('mailto:$email');
            launch('mailto:$email');
          },
        ),
        ListTile(
          // address
          leading: const Icon(Icons.location_on),
          title: Text("City: $city"),
          onTap: () {
            Get.to(() => const AddressScreen());
          },
        ),
        ListTile(
          selectedColor: Colors.orange,
          leading: const Icon(Icons.reorder),
          title: const Text('New Orders'),
          onTap: () {
            // Navigator.of(context).pushNamed('/orders');
          },
        ),
        ListTile(
          leading: const Icon(Icons.hotel),
          title: const Text('Confirmed Orders'),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShiftedOrdersScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          onTap: () {
            Get.to(() => const PrivacyPolicyScreen());
          },
        ),
        ListTile(
          leading: const Icon(Icons.wallet_membership),
          title: const Text('Wallet'),
          onTap: () {
            Get.toNamed('/wallet');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            // Navigator.of(context).pushNamed('/gas');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            fAuth.signOut();
            Get.offAllNamed('/login');
          },
        ),
      ],
    );
  }

  void _editPhoneNum() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          content: TextField(
            maxLength: 13,
            keyboardType: TextInputType.phone,
            controller: phoneNumber.isNotEmpty
                ? phoneController
                : TextEditingController(text: phoneNumber),
            decoration:  const InputDecoration(
              hintText: 'Enter your phone number',

            ),

            onChanged: (value) {
              phoneNumber = value;
            },
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (phoneController.text.isNotEmpty) {
                  Navigator.pop(context);
                } else if (phoneController.text.length < 13) {
                  QuickAlert.show(
                    context: Get.context!,
                    type: QuickAlertType.error,
                    text: 'Phone number is too short',
                  );
                }
                  else {
                  QuickAlert.show(
                    context: Get.context!,
                    type: QuickAlertType.error,
                    text: 'Phone number cannot be empty',
                  );
                }
              },
              child:  eText('Cancel', color: Colors.red),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _savePhoneNum();
                });
              },
              child:  eText('Update', color: Colors.green),
            ),
          ],
        );
      },
    );
  }

  void _savePhoneNum() async {
    try {
      if(phoneController.text.isEmpty){
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          text: 'Phone number cannot be empty',
        );
        return;
      }else if(phoneController.text.length < 13){
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          text: 'Phone number is too short',
        );
        return;
      }else{
        phoneNumber = phoneController.text;
      }
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final query = await firebaseFirestore
          .collection("sellers")
          .where("phone", isEqualTo: phoneNumber)
          .get();
      return query.docs.isEmpty
          ? firebaseFirestore
              .collection('sellers')
              .doc(sharedPreferences!.getString('uid'))
              .update({'phone': phoneNumber}).then((value) {
              sharedPreferences!.setString('phone', phoneNumber);
              Navigator.pop(Get.context!);
              QuickAlert.show(
                context: Get.context!,
                type: QuickAlertType.success,
                text: 'Phone number updated successfully',
              );
            })
          : QuickAlert.show(
              context: Get.context!,
              type: QuickAlertType.error,
              text: 'Phone number already exists',

            );
    } catch (e) {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        text: e.toString(),
      );
    }
  }
}
