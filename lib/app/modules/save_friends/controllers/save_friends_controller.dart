import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/address_model.dart';
import 'package:wallet/models/user_model.dart';

import '../../send_money/views/send_money_friends_view.dart';

class SaveFriendsController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String completeAddress = '';

  final TextEditingController transferNominalController =
  TextEditingController();
  final descriptionController = TextEditingController();

  var description = '';
  double? amount;
  var name = '';
  var phone = '';
  var address = '';
  var city = '';


  var country = '';
  var countryCode = '';
  var flagUri = '';
  Country selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    // auto select country name
    name: 'Pakistan',
    example: "0300 1234567",
    displayName: "Pakistan",
    displayNameNoCountryCode: "PK",
    e164Key: "",
  );

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final count = 0.obs;
  UserModel? user;

  Future<void> fetchLoggedInUserBalance(String uid) async {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        user = UserModel(
          uid: value['uid'],
          name: value['name'],
          phone: value['phone'],
          balance: value['balance'],
        );
        print('user: $user');
        update();
      }
    });
  }

  Future<void> fetchUserData() async {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .get()
        .then((value) {
      if (value.exists) {
        user = UserModel(
          uid: value['uid'],
          name: value['name'],
          phone: value['phone'],
          balance: value['balance'],
        );
        print('user: $user');
        update();
      }
    });
  }


  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchLoggedInUserBalance(sharedPreferences!.getString('uid')!);
  }

  @override
  void onReady() {
    super.onReady();
    print('SaveFriendsController onReady');
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
  }

  void increment() => count.value++;

  void saveFriend(String uid, List<UserModel> otherUser) {
    completeAddress =
        '${addressController.text.trim()}, ${cityController.text.trim()}';
    if (formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('sellers')
          .doc(sharedPreferences!.getString('uid'))
          .collection('friends')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'uid': uid,
        'name': nameController.text.trim(),
        'phone': "${selectedCountry.phoneCode}${phoneController.text.trim()}",
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'country': selectedCountry.name,
        'balance': 0.0,
        'addressId': DateTime.now().millisecondsSinceEpoch.toString(),
      }).then((value) {
        Get.back();
        Get.snackbar('Success', 'Friend saved successfully');
        formKey.currentState!.reset();
      });
    }
  }

  void deleteFriend(String uid) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('friends')
        .doc(uid)
        .delete()
        .then((value) {
      // Get.back();
      Get.snackbar('Success', 'Friend deleted successfully', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    });
  }

  void sendMoneyToFriends(BuildContext context, AddressModel addressModel) {
    QuickAlert.show(
      type: QuickAlertType.custom,
      context: context,
      title: 'Send Money',
      width: 400,
      widget: Column(
        children: [
          TextFormField(
            controller: transferNominalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Transfer Nominal',
              hintText: 'Enter amount',
            ),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Enter description',
            ),
          ),
        ],
      ),
      onConfirmBtnTap: () {
        if (transferNominalController.text.isEmpty) {
          Get.snackbar('Error', 'Please enter amount');
        } else {
          amount = double.parse(transferNominalController.text);
          description = descriptionController.text;
          if (amount! > 0) {
            if (amount! <= addressModel.balance!) {
              FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(sharedPreferences!.getString('uid'))
                  .collection('transactions')
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set({
                'uid': addressModel.addressId,
                'name': addressModel.name,
                'phone': addressModel.phone,
                'address': addressModel.address,
                'city': addressModel.fCity,
                'country': addressModel.country,
                'amount': amount,
                'description': description,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('sellers')
                    .doc(sharedPreferences!.getString('uid'))
                    .collection('friends')
                    .doc(addressModel.addressId)
                    .update({
                  'balance': addressModel.balance! - amount!,
                }).then((value) {
                  Get.back();
                  Get.snackbar('Success', 'Money sent successfully');
                });
              });
            } else {
              Get.snackbar('Error', 'Insufficient balance');
            }
          } else {
            Get.snackbar('Error', 'Please enter valid amount');
          }
        }
      },
    );
  }

}
