class Notification {
  final String title;
  final String body;
  final String dataId;

  Notification({
    required this.title,
    required this.body,
    required this.dataId,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
        title: json['title'], body: json['body'], dataId: json['dataId']);
  }
}
