import 'package:cloud_firestore/cloud_firestore.dart';

import '../global/global.dart';

class Brands {
  String? brandId;
  String? brandName;
  String? brandImage;
  String? brandDescription;
  Timestamp? publishDate;
  String? sellerUID;
  String? status;

  Brands({
    this.brandId,
    this.brandName,
    this.brandImage,
    this.brandDescription,
    this.publishDate,
    this.sellerUID,
    this.status,
  });

  Brands.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
    brandImage = json['brandImage'];
    brandDescription = json['brandDescription'];
    publishDate = json['publishDate'];
    sellerUID = json['sellerUID'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['brandId'] = brandId;
    data['brandName'] = brandName;
    data['brandImage'] = brandImage;
    data['brandDescription'] = brandDescription;
    data['publishDate'] = publishDate;
    data['sellerUID'] = sellerUID;
    data['status'] = status;
    return data;
  }

  Brands copyWith({
    String? brandId,
    String? brandName,
    String? brandImage,
    String? brandDescription,
    Timestamp? publishDate,
    String? sellerUID,
    String? status,
  }) {
    return Brands(
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      brandImage: brandImage ?? this.brandImage,
      brandDescription: brandDescription ?? this.brandDescription,
      publishDate: publishDate ?? this.publishDate,
      sellerUID: sellerUID ?? this.sellerUID,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Brands(brandId: $brandId, brandName: $brandName, brandImage: $brandImage, brandDescription: $brandDescription, publishDate: $publishDate, sellerUID: $sellerUID, status: $status)';
  }

  getBrands() {
    return FirebaseFirestore.instance.collection('sellers')
    .doc(sharedPreferences?.getString('uid'))
    .collection('brands')
    .snapshots();

  }

}