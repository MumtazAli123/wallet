import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  String? email;
  String? image;
  int? likeCount;
  String? phone;
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

  VehicleModel({
    this.email,
    this.image,
    this.likeCount,
    this.phone,
    this.publishedDate,
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
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      email: json['email'],
      image: json['image'],
      likeCount: json['likeCount'],
      phone: json['phone'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'image': image,
      'likeCount': likeCount,
      'phone': phone,
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
    };
  }
}
