import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/address_model.dart';
import '../../../../provider/address_changer.dart';

class FriendsDesignWidget extends StatefulWidget {
  final AddressModel? addressModel;
  final int? index;
  final int? value;
  final String? addressId;
  final double? amount;
  final String? sellerUid;
  const FriendsDesignWidget({super.key, this.addressModel, this.index, this.value, this.addressId, this.amount, this.sellerUid});




  @override
  State<FriendsDesignWidget> createState() => _FriendsDesignWidgetState();
}

class _FriendsDesignWidgetState extends State<FriendsDesignWidget> {
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
             child: Row(
               children:[
                 Radio(
                     value: widget.index,
                     groupValue: widget.value,
                     onChanged: (value) {
                       Provider.of<AddressChanger>(context, listen: false).showSelectedFriends(value);
                     }
                 ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 110,
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                const Text('Name:'),
                                Text(widget.addressModel!.name.toString()),
                              ]
                            ),
                            const TableRow(
                                children: [
                                  SizedBox(height: 15.0),
                                  SizedBox(height: 15.0),
                                ]
                            ),
                            TableRow(
                                children: [
                                  const Text('Phone:'),
                                  Text(widget.addressModel!.phone.toString()),
                                ]
                            ),
                            const TableRow(
                                children: [
                                  SizedBox(height: 15.0),
                                  SizedBox(height: 15.0),
                                ]
                            ),
                            TableRow(
                                children: [
                                  const Text('Address:'),
                                  Text(widget.addressModel!.address.toString()),
                                ]
                            ),
                            const TableRow(
                                children: [
                                  SizedBox(height: 15.0),
                                  SizedBox(height: 15.0),
                                ]
                            ),
                            TableRow(
                                children: [
                                  const Text('City'),
                                  Text(widget.addressModel!.fCity.toString()),
                                ]
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
               ]
             ),
           ),
          //   button here
            widget.value == Provider.of<AddressChanger>(context).counter ?
                ElevatedButton(onPressed: (){}, child: const Text('Proceed'),)
                : Container(),

          ],
        ),
      ),
    );
  }
}
