import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vigenesia_mobile/models/user.dart';
import 'package:vigenesia_mobile/screens/login_screen.dart';
import 'package:vigenesia_mobile/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage({required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Column(
        children: [
          ListTile(
            title: Text("Nama: ${widget.user.name}"),
            subtitle: Text('Email: ${widget.user.email}'),
          ),
          ElevatedButton(
            onPressed: () async {
              final apiService =
                  Provider.of<ApiService>(context, listen: false);
              await apiService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

}
