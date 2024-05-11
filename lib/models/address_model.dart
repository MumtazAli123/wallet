class AddressModel{
  String? name;
  String? address;
  String? email;
  String? city;
  String? state;
  String? country;
  String? phone;
  String? alternateMobileNumber;
  String? completeAddress;
  String? addressId;

  AddressModel({
    this.name,
    this.address,
    this.email,
    this.city,
    this.state,
    this.country,
    this.phone,
    this.alternateMobileNumber,
    this.completeAddress,
    this.addressId

  });

  AddressModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    address = json['address'];
    email = json['email'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    phone = json['phone'];
    alternateMobileNumber = json['alternateMobileNumber'];
    completeAddress = json['completeAddress'];
    addressId = json['addressId'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['email'] = email;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['phone'] = phone;
    data['alternateMobileNumber'] = alternateMobileNumber;
    data['completeAddress'] = completeAddress;
    data['addressId'] = addressId;
    return data;
  }
}