class BalanceModel{
  String? id;
  String? name;
  String? phone;
  String? description;
  String? amount;
  String? balance;
  String? created_at;
  String? type;
  String? category;
  String? userId;
  String? accountNumber;
  String? accountType;



  BalanceModel({
    this.id,
    this.name,
    this.description,
    this.amount,
    this.balance,
    this.phone,
    this.created_at,
    this.type,
    this.category,
    this.userId,
    this.accountNumber,
    this.accountType,

  });

  factory BalanceModel.fromMap(map) {
    return BalanceModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      amount: map['amount'],
      balance: map['balance'],
      phone: map['phone'],
      created_at: map['created_at'],
      type: map['type'],
      category: map['category'],
      userId: map['userId'],
      accountNumber: map['accountNumber'],
      accountType: map['accountType'],
    );
  }

  BalanceModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    amount = json['amount'];
    balance = json['balance'];
    phone = json['phone'];
    created_at = json['created_at'];
    type = json['type'];
    category = json['category'];
    userId = json['userId'];
    accountNumber = json['accountNumber'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['amount'] = amount;
    data['balance'] = balance;
    data['phone'] = phone;
    data['created_at'] = created_at;
    data['type'] = type;
    data['category'] = category;
    data['userId'] = userId;
    data['accountNumber'] = accountNumber;
    data['accountType'] = accountType;
    return data;
  }


}