import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigenesia_mobile/models/motivation.dart';
import '../models/user.dart';

class ApiService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/',
        connectTimeout: const Duration(seconds: 5), // Waktu timeout untuk koneksi
        receiveTimeout: const Duration(seconds: 3) // Waktu timeout untuk menerima data
      )
    );

  // Fungsi untuk registrasi
  Future<User?> register(String email, String password, String name, String profesi) async {
    try {
      final response = await _dio.post('/users/register', data: {
        'email': email,
        'password': password,
        'name': name,
        'profesi': profesi,
      });
      return User.fromJson(response.data);
    } catch (e) {
      print('Error saat register: $e');
      return null;
    }
  }

  // Fungsi untuk login
  Future<User?> login(String email, String password) async {
    try {
      final response = await _dio.post('/users/login', data: {
        'email': email,
        'password': password,
      });
      final user = User.fromJson(response.data);

      // Simpan informasi login di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.email);
      await prefs.setString('name', user.name);

      return user;
    } catch (e) {
      print('Error saat login: $e');
      return null;
    }
  }

  // Fungsi untuk menambahkan motivasi
  Future<Motivation?> addMotivation(String motivationText, int userId) async {
    try {
      final response = await _dio.post('/motivations', data: {
        'isi_motivasi': motivationText,
        'userId': userId,
      });

      final motivation = Motivation.fromJson(response.data);
      return motivation;
    } catch (e) {
      print('Error saat menambahkan motivasi: $e');
      return null;
    }
  }

  // Fungsi untuk mendapatkan daftar motivasi
  Future<List<Motivation>> getMotivations() async {
    try {
      final response = await _dio.get('/motivations');
      return List<Motivation>.from(response.data.map((item) => Motivation.fromJson(item)));
    } catch (e) {
      print('Error saat mengambil motivasi: $e');
      return [];
    }
  }

  // Fungsi untuk mendapatkan daftar motivasi
  Future<List<Motivation>> getMotivationByUser(int userId) async {
    try {
      final response = await _dio.get('/motivations/user/$userId');
      return List<Motivation>.from(response.data.map((item) => Motivation.fromJson(item)));
    } catch (e) {
      print('Error saat mengambil motivasi: $e');
      return [];
    }
  }

  Future<void> updateMotivation(int motivationId, String motivationText) async {
    try {
      await _dio.put('/motivations/$motivationId', data: {
        'isi_motivasi': motivationText,
      });
    } catch (e) {
      print('Error saat mengupdate motivasi: $e');
    }
  }

  Future<void> deleteMotivation(int motivationId) async {
    try {
      await _dio.delete('/motivations/$motivationId');
    } catch (e) {
      print('Error saat menghapus motivasi: $e');
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
