// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puntoventa/Vista/opciones.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Inicio de sesión exitoso: ${userCredential.user?.email}');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Opciones()), // Asegúrate de tener la clase Opciones definida
      );
    } on FirebaseAuthException catch (e) {
      print('Error de inicio de sesión: ${e.message}');
      // Muestra un mensaje de error en la interfaz de usuario
    }
  }

  void cancel(TextEditingController usernameController,
      TextEditingController passwordController) {
    usernameController.clear();
    passwordController.clear();
    print('Inicio de sesión cancelado');
  }
}
