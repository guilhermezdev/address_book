import 'dart:convert';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
      );

  UserModel copyWithId(int newId) => UserModel(
        id: newId,
        name: name,
        email: email,
        password: password,
      );

  UserModel copyWithPassword(String newPassword) => UserModel(
        id: id,
        name: name,
        email: email,
        password: newPassword,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'email': email,
        'password': password,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
