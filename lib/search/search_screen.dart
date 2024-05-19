// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

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

  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.all(10.0),

          height: 40.0,
          child:  _isSearching ? _buildSearchField() : Text('Search'),
        ),
        actions: _buildActions(),
      ),
      body: _searchOtherUserList.isEmpty
          ? Center(
              child: Text(
                _isSearching ? 'No users found' : 'Start searching',
                style: TextStyle(fontSize: 20),
              ),
            )
          : StreamBuilder(
              stream: db.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _searchOtherUserList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20.0,
                              // user profile image box fit to cover
                              child: Image.network(
                                  "${snapshot.data!.docs[index]['image']}",
                                  fit: BoxFit.cover, errorBuilder:
                                      (BuildContext context, Object exception,
                                          StackTrace? stackTrace) {
                                return Icon(Icons.account_circle,
                                    size: 50, color: Colors.grey);
                              }, loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                }
                              }),
                            ),
                            title: Text(_searchOtherUserList[index]),
                            subtitle:
                                Text('${snapshot.data!.docs[index]['name']}'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              _buildTextFieldDialog(context, index);
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }

  _buildSearchField() {
    return TextField(
      controller: _searchController,
      // cursorColor: Colors.white,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Enter Phone Number...',
        helperText: 'Search by phone like +921234567890',
      ),
      style: TextStyle(fontSize: 16.0),
      onChanged: (query) {
        if (query.isNotEmpty) {
          _search(query);
        } else {
          setState(() {
            _searchOtherUserList.clear();
          });
        }
      },
    );
  }

  _buildActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            if (_searchController.text.isEmpty) {
              setState(() {
                _isSearching = false;
                _searchOtherUserList.clear();
              });
            } else {
              _searchController.clear();
            }
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ];
    }
  }

  void _search(String query) {
    var users = db.where('phone', isEqualTo: query).snapshots();
    users.forEach((element) {
      element.docs.forEach((element) {
        if (element['uid'] != currentUserId) {
          // search name and phone number
          setState(() {
            _searchOtherUserList.add(element['phone']);
          });
        }
      });
    });
  }

  void _buildTextFieldDialog(BuildContext context, int index) {
    QuickAlert.show(context: context,
        type: QuickAlertType.info,
        title: 'Send Request',
      text: "Do you want to send money request to ${_searchOtherUserList[index]}?",
      widget: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter Amount',
            ),
          ),
        ],
      ),
    );
  }
}
