class User {
  final String email;
  final String customerName;
  final String phoneNumber;

  User({
    required this.email,
    required this.customerName,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
