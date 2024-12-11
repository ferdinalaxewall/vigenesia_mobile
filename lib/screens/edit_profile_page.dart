import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: 'User Name');
    final TextEditingController emailController =
        TextEditingController(text: 'user@example.com');

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () {
                // Call API to update profile
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
