class FriendsModel {
  String? name;
  String? phone;
  String? email;
  double? balance;
  String? lastTransaction;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? uid;
  String? description;

  FriendsModel(
      {this.uid,
      this.name,
      this.email,
      this.phone,
      this.balance,
      this.lastTransaction,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.description});

  // receiving data from the server

  factory FriendsModel.fromMap(map) {
    return FriendsModel(
      uid: map['uid'],
      email: map['email'],
      phone: map['phone'],
      name: map['name'],
      balance: map['balance'],
      lastTransaction: map['lastTransaction'],
      type: map['type'],
      status: map['status'],
      description: map['description'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // sending data to the server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'name': name,
      'balance': balance,
      'lastTransaction': lastTransaction,
      'type': type,
      'status': status,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
