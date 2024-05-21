// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/global/global.dart';

import '../utils/utils.dart';

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

  bool isLoading = false;

  final _name = '';
  final _email = '';
  final _phone = '';
  final _image = '';

  void updateProfile() async {
    if (_name.isEmpty || _email.isEmpty || _phone.isEmpty) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'All fields are required');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await db.doc(currentUserId).update({
        'name': _name,
        'email': _email,
        'phone': _phone,
        'image': _image,
      });
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Profile updated successfully');
    } catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'An error occurred');
    }
    setState(() {
      isLoading = false;
    });
  }

  FocusNode focusNode = FocusNode();

  Uint8List? image;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        image = img;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _getUserProfile();
  }

  @override
  void dispose() {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Profile'),
        background: Image.network(
          sharedPreferences!.getString('image')!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildProfileDetails() {
    return StreamBuilder(
        stream: db.doc(currentUserId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(data['name']),
            subtitle: Text(data['email']),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
          );
        });
  }
}
