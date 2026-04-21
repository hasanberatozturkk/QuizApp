class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  // burası veritabanına yazılırken kullanılır.
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  // burası veritabanından okunduğunda kullanılır.
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'], name: map['name']);
  }
}
