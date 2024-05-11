class SellerModel {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? latitude;
  String? longitude;
  String? code;
  String? token;
  String? earning;
  String? balance;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? cart;

  SellerModel({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.earning,
    this.balance,
    this.latitude,
    this.longitude,
    this.code,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.cart,
  });

  SellerModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    earning = json['earning'];
    balance = json['balance'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    code = json['code'];
    token = json['token'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    cart = json['cart'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['earning'] = earning;
    data['balance'] = balance;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['code'] = code;
    data['token'] = token;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['status'] = status;
    data['cart'] = cart;
    return data;
  }

  static SellerModel? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    return SellerModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      image: data['image'],
      earning: data['earning'],
      balance: data['balance'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      code: data['code'],
      token: data['token'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      status: data['status'],
      cart: data['cart'],
    );
  }

  static Map<String, dynamic>? toMap(SellerModel? sellerModel) {
    if (sellerModel == null) {
      return null;
    }
    return {
      'uid': sellerModel.uid,
      'name': sellerModel.name,
      'email': sellerModel.email,
      'phone': sellerModel.phone,
      'image': sellerModel.image,
      'earning': sellerModel.earning,
      'balance': sellerModel.balance,
      'latitude': sellerModel.latitude,
      'longitude': sellerModel.longitude,
      'code': sellerModel.code,
      'token': sellerModel.token,
      'createdAt': sellerModel.createdAt,
      'updatedAt': sellerModel.updatedAt,
      'status': sellerModel.status,
      'cart': sellerModel.cart,
    };
  }

}