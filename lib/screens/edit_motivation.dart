import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vigenesia_mobile/models/motivation.dart';
import '../services/api_service.dart';

class EditMotivationPage extends StatelessWidget {
  final Motivation motivation;

  EditMotivationPage({required this.motivation});

  @override
  Widget build(BuildContext context) {
    final TextEditingController motivationController =
        TextEditingController(text: motivation.isi_motivasi);


  Future<void> _updateMotivation(String updatedMotivation) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    await apiService.updateMotivation(motivation.id, updatedMotivation);
  }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Motivation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: motivationController,
              decoration: const InputDecoration(
                labelText: 'Isi motivasi anda..',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateMotivation(motivationController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
