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
  final TextEditingController motivationController = TextEditingController();
  List<String> motivations = []; // Menyimpan daftar motivasi

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

  // Fungsi untuk submit motivasi
  Future<void> _submitMotivation() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    await apiService.addMotivation(motivationController.text, widget.user.id);
    motivationController.clear();
    _loadMotivations(); // Reload data motivasi setelah submit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final apiService = Provider.of<ApiService>(context, listen: false);
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: motivationController,
              decoration: InputDecoration(
                labelText: 'Isi motivasi anda..',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitMotivation,
              child: Text('Simpan Motivasi'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: motivations.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        motivations[index],
                        style: TextStyle(fontSize: 16),
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
