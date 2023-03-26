// ignore_for_file: non_constant_identifier_names

class User {
  int user_id;
  String user_email;
  String user_name;
  String user_role;
  String password;

  User(
    this.user_id,
    this.user_name,
    this.user_email,
    this.password,
    this.user_role,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
        json["user_id"],
        json["user_name"],
        json["user_email"],
        json["password"],
        json["user_role"],
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'user_name': user_name,
        'user_email': user_email,
        'password': password,
        'user_role': user_role,
      };
}
