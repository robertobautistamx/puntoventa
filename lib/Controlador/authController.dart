// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
