import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  String? pName;
  String? pPrice;
  String? pDescription;
  String? pBrand;
  String? pQuantity;
  String? pDiscount;
  String? pCategory;
  String? pCondition;
  String? pDelivery;
  String? pReturn;
  String? pDiscountType;
  String? pColor;
  String? pSize;
  String? pImages;
  Timestamp? pCreatedAt;
  String? pUniqueId;
  String? pSellerId;
  String? pSellerName;
  String? pSellerEmail;
  String? pSellerPhoto;
  String? pSellerAddress;
  String? pSellerPhone;
  String? pSellerCity;
  String? city;
  String? address;

  ProductsModel(
      {this.pName,
      this.pPrice,
      this.pDescription,
      this.pBrand,
      this.pQuantity,
      this.pDiscount,
      this.pCategory,
      this.pCondition,
      this.pDelivery,
      this.pReturn,
      this.pDiscountType,
      this.pColor,
      this.pSize,
      this.pImages,
      this.pCreatedAt,
      this.pUniqueId,
      this.pSellerId,
      this.pSellerName,
      this.pSellerEmail,
      this.pSellerPhoto,
      this.pSellerAddress,
      this.pSellerPhone,
      this.pSellerCity,
      this.city,
      this.address});

  static ProductsModel fromDataSnapshot(DocumentSnapshot snapshot) {
    return ProductsModel(
      pName: snapshot['pName'],
      pPrice: snapshot['pPrice'],
      pDescription: snapshot['pDescription'],
      pBrand: snapshot['pBrand'],
      pQuantity: snapshot['pQuantity'],
      pDiscount: snapshot['pDiscount'],
      pCategory: snapshot['pCategory'],
      pCondition: snapshot['pCondition'],
      pDelivery: snapshot['pDelivery'],
      pReturn: snapshot['pReturn'],
      pDiscountType: snapshot['pDiscountType'],
      pColor: snapshot['pColor'],
      pSize: snapshot['pSize'],
      pImages: snapshot['pImages'],
      pCreatedAt: snapshot['pCreatedAt'].toDate(),
      pUniqueId: snapshot['pUniqueId'],
      pSellerId: snapshot['pSellerId'],
      pSellerName: snapshot['pSellerName'],
      pSellerEmail: snapshot['pSellerEmail'],
      pSellerPhoto: snapshot['pSellerPhoto'],
      pSellerAddress: snapshot['pSellerAddress'],
      pSellerPhone: snapshot['pSellerPhone'],
      pSellerCity: snapshot['pSellerCity'],
      city: snapshot['city'],
      address: snapshot['address'],
    );
  }

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      pName: json['pName'],
      pPrice: json['pPrice'],
      pDescription: json['pDescription'],
      pBrand: json['pBrand'],
      pQuantity: json['pQuantity'],
      pDiscount: json['pDiscount'],
      pCategory: json['pCategory'],
      pCondition: json['pCondition'],
      pDelivery: json['pDelivery'],
      pReturn: json['pReturn'],
      pDiscountType: json['pDiscountType'],
      pColor: json['pColor'],
      pSize: json['pSize'],
      pImages: json['pImages'],
      pCreatedAt: json['pCreatedAt'],
      pUniqueId: json['pUniqueId'],
      pSellerId: json['pSellerId'],
      pSellerName: json['pSellerName'],
      pSellerEmail: json['pSellerEmail'],
      pSellerPhoto: json['pSellerPhoto'],
      pSellerAddress: json['pSellerAddress'],
      pSellerPhone: json['pSellerPhone'],
      pSellerCity: json['pSellerCity'],
      city: json['city'],
      address: json['address'],
    );
  }


  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pName'] = pName;
    data['pPrice'] = pPrice;
    data['pDescription'] = pDescription;
    data['pBrand'] = pBrand;
    data['pQuantity'] = pQuantity;
    data['pDiscount'] = pDiscount;
    data['pCategory'] = pCategory;
    data['pCondition'] = pCondition;
    data['pDelivery'] = pDelivery;
    data['pReturn'] = pReturn;
    data['pDiscountType'] = pDiscountType;
    data['pColor'] = pColor;
    data['pSize'] = pSize;
    data['pImages'] = pImages;
    data['pCreatedAt'] = pCreatedAt;
    data['pUniqueId'] = pUniqueId;
    data['pSellerId'] = pSellerId;
    data['pSellerName'] = pSellerName;
    data['pSellerEmail'] = pSellerEmail;
    data['pSellerPhoto'] = pSellerPhoto;
    data['pSellerAddress'] = pSellerAddress;
    data['pSellerPhone'] = pSellerPhone;
    data['pSellerCity'] = pSellerCity;
    data['city'] = city;
    data['address'] = address;
    return data;
  }
}
