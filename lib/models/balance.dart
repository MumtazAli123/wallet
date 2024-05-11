class BalanceModel{
  String? id;
  String? name;

  String? description;
  String? amount;
  String? date;
  String? type;
  String? category;
  String? userId;
  String? accountNumber;
  String? accountType;
  String? recentTransactionType;
  String? recentTransactionAmount;
  String? recentTransactionDate;
  String? recentTransactionTime;
  String? recentTransactionName;
  String? recentTransactionDescription;
  String? recentTransactionId;


  BalanceModel({
    this.id,
    this.name,
    this.description,
    this.amount,
    this.date,
    this.type,
    this.category,
    this.userId,
    this.accountNumber,
    this.accountType,
    this.recentTransactionType,
    this.recentTransactionAmount,
    this.recentTransactionDate,
    this.recentTransactionTime,
    this.recentTransactionName,
    this.recentTransactionDescription,
    this.recentTransactionId,
  });

  BalanceModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    amount = json['amount'];
    date = json['date'];
    type = json['type'];
    category = json['category'];
    userId = json['userId'];
    accountNumber = json['accountNumber'];
    accountType = json['accountType'];
    recentTransactionType = json['recentTransactionType'];
    recentTransactionAmount = json['recentTransactionAmount'];
    recentTransactionDate = json['recentTransactionDate'];
    recentTransactionTime = json['recentTransactionTime'];
    recentTransactionName = json['recentTransactionName'];
    recentTransactionDescription = json['recentTransactionDescription'];
    recentTransactionId = json['recentTransactionId'];
  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['amount'] = amount;
    data['date'] = date;
    data['type'] = type;
    data['category'] = category;
    data['userId'] = userId;
    data['accountNumber'] = accountNumber;
    data['accountType'] = accountType;
    data['recentTransactionType'] = recentTransactionType;
    data['recentTransactionAmount'] = recentTransactionAmount;
    data['recentTransactionDate'] = recentTransactionDate;
    data['recentTransactionTime'] = recentTransactionTime;
    data['recentTransactionName'] = recentTransactionName;
    data['recentTransactionDescription'] = recentTransactionDescription;
    data['recentTransactionId'] = recentTransactionId;
    return data;
  }
}