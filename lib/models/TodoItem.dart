
class TodoItem {
  final String id;
  final String image;
  final String title;
  final String desc;
  final String priority;
  final String status;
  final String user;
  final String createdAt;
  final String updatedAt;

  TodoItem({
    required this.id,
    required this.image,
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    try {
      return TodoItem(
        id: json['_id'] ?? '',
        image: json['image'] ?? '',
        title: json['title'] ?? '',
        desc: json['desc'] ?? '',
        priority: json['priority'] ?? '',
        status: json['status'] ?? '',
        user: json['user'] ?? '',
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
      );
    } catch (e) {
      print('Error parsing TodoItem: $e');
      throw Exception('Error parsing TodoItem: $e');
    }
  }

}
