import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ApiService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/users',
        connectTimeout: const Duration(seconds: 5), // Waktu timeout untuk koneksi
        receiveTimeout: const Duration(seconds: 3) // Waktu timeout untuk menerima data
      )
    );

  // Fungsi untuk registrasi
  Future<User?> register(String email, String password, String name) async {
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'password': password,
        'name': name,
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
      final response = await _dio.post('/login', data: {
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

  // Fungsi untuk logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
