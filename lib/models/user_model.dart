import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? username;
  String? email;
  String? phone;
  double? balance;
  String? lastTransaction;
  String? image;
  String? sellerType;
  String? status;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? uid;
  String? sellerDeviceToken;
  String? city;
  String? address;

  UserModel(
      {this.uid,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.image,
      this.balance,
      this.status,
      this.description,
      this.lastTransaction,
      this.sellerType,
      this.createdAt,
      this.updatedAt,
      this.sellerDeviceToken,
      this.city,
      this.address});

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
        description: map['description'],
        lastTransaction: map['lastTransaction'],
        sellerType: map['sellerType'],
        status: map['status'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        sellerDeviceToken: map['sellerDeviceToken'],
        city: map['city'],
        address: map['address']);
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
      'lastTransaction': lastTransaction,
      'sellerType': sellerType,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'sellerDeviceToken': sellerDeviceToken,
      'city': city,
      'address': address
    };
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    username = json['username'];
    image = json['image'];
    balance = json['balance'];
    description = json['description'];
    lastTransaction = json['lastTransaction'];
    sellerType = json['sellerType'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sellerDeviceToken = json['sellerDeviceToken'];
    city = json['city'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['phone'] = phone;
    data['name'] = name;
    data['username'] = username;
    data['image'] = image;
    data['balance'] = balance;
    data['description'] = description;
    data['lastTransaction'] = lastTransaction;
    data['sellerType'] = sellerType;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['sellerDeviceToken'] = sellerDeviceToken;
    data['city'] = city;
    data['address'] = address;
    return data;
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
        description: doc['description'],
        lastTransaction: doc['lastTransaction'],
        sellerType: doc['sellerType'],
        status: doc['status'],
        createdAt: doc['createdAt'],
        updatedAt: doc['updatedAt'],
        sellerDeviceToken: doc['sellerDeviceToken'],
        city: doc['city'],
        address: doc['address']);
  }
}
