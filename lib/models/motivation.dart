import 'package:vigenesia_mobile/models/user.dart';

class Motivation {
  final int id;
  final String isi_motivasi;
  final int userId;
  final User user;

  Motivation({required this.id, required this.isi_motivasi, required this.userId, required this.user});

  factory Motivation.fromJson(Map<String, dynamic> json) {
    return Motivation(
      id: json['id'],
      isi_motivasi: json['isi_motivasi'],
      userId: json['userId'],
      user: User.fromJson(json['user']),
    );
  }
}
