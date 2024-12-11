import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vigenesia_mobile/models/motivation.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Motivation> motivations = []; // Menyimpan daftar motivasi

  @override
  void initState() {
    super.initState();
    _loadMotivations();
  }

  // Fungsi untuk mendapatkan daftar motivasi dari API
  Future<void> _loadMotivations() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final data = await apiService.getMotivations();
    setState(() {
      motivations = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final apiService =
                  Provider.of<ApiService>(context, listen: false);
              await apiService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Selamat datang, ${widget.user.name}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: motivations.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_2,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                motivations[index].user.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            motivations[index].isi_motivasi,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
