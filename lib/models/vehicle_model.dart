import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  String? email;
  String? image;
  String? sellerImage;
  int? likeCount;
  String? phone;
  String? address;
  String? city;
  Timestamp? publishedDate;
  String? sellerId;
  String? sellerName;
  String? showroomName;
  String? status;
  Timestamp? updatedDate;
  String? vehicleAmenities;
  String? vehicleBodyType;
  String? vehicleColor;
  String? vehicleCondition;
  String? vehicleDescription;
  String? vehicleFuelType;
  String? vehicleId;
  String? vehicleKm;
  String? vehicleModel;
  String? vehicleName;
  String? vehiclePrice;
  String? vehicleStatus;
  String? vehicleTransmission;
  String? vehicleType;
  String? currency;

  VehicleModel({
    this.email,
    this.image,
    this.sellerImage,
    this.likeCount,
    this.phone,
    this.publishedDate,
    this.address,
    this.city,
    this.sellerId,
    this.sellerName,
    this.showroomName,
    this.status,
    this.updatedDate,
    this.vehicleAmenities,
    this.vehicleBodyType,
    this.vehicleColor,
    this.vehicleCondition,
    this.vehicleDescription,
    this.vehicleFuelType,
    this.vehicleId,
    this.vehicleKm,
    this.vehicleModel,
    this.vehicleName,
    this.vehiclePrice,
    this.vehicleStatus,
    this.vehicleTransmission,
    this.vehicleType,
    this.currency,
  });

  static VehicleModel fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnap = snapshot.data() as Map<String, dynamic>;
    return VehicleModel(
      email: dataSnap['email'],
      image: dataSnap['image'],
      sellerImage: dataSnap['sellerImage'],
      likeCount: dataSnap['likeCount'],
      phone: dataSnap['phone'],
      address: dataSnap['address'],
      city: dataSnap['city'],
      publishedDate: dataSnap['publishedDate'],
      sellerId: dataSnap['sellerId'],
      sellerName: dataSnap['sellerName'],
      showroomName: dataSnap['showroomName'],
      status: dataSnap['status'],
      updatedDate: dataSnap['updatedDate'],
      vehicleAmenities: dataSnap['vehicleAmenities'],
      vehicleBodyType: dataSnap['vehicleBodyType'],
      vehicleColor: dataSnap['vehicleColor'],
      vehicleCondition: dataSnap['vehicleCondition'],
      vehicleDescription: dataSnap['vehicleDescription'],
      vehicleFuelType: dataSnap['vehicleFuelType'],
      vehicleId: dataSnap['vehicleId'],
      vehicleKm: dataSnap['vehicleKm'],
      vehicleModel: dataSnap['vehicleModel'],
      vehicleName: dataSnap['vehicleName'],
      vehiclePrice: dataSnap['vehiclePrice'],
      vehicleStatus: dataSnap['vehicleStatus'],
      vehicleTransmission: dataSnap['vehicleTransmission'],
      vehicleType: dataSnap['vehicleType'],
      currency: dataSnap['currency'],
    );
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      email: json['email'],
      image: json['image'],
      sellerImage: json['sellerImage'],
      likeCount: json['likeCount'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      publishedDate: json['publishedDate'],
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      showroomName: json['showroomName'],
      status: json['status'],
      updatedDate: json['updatedDate'],
      vehicleAmenities: json['vehicleAmenities'],
      vehicleBodyType: json['vehicleBodyType'],
      vehicleColor: json['vehicleColor'],
      vehicleCondition: json['vehicleCondition'],
      vehicleDescription: json['vehicleDescription'],
      vehicleFuelType: json['vehicleFuelType'],
      vehicleId: json['vehicleId'],
      vehicleKm: json['vehicleKm'],
      vehicleModel: json['vehicleModel'],
      vehicleName: json['vehicleName'],
      vehiclePrice: json['vehiclePrice'],
      vehicleStatus: json['vehicleStatus'],
      vehicleTransmission: json['vehicleTransmission'],
      vehicleType: json['vehicleType'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'image': image,
      'sellerImage': sellerImage,
      'likeCount': likeCount,
      'phone': phone,
      'address': address,
      'city': city,
      'publishedDate': publishedDate,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'showroomName': showroomName,
      'status': status,
      'updatedDate': updatedDate,
      'vehicleAmenities': vehicleAmenities,
      'vehicleBodyType': vehicleBodyType,
      'vehicleColor': vehicleColor,
      'vehicleCondition': vehicleCondition,
      'vehicleDescription': vehicleDescription,
      'vehicleFuelType': vehicleFuelType,
      'vehicleId': vehicleId,
      'vehicleKm': vehicleKm,
      'vehicleModel': vehicleModel,
      'vehicleName': vehicleName,
      'vehiclePrice': vehiclePrice,
      'vehicleStatus': vehicleStatus,
      'vehicleTransmission': vehicleTransmission,
      'vehicleType': vehicleType,
      'currency': currency,
    };
  }
}
