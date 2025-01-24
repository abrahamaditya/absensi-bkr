class User {
  String? id;
  String? username;
  String? password;

  User({
    required this.id,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, password: $password)';
  }
}
