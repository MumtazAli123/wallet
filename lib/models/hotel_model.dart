import 'package:cloud_firestore/cloud_firestore.dart';

class HotelsModel {
  String? hotelId;
  String? sellerName;
  String? phone;
  String? sellerId;
  String? email;
  String? hotelName;
  String? city;
  String? image;
  String? rooms;
  String? description;
  String? startingFrom;
  String? bar;
  String? restaurant;
  String? gym;
  String? pool;
  String? spa;
  String? parking;
  String? wifi;
  String? breakfast;
  String? rating;
  String? status;
  String? hotelType;
  Timestamp? publishedDate;
  Timestamp? updatedAt;

  HotelsModel({
    this.hotelId,
    this.sellerName,
    this.sellerId,
    this.phone,
    this.email,
    this.hotelName,
    this.city,
    this.image,
    this.rooms,
    this.description,
    this.startingFrom,
    this.bar,
    this.restaurant,
    this.gym,
    this.pool,
    this.spa,
    this.parking,
    this.wifi,
    this.breakfast,
    this.rating,
    this.status,
    this.hotelType,
    this.publishedDate,
    this.updatedAt,
  });

  toJson() {
    return {
      'hotelId': hotelId,
      'sellerName': sellerName,
      'sellerId': sellerId,
      'phone': phone,
      'email': email,
      'hotelName': hotelName,
      'city': city,
      'image': image,
      'rooms': rooms,
      'description': description,
      'startingFrom': startingFrom,
      'bar': bar,
      'restaurant': restaurant,
      'gym': gym,
      'pool': pool,
      'spa': spa,
      'parking': parking,
      'wifi': wifi,
      'breakfast': breakfast,
      'rating': rating,
      'status': status,
      'hotelType': hotelType,
      'publishedDate': publishedDate,
      'updatedAt': updatedAt,
    };
  }

  HotelsModel.fromJson(Map<String, dynamic> json) {
    hotelId = json['hotelId'];
    sellerName = json['sellerName'];
    sellerId = json['sellerId'];
    phone = json['phone'];
    email = json['email'];
    hotelName = json['hotelName'];
    city = json['city'];
    image = json['image'];
    rooms = json['rooms'];
    description = json['description'];
    startingFrom = json['startingFrom'];
    bar = json['bar'];
    restaurant = json['restaurant'];
    gym = json['gym'];
    pool = json['pool'];
    spa = json['spa'];
    parking = json['parking'];
    wifi = json['wifi'];
    breakfast = json['breakfast'];
    rating = json['rating'];
    status = json['status'];
    hotelType = json['hotelType'];
    publishedDate = json['publishedDate'];
    updatedAt = json['updatedAt'];
  }
}
