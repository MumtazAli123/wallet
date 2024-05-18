import 'package:cloud_firestore/cloud_firestore.dart';

class RoomsModel {
  String? roomId;
  String? roomType;
  String? roomName;
  String? wifi;
  String? acTypes;
  String? description;
  String? image;
  String? hotelId;
  String? city;
  String? rating;
  String? hotelName;
  String? price;
  Timestamp? publishedDate;
  String? sellerId;
  String? sellerName;
  String? sellerPhone;
  String? sellerEmail;
  String? services;
  String? smoking;
  String? status;
  Timestamp? updatedDate;

  RoomsModel({
    this.roomId,
    this.roomType,
    this.roomName,
    this.wifi,
    this.acTypes,
    this.description,
    this.image,
    this.city,
    this.rating,
    this.hotelId,
    this.hotelName,
    this.price,
    this.publishedDate,
    this.sellerId,
    this.sellerName,
    this.sellerPhone,
    this.sellerEmail,
    this.services,
    this.smoking,
    this.status,
    this.updatedDate,
  });

  toList() {
    return {
      'roomId': roomId,
      'roomType': roomType,
      'roomName': roomName,
      'wifi': wifi,
      'acTypes': acTypes,
      'description': description,
      'image': image,
      'city': city,
      'rating': rating,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'price': price,
      'publishedDate': publishedDate,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'sellerEmail': sellerEmail,
      'services': services,
      'smoking': smoking,
      'status': status,
      'updatedDate': updatedDate,
    };
  }

  RoomsModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    roomType = json['roomType'];
    roomName = json['roomName'];
    wifi = json['wifi'];
    acTypes = json['acTypes'];
    description = json['description'];
    image = json['image'];
    city = json['city'];
    rating = json['rating'];
    hotelId = json['hotelId'];
    hotelName = json['hotelName'];
    price = json['price'];
    publishedDate = json['publishedDate'];
    sellerId = json['sellerId'];
    sellerName = json['sellerName'];
    sellerPhone = json['sellerPhone'];
    sellerEmail = json['sellerEmail'];
    services = json['services'];
    smoking = json['smoking'];
    status = json['status'];
    updatedDate = json['updatedDate'];
  }
}
