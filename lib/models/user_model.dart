
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? username;
  String? email;
  String? phone;
  double? balance;
  String? image;
  String? sellerType;
  String? createdAt;
  String? updatedAt;
  String? uid;

  UserModel({
    this.uid,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.image,
    this.balance,
    this.sellerType,
    this.createdAt,
    this.updatedAt
  });

  // receiving data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      phone: map['phone'],
      name: map['name'],
      username: map['username'],
      image: map['image'],
      balance: map['balance'],
      sellerType: map['sellerType'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }






  // sending data to the server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'name': name,
      'image': image,
      'username': username,
      'balance': balance,
      'sellerType': sellerType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,

    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      phone: doc['phone'],
      name: doc['name'],
      username: doc['username'],
      image: doc['image'],
      balance: doc['balance'],
      sellerType: doc['sellerType'],
      createdAt: doc['createdAt'],
      updatedAt: doc['updatedAt'],
    );
  }
}