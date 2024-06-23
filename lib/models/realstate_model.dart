import 'package:cloud_firestore/cloud_firestore.dart';

class RealStateModel {
  String? realStateId;
  String? sellerName;
  String? phone;
  String? sellerId;
  String? email;
  String? realStateName;
  String? city;
  String? image;
  String? state;
  String? description;
  String? startingFrom;
  String? realStateType;
  String? realStateStatus;
  String? gym;
  String? pool;
  String? spa;
  String? parking;
  String? condition;
  String? rating;
  String? status;
  Timestamp? publishedDate;
  Timestamp? updatedAt;

  RealStateModel({
    this.realStateId,
    this.sellerName,
    this.sellerId,
    this.phone,
    this.email,
    this.realStateName,
    this.city,
    this.image,
    this.state,
    this.description,
    this.startingFrom,
    this.realStateType,
    this.realStateStatus,
    this.gym,
    this.pool,
    this.spa,
    this.parking,
    this.condition,
    this.rating,
    this.status,
    this.publishedDate,
    this.updatedAt,
  });

  toJson() {
    return {
      'realStateId': realStateId,
      'sellerName': sellerName,
      'sellerId': sellerId,
      'phone': phone,
      'email': email,
      'realStateName': realStateName,
      'city': city,
      'image': image,
      'state': state,
      'description': description,
      'startingFrom': startingFrom,
      'realStateType': realStateType,
      'realStateStatus': realStateStatus,
      'gym': gym,
      'pool': pool,
      'spa': spa,
      'parking': parking,
      'condition': condition,
      'rating': rating,
      'status': status,
      'publishedDate': publishedDate,
      'updatedAt': updatedAt,
    };
  }

  RealStateModel.fromJson(Map<String, dynamic> json) {
    realStateId = json['realStateId'];
    sellerName = json['sellerName'];
    sellerId = json['sellerId'];
    phone = json['phone'];
    email = json['email'];
    realStateName = json['realStateName'];
    city = json['city'];
    image = json['image'];
    state = json['state'];
    description = json['description'];
    startingFrom = json['startingFrom'];
    realStateType = json['realStateType'];
    realStateStatus = json['realStateStatus'];
    gym = json['gym'];
    pool = json['pool'];
    spa = json['spa'];
    parking = json['parking'];
    condition = json['condition'];
    rating = json['rating'];
    status = json['status'];
    publishedDate = json['publishedDate'];
    updatedAt = json['updatedAt'];
  }
}
