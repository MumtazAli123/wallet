import 'package:cloud_firestore/cloud_firestore.dart';

class RealStateModel {
  String? realStateId;
  String? sellerName;
  String? phone;
  String? sellerId;
  String? email;
  String? realStateName;
  String? city;
  String? address;
  String? image;
  String? state;
  String? country;
  String? description;
  String? startingFrom;
  String? furnishing;
  String? realStateType;
  String? realStateStatus;
  String? gym;
  String? pool;
  String? spa;
  String? parking;
  String? condition;
  String? rating;
  String? currency;
  String? status;
  Timestamp? publishedDate;
  Timestamp? updatedDate;

  RealStateModel({
    this.realStateId,
    this.sellerName,
    this.sellerId,
    this.phone,
    this.email,
    this.realStateName,
    this.city,
    this.address,
    this.image,
    this.state,
    this.country,
    this.description,
    this.startingFrom,
    this.furnishing,
    this.realStateType,
    this.realStateStatus,
    this.gym,
    this.pool,
    this.spa,
    this.parking,
    this.condition,
    this.rating,
    this.currency,
    this.status,
    this.publishedDate,
    this.updatedDate,
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
      'address': address,
      'image': image,
      'state': state,
      'country': country,
      'description': description,
      'startingFrom': startingFrom,
      'furnishing': furnishing,
      'realStateType': realStateType,
      'realStateStatus': realStateStatus,
      'gym': gym,
      'pool': pool,
      'spa': spa,
      'parking': parking,
      'condition': condition,
      'rating': rating,
      'currency': currency,
      'status': status,
      'publishedDate': publishedDate,
      'updatedDate': updatedDate,
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
    address = json['address'];
    image = json['image'];
    state = json['state'];
    country = json['country'];
    description = json['description'];
    startingFrom = json['startingFrom'];
    realStateType = json['realStateType'];
    realStateStatus = json['realStateStatus'];
    gym = json['gym'];
    pool = json['pool'];
    spa = json['spa'];
    parking = json['parking'];
    condition = json['condition'];
    furnishing = json['furnishing'];
    rating = json['rating'];
    currency = json['currency'];
    status = json['status'];
    publishedDate = json['publishedDate'];
    updatedDate = json['updatedDate'];
  }
}
