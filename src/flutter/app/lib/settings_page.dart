import 'package:app/constants.dart';
import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package

class Settings extends StatelessWidget {
  const Settings({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    // Logout user from the supabase session
    void signOut() {
      supabase.auth.signOut();
      Navigator.pop(context);
    }

    String? email = supabase.auth.currentSession?.user.email;
    if (email == null) email = 'Not Autheticated';

    return Scaffold(
      appBar: CustomAppBar(
        "Settings",
        showOptions: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Logged in with: ${email}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            ElevatedButton(
              onPressed: signOut,
              child: Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}
