// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, camel_case_types, file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/authController.dart';
import 'package:firebase_auth/firebase_auth.dart';

class miPerfil extends StatefulWidget {
  @override
  _miPerfilState createState() => _miPerfilState();
}

class _miPerfilState extends State<miPerfil> {
  final AuthController _authController = AuthController();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _authController.getCurrentUser();
  }

  Future<void> _signOut() async {
    await _authController.signOut();
    Navigator.of(context).pushReplacementNamed(
        '/login'); // Asegúrate de tener una ruta de inicio de sesión configurada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/assets/inicio.png'),
            ),
            SizedBox(height: 16.0),
            Text(
              _user?.displayName ?? 'Usuario',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              _user?.email ?? 'usuario@correo.com',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Acción para editar perfil
              },
              child: Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
