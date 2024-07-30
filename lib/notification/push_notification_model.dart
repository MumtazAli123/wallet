class PNotificationModel {
  String? id;
  final String title;
  final String body;

  PNotificationModel({
    this.id,
    required this.title,
    required this.body,
  });

  factory PNotificationModel.fromJson(Map<String, dynamic> json) {
    return PNotificationModel(
      id: json['id'],
      title: json['notification']['title'],
      body: json['notification']['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification': {
        'title': title,
        'body': body,
      },
    };
  }
}