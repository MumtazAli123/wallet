class AddressModel{
  String? name;
  String? address;
  String? email;
  String? fCity;
  String? state;
  String? country;
  String? phone;
  double? balance;
  String? alternateMobileNumber;
  String? completeAddress;
  String? addressId;

  AddressModel({
    this.name,
    this.address,
    this.email,
    this.fCity,
    this.state,
    this.country,
    this.phone,
    this.balance,
    this.alternateMobileNumber,
    this.completeAddress,
    this.addressId

  });

  AddressModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    address = json['address'];
    email = json['email'];
    fCity = json['city'];
    state = json['state'];
    country = json['country'];
    phone = json['phone'];
    balance = json['balance'];
    alternateMobileNumber = json['alternateMobileNumber'];
    completeAddress = json['completeAddress'];
    addressId = json['addressId'];
  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['email'] = email;
    data['city'] = fCity;
    data['state'] = state;
    data['country'] = country;
    data['phone'] = phone;
    data['balance'] = balance;
    data['alternateMobileNumber'] = alternateMobileNumber;
    data['completeAddress'] = completeAddress;
    data['addressId'] = addressId;
    return data;
  }
}