class User {
  final int id;
  final String email;
  final String name;
  final String profesi;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.profesi
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profesi: json['profesi']
    );
  }
}
