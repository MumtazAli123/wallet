
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
  double? balance;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? cart;
  double? rating;
  String? address;
  String? city;
  String? state;

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
    this.rating,
    this.address,
    this.city,
    this.state,
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
    rating = json['rating'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
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
    data['rating'] = rating;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    return data;
  }

  static SellerModel? fromMap(Map<String, dynamic> map) {
    return SellerModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      image: map['image'],
      earning: map['earning'],
      balance: map['balance'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      code: map['code'],
      token: map['token'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      status: map['status'],
      cart: map['cart'],
      rating: map['rating'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'earning': earning,
      'balance': balance,
      'latitude': latitude,
      'longitude': longitude,
      'code': code,
      'token': token,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
      'cart': cart,
      'rating': rating,
      'address': address,
      'city': city,
      'state': state,
    };
  }
}
