// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntoventa/Modelo/producto.dart';

class AlmacenController {
  final CollectionReference<Map<String, dynamic>> almacenRef =
      FirebaseFirestore.instance.collection('almacen');

  // Método para obtener los productos
  Future<List<Producto>> fetchProductos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await almacenRef.get();

      List<Producto> productos = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Producto(
          id: doc.id,
          nombre: data['nombre'] as String? ?? 'Sin nombre',
          precio: (data['precio'] as num?)?.toDouble() ?? 0.0,
          cantidad: data['cantidad'] as int? ?? 0,
          codigoBarras: data['codigoBarras'] as String? ?? 'Sin código',
          categoriaId: data['categoriaId'] as String? ?? 'Sin categoría',
        );
      }).toList();
      return productos;
    } catch (e) {
      print('Error al obtener productos: $e');
      return [];
    }
  }

  // Método para agregar un nuevo producto
  Future<void> agregarProducto(Producto producto) async {
    await almacenRef.add(producto.toMap());
  }

  // Método para editar un producto existente
  Future<void> editarProducto(Producto producto) async {
    await almacenRef.doc(producto.id).update(producto.toMap());
  }

  // Método para eliminar un producto existente
  Future<void> eliminarProducto(String id) async {
    await almacenRef.doc(id).delete();
  }
}
