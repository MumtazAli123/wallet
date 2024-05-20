// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/statement/views/statement_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _searchOtherUserList = [];
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
            // child: Text('Search'),
          ),
        ));
  }

  _buildSliverAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        // search Box , on background image
        child: Container(
          height: 90.0,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            padding: EdgeInsets.all(10.0),
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: TextField(
                maxLength: 13,
                controller: _searchController,
                keyboardType: TextInputType.phone,
                // when finish type return the keyboard
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  helperText: 'Search by phone like +923123456789',
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _search(value);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _search(String value) {
    try {
      if (value == currentUserId) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'You cannot search yourself');
      } else {
        FirebaseFirestore.instance
            .collection('sellers')
            .where('phone', isEqualTo: value)
            .get()
            .then((QuerySnapshot querySnapshot) {
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
