import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login.dart';
import 'home_page.dart'; // Importa HomePage

class SignInScreen extends StatelessWidget {
  final Login _login = Login();

  Future<void> _handleSignIn(BuildContext context) async {
    User? user = await _login.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // ✅ Ahora está definido
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/google_logo.png', width: 100, height: 100),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleSignIn(context),
              child: Text('Iniciar sesión con Google'),
            ),
          ],
        ),
      ),
    );
  }
}
