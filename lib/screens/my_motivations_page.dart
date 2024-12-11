import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vigenesia_mobile/models/motivation.dart';
import 'package:vigenesia_mobile/models/user.dart';
import 'package:vigenesia_mobile/screens/edit_motivation.dart';
import 'package:vigenesia_mobile/screens/login_screen.dart';
import 'package:vigenesia_mobile/services/api_service.dart';

class MyMotivationsPage extends StatefulWidget {
  final User user;

  MyMotivationsPage({required this.user});

  @override
  State<MyMotivationsPage> createState() => _MyMotivationsPageState();
}

class _MyMotivationsPageState extends State<MyMotivationsPage> {
  final TextEditingController motivationController = TextEditingController();
  List<Motivation> motivations = []; // Menyimpan daftar motivasi

  @override
  void initState() {
    super.initState();
    _loadMotivations();
  }

  // Fungsi untuk mendapatkan daftar motivasi dari API
  Future<void> _loadMotivations() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final data = await apiService.getMotivationByUser(widget.user.id);
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

  Future<void> _deleteMotivation(int motivationId) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    await apiService.deleteMotivation(motivationId);
    _loadMotivations(); // Reload data motivasi setelah delete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivasi Saya'),
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
            TextField(
              controller: motivationController,
              decoration: const InputDecoration(
                labelText: 'Isi motivasi anda..',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitMotivation,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Simpan Motivasi'),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.format_quote),
                              const SizedBox(width: 3),
                              Text(
                                motivations[index].isi_motivasi,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditMotivationPage(
                                          motivation: motivations[index],
                                        ),
                                      )).then((_) {
                                    _loadMotivations();
                                  });
                                },
                                icon: const Icon(Icons.edit_outlined),
                                color: Colors.deepPurple,
                                iconSize: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteMotivation(motivations[index].id);
                                },
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                                iconSize: 20,
                              )
                            ],
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
