class User {
  int? id;  // Make id nullable because it might not be set before inserting into the database
  String firstName;
  String lastName;
  String email;
  String password;

  User({
    this.id, // id can be null, so it's not required
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
      };
}
