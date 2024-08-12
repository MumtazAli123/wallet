import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';

import '../../../../models/address_model.dart';
import '../../../../models/user_model.dart';
import '../../../../provider/address_changer.dart';
import '../../../../widgets/mix_widgets.dart';

class FriendsDesignWidget extends StatefulWidget {
  final AddressModel? addressModel;
  final int? index;
  final int? value;
  final String? addressId;
  final double? amount;
  final String? sellerUid;
  const FriendsDesignWidget(
      {super.key,
      this.addressModel,
      this.index,
      this.value,
      this.addressId,
      this.amount,
      this.sellerUid});

  @override
  State<FriendsDesignWidget> createState() => _FriendsDesignWidgetState();
}

class _FriendsDesignWidgetState extends State<FriendsDesignWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final db = FirebaseFirestore.instance;
  UserModel loggedInUser = UserModel();
  // double updatedBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount.toString();
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            //  friends info here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Radio(
                    value: widget.index,
                    groupValue: widget.value,
                    onChanged: (value) {
                      Provider.of<AddressChanger>(context, listen: false)
                          .showSelectedFriends(value);
                    }),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 110,
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text('Name:'),
                            Text(widget.addressModel!.name.toString()),
                          ]),
                          const TableRow(children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ]),
                          TableRow(children: [
                            const Text('Phone:'),
                            Text(widget.addressModel!.phone.toString()),
                          ]),
                          const TableRow(children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ]),
                          TableRow(children: [
                            const Text('Address:'),
                            Text(widget.addressModel!.address.toString()),
                          ]),
                          const TableRow(children: [
                            SizedBox(height: 15.0),
                            SizedBox(height: 15.0),
                          ]),
                          TableRow(children: [
                            const Text('City'),
                            Text(widget.addressModel!.fCity.toString()),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            //   button here
            //   widget.value == Provider.of<AddressChanger>(context).counter ?
            //             ElevatedButton(onPressed: (){}, child: const Text('Proceed'),)
            //                 : Container(),
            widget.value == Provider.of<AddressChanger>(context).count
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.green),
                        ),
                        onPressed: () {
                          _buildDialogSendMoney(
                              context,
                              widget.addressModel!.name,
                              widget.addressModel!.phone,
                              widget.addressModel!.address,
                              widget.addressModel!.fCity,
                              widget.amount,
                              widget.sellerUid);
                        },
                        child: wText('Proceed', color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _buildDialogSendMoney(BuildContext context, String? name, String? phone, String? address, String? fCity, double? amount, String? sellerUid) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            height: 400.0,
            width: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                wText('Send Money to:'),
                const SizedBox(height: 10.0),
                wText(name!),
                wText(phone!),
                wText(address!),
                wText(fCity!),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Amount',
                  ),
                ),
                const SizedBox(height: 10.0),
                // description
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Description',
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    _buildSendMoney(context, name, phone, address, fCity, amount, sellerUid, _amountController.text, _descriptionController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: wText('Payment Successful'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: wText('Proceed', color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _buildSendMoney(BuildContext context, String name, String phone, String address, String fCity, double? amount, String? sellerUid, String text, String text2) {
    QuickAlert.show(
      context: context,
      title: 'Send Money',
      text: 'Are you sure you want to send money to $name?',
      type: QuickAlertType.confirm,
            width: 200.0,
            widget: Column(
              children: [
                wText('Name: $name'),
                wText('Phone: $phone'),
                wText('Address: $address'),
                wText('City: $fCity'),
                wText('Amount: $text'),
                wText('Description: $text2'),
              ],
            ),
      onConfirmBtnTap: () {
        Get.back();
        _buildSaveFriend(context, name, phone, address, fCity, amount, sellerUid, text, text2);
      },


            // Provider.of<AddressChanger>(context, listen: false).removeAddress
    );
  }

  Future<void> _buildSaveFriend(BuildContext context, String name, String phone, String address, String fCity, double? amount, String? sellerUid, String text, String text2) async {
    final db = FirebaseFirestore.instance;
    if (uid != null && loggedInUser.balance != null) {
      String enteredValue = _amountController.text.trim();

      int transferAmount = int.tryParse(enteredValue) ?? 0;

      if (loggedInUser.balance != null &&
          loggedInUser.balance! >= transferAmount) {
        double updatedBalance = loggedInUser.balance! - transferAmount;


        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(sellerUid)
            .update({'balance': updatedBalance});

        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(uid)
            .update({'balance': updatedBalance});

        db.collection('users')
            .doc(sharedPreferences!.getString('uid'))
            .collection('statement')
            .add({
          'name': name,
          'phone': phone,
          'address': address,
          'city': fCity,
          'amount': _amountController.text.trim(),
          'description': _descriptionController.text.trim(),
          'image': 'No Image',
          "balance": updatedBalance,
          'type': "receive",
          'status': 'pending',
          'created_at': DateTime.now(),
          'transaction_id': DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
        });
        QuickAlert.show(
          context: Get.context!,
          title: 'Send Money',
          text: 'Money sent to $name',
          type: QuickAlertType.success,
        );
      }
    } else {
      QuickAlert.show(
        context: context,
        title: 'Send Money',
        text: 'Insufficient Balance',
        type: QuickAlertType.error,
      );
    }
  }

}
