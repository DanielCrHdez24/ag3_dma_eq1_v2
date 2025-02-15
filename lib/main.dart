import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'eliminar.dart';
import 'nuevo_reg.dart';
import 'busqueda.dart';
import 'actualizar.dart';
import 'sign_in_screen.dart';
import 'home_page.dart'; //  Importar HomePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: AuthWrapper(),
      routes: {
        '/main': (context) => HomePage(),
        '/eliminar': (context) => EliminarPage(libroId: '', libroTitulo: ''),
        '/nuevo_reg': (context) => NuevoPage(),
        '/busqueda': (context) => BuscarPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return HomePage();
        }
        return SignInScreen();
      },
    );
  }
}
