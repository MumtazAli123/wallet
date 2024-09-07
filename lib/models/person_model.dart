import 'package:cloud_firestore/cloud_firestore.dart';

class PersonModel {
  String? name;
  int? age;
  String? dob;
  String? phone;
  String? email;
  String? address;
  String? city;
  String? state;
  String? country;
  String? image;
  String? coverImage;
  String? bio;
  String? profileHeading;
  String? lookingForInAPartner;
  String? balance;
  String? createdAt;
  String? updatedAt;

  // Appearance
  String? height;
  String? bodyType;
  String? weight;
  String? gender;

//     Lifestyle
  String? smoking;
  String? drinking;
  String? maritalStatus;
  String? living;
  String? kids;
  String? wantKids;
  String? income;
  String? religion;
  String? nationality;
  String? languages;
  String? education;
  String? profession;
  String? ethnicity;

  PersonModel({
    this.name,
    this.age,
    this.dob,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.state,
    this.country,
    this.image,
    this.coverImage,
    this.bio,
    this.profileHeading,
    this.lookingForInAPartner,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.height,
    this.bodyType,
    this.weight,
    this.smoking,
    this.drinking,
    this.gender,
    this.maritalStatus,
    this.living,
    this.kids,
    this.wantKids,
    this.income,
    this.religion,
    this.nationality,
    this.languages,
    this.education,
    this.profession,
    this.ethnicity,
  });

  static PersonModel fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;
    return PersonModel(
      name: dataSnapshot['name'],
      age: dataSnapshot['age'],
      dob: dataSnapshot['dob'],
      phone: dataSnapshot['phone'],
      email: dataSnapshot['email'],
      address: dataSnapshot['address'],
      city: dataSnapshot['city'],
      state: dataSnapshot['state'],
      country: dataSnapshot['country'],
      image: dataSnapshot['image'],
      coverImage: dataSnapshot['coverImage'],
      bio: dataSnapshot['bio'],
      profileHeading: dataSnapshot['profileHeading'],
      lookingForInAPartner: dataSnapshot['lookingForInAPartner'],
      balance: dataSnapshot['balance'],
      createdAt: dataSnapshot['createdAt'],
      updatedAt: dataSnapshot['updatedAt'],
      height: dataSnapshot['height'],
      bodyType: dataSnapshot['bodyType'],
      weight: dataSnapshot['weight'],
      smoking: dataSnapshot['smoking'],
      drinking: dataSnapshot['drinking'],
      gender: dataSnapshot["gender"],
      maritalStatus: dataSnapshot['maritalStatus'],
      living: dataSnapshot['living'],
      kids: dataSnapshot['kids'],
      wantKids: dataSnapshot['wantKids'],
      income: dataSnapshot['income'],
      religion: dataSnapshot["religion"],
      nationality: dataSnapshot["nationality"],
      languages: dataSnapshot["languages"],
      education: dataSnapshot["education"],
      profession: dataSnapshot["profession"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'dob': dob,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'image': image,
      'coverImage': coverImage,
      'bio': bio,
      'profileHeading': profileHeading,
      'lookingForInAPartner': lookingForInAPartner,
      'balance': balance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'height': height,
      'bodyType': bodyType,
      'weight': weight,
      'smoking': smoking,
      'drinking': drinking,
      "gender": gender,
      'maritalStatus': maritalStatus,
      'living': living,
      'kids': kids,
      'wantKids': wantKids,
      'income': income,
      'religion': religion,
      'nationality': nationality,
      'languages': languages,
      'education': education,
      'profession': profession,
    };
  }

  static PersonModel fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'],
      age: json['age'],
      dob: json['dob'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      image: json['image'],
      coverImage: json['coverImage'],
      bio: json['bio'],
      profileHeading: json['profileHeading'],
      lookingForInAPartner: json['lookingForInAPartner'],
      balance: json['balance'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      height: json['height'],
      bodyType: json['bodyType'],
      weight: json['weight'],
      smoking: json['smoking'],
      drinking: json['drinking'],
      gender: json["gender"],
      maritalStatus: json['maritalStatus'],
      living: json['living'],
      kids: json['kids'],
      wantKids: json['wantKids'],
      income: json['income'],
      religion: json['religion'],
      nationality: json['nationality'],
      languages: json['languages'],
      education: json['education'],
      profession: json['profession'],
    );
  }
}
