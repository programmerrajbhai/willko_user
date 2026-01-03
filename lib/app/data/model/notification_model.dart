class NotificationModel {
  String id;
  String title;
  String body;
  String time;
  bool isRead;
  String type; // 'order', 'offer', 'system' (আইকন চেঞ্জ করার জন্য)

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    this.type = 'system',
  });
}