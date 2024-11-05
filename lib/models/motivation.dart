class Motivation {
  final int id;
  final String isi_motivasi;
  final int userId;

  Motivation({required this.id, required this.isi_motivasi, required this.userId});

  factory Motivation.fromJson(Map<String, dynamic> json) {
    return Motivation(
      id: json['id'],
      isi_motivasi: json['isi_motivasi'],
      userId: json['userId'],
    );
  }
}
