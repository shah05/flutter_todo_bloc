class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? authToken;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.age,
      this.createdAt,
      this.authToken,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json)
      : id = json['user']['_id'],
        name = json['user']['name'],
        email = json['user']['email'],
        age = json['user']['age'],
        createdAt = DateTime.parse(json['user']['createdAt']),
        authToken = json['token'],
        updatedAt = DateTime.parse(json['user']['updatedAt']);
}
