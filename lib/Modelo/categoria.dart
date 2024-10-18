// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  String id;
  String nombre;

  Categoria({required this.id, required this.nombre});

  // Método para crear una instancia de Categoria desde Firestore
  factory Categoria.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Categoria(
      id: doc.id,
      nombre: data['nombre'] ?? '',
    );
  }

  // Método para convertir Categoria a un mapa (para agregarlo a Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }
}
