import 'package:cloud_firestore/cloud_firestore.dart';

class CityModel {
   String? cityName;
   String? country;
   String? cityImage;
   String? cityId ;
   String? description ;
   String? sellerUID;
   String? latitude;
   String? longitude ;
   String? startingFrom ;
   Timestamp? publishDate;
   Timestamp? updateDate;


  CityModel({
    this.cityName,
    this.country,
    this.cityImage,
    this.cityId,
    this.description,
    this.sellerUID,
    this.latitude,
    this.longitude,
    this.startingFrom,
    this.publishDate,
    this.updateDate,
  });

  toJson() {
    return {
      "cityName": cityName,
      "country": country,
      "imageUrl": cityImage,
      "cityId": cityId,
      "description": description,
      "sellerUID": sellerUID,
      "latitude": latitude,
      "longitude": longitude,
      "startingFrom": startingFrom,
      "publishDate": publishDate,
      "updateDate": updateDate,
    };
  }

  CityModel.fromJson(Map<String, dynamic> json) {
    cityName = json['cityName'];
    country = json['country'];
    cityImage = json['imageUrl'];
    cityId = json['cityId'];
    description = json['description'];
    sellerUID = json['sellerUID'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    startingFrom = json['startingFrom'];
    publishDate = json['publishDate'];
    updateDate = json['updateDate'];
  }
}