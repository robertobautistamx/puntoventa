// ignore_for_file: file_names, avoid_print, use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registro extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  print('Por favor, complete todos los campos.');
                  return;
                }

                try {
                  UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  print('Registro exitoso: ${userCredential.user?.email}');
                  Navigator.pop(context); // Volver
                } on FirebaseAuthException catch (e) {
                  print('Error de registro: ${e.message}');
                }
              },
              child: Text('Registrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
