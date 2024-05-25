class PushNotification {
  final String title;
  final String body;

  PushNotification({
    required this.title,
    required this.body,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      title: json['notification']['title'],
      body: json['notification']['body'],
    );
  }
}