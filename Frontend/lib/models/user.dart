class User {
  late String id;
  late String firstName;
  late String email;
  late String password;
  late String role;
  late String lastName;

  User({
    required this.id,
    required this.firstName,
    required this.email,
    required this.password,
    required this.role,
    required this.lastName,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    firstName = json['firstName'];
    lastName = json["lastName"];
    email = json['email'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
