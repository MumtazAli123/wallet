import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/address_model.dart';
import 'package:wallet/models/user_model.dart';


class SaveFriendsController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String completeAddress = '';

  final TextEditingController transferNominalController =
  TextEditingController();
  final descriptionController = TextEditingController();
  UserModel loggedInUser = UserModel();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
  List<UserModel> otherUsers = [];
  bool isLoading = false;

  final count = 0.obs;
  UserModel? userModel;


  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('SaveFriendsController onInit');
    }

  }

  @override
  void onReady() {
    super.onReady();
    if (kDebugMode) {
      print('SaveFriendsController onReady');
    }
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

  void sendMoneyToFriends(AddressModel addressModel) {
    QuickAlert.show(
      context: Get.overlayContext!,
      title: 'Send Money to ${addressModel.name}',
      text: 'Enter amount and description',
      type: QuickAlertType.info,
      width: 400,
      widget: Column(
        children: [
          TextFormField(
            controller: transferNominalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter amount',
            ),
            onChanged: (value) {
              amount = double.parse(value);
            },
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter description',
            ),
            onChanged: (value) {
              description = value;
            },
          ),
        ],
      ),
      confirmBtnText: 'Send',
      onConfirmBtnTap: () {
        Get.back();
        buildWeAreWorkingOnIt( loggedInUser);
      },
    );
  }

  void buildWeAreWorkingOnIt(UserModel userModel) {
    QuickAlert.show(
      context: Get.overlayContext!,
      title: 'We are working on it',
      text: 'This feature is under development',
      type: QuickAlertType.info,
      width: 400,
      widget: Column(
        children: [
          const Divider(),
           const SizedBox(height: 10.0),
           Text(
              'Dear : ${sharedPreferences!.getString('name')}\n'
              'We are working on this feature. We will notify you once it is ready to use.\n\n'
                  'Thank you for your patience.\n\n'
                  'Regards\n'
                  'Wallet Team',


              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () {
        Get.back();
      },
    );
  }

}
