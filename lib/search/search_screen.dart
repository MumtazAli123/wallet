// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _searchOtherUserList = [];
  String query = '';
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance.collection('sellers');

  final focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: _buildBody(_searchController.text.trim()),
        appBar: _buildAppBar(),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      // title: Text('Search'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        // search Box , on background image
        child: Container(
          height: 90.0,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: TextField(
              onTap: () {
                _searchController.clear();
              },
              maxLength: 13,
              controller: _searchController,
              keyboardType: TextInputType.phone,
              // when finish type return the keyboard
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                helperText: 'Search by phone like +923123456789',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  // _search(value);
                  otherUserSearchAll(value);

                }
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildBody(String value) {
    db.where('phone', isEqualTo: value).get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _searchOtherUserList.add(doc['phone']);
        return ListView.builder(
          itemCount: _searchOtherUserList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(doc['phone'],),
            );
          },
        );
      }
    });
  }

  Future<void> otherUserSearchAll(String value)async{
    try {
      if (value == currentUserId) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'You cannot search yourself');
      } else {
        db.where('phone', isEqualTo: value).get().then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _searchOtherUserList.add(doc['phone']);
            QuickAlert.show(
              context: context,
              animType: QuickAlertAnimType.slideInDown,
              type: QuickAlertType.values[3],
              title: 'User found',
              text: 'Do you want to send money to this user? use Qr code',
              widget: Column(
                children: [
                  // QrImage
                  QrImageView(
                    data: doc['phone'],
                    size: 150,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      child: Image.network(
                        doc['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Icon(Icons.account_circle,
                              size: 50, color: Colors.grey);
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    title: Text(doc['name']),
                    subtitle: Text(doc['phone']),
                  ),
                ],
              ),
              showCancelBtn: false,
              cancelBtnText: 'Close'.tr,
              showConfirmBtn: false,
            );
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

}

class SendMoneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
      ),
      body: Center(
        child: Text('Send Money'),
      ),
    );
  }
}