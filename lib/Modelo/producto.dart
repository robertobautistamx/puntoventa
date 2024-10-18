// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  String id;
  String nombre;
  double precio;
  int cantidad;
  String codigoBarras;
  String categoriaId;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.codigoBarras,
    required this.categoriaId,
  });

  // Método para crear una instancia de Producto desde Firestore
  factory Producto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Producto(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] as num?)?.toDouble() ?? 0.0,
      cantidad: data['cantidad'] ?? 0,
      codigoBarras: data['codigoBarras'] ?? '',
      categoriaId: data['categoriaId'] ?? '',
    );
  }

  // Método para convertir Producto a un mapa (para agregarlo a Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'codigoBarras': codigoBarras,
      'categoriaId': categoriaId,
    };
  }

  // Método para crear una instancia de Producto desde un código de barras
  static Future<Producto> fromBarcode(String barcode) async {
    // Aquí deberías implementar la lógica para buscar el producto en la base de datos
    // utilizando el código de barras. Este es un ejemplo básico que asume que tienes
    // una colección "productos" en Firestore donde puedes buscar por código de barras.

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('productos')
            .where('codigoBarras', isEqualTo: barcode)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return Producto.fromFirestore(doc);
    } else {
      // Si no se encuentra el producto, puedes lanzar una excepción o devolver un producto vacío
      throw Exception('Producto no encontrado');
    }
  }
}
