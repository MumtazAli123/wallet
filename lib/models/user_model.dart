class UserModel {
  String? userImage;
  String? userName;
  String? userEmail;
  String? password;
  String? userPhone;
  String? earnings;
  String? userType;
  String? userStatus;
  String? userCreatedAt;
  String? userUpdatedAt;
  String? userLastLogin;
  String? userCart;
  String? userWishlist;
  String? userToken;
  String? userDeviceId;
  String? userFcmToken;
  String? address;
  String? city;
  String? state;
  String? country;
  String? userId;
  String? balance;

  UserModel({
    this.userImage,
    this.userName,
    this.userEmail,
    this.earnings,
    this.password,
    this.userPhone,
    this.userType,
    this.userStatus,
    this.userCreatedAt,
    this.userUpdatedAt,
    this.userLastLogin,
    this.userCart,
    this.userWishlist,
    this.userToken,
    this.userDeviceId,
    this.userFcmToken,
    this.address,
    this.city,
    this.state,
    this.country,
    this.userId,
    this.balance,
  });


  UserModel.fromJson(Map<String, dynamic> json) {
    userImage = json['user_image'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    earnings = json['earnings'];
    password = json['password'];
    userPhone = json['user_phone'];
    userType = json['user_type'];
    userStatus = json['user_status'];
    userCreatedAt = json['user_created_at'];
    userUpdatedAt = json['user_updated_at'];
    userLastLogin = json['user_last_login'];
    userCart = json['user_cart'];
    userWishlist = json['user_wishlist'];
    userToken = json['user_token'];
    userDeviceId = json['user_device_id'];
    userFcmToken = json['user_fcm_token'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    userId = json['user_id'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_image'] = userImage;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['earnings'] = earnings;
    data['password'] = password;
    data['user_phone'] = userPhone;
    data['user_type'] = userType;
    data['user_status'] = userStatus;
    data['user_created_at'] = userCreatedAt;
    data['user_updated_at'] = userUpdatedAt;
    data['user_last_login'] = userLastLogin;
    data['user_cart'] = userCart;
    data['user_wishlist'] = userWishlist;
    data['user_token'] = userToken;
    data['user_device_id'] = userDeviceId;
    data['user_fcm_token'] = userFcmToken;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['user_id'] = userId;
    data['balance'] = balance;
    return data;
  }

}