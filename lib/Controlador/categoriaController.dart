// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntoventa/Modelo/categoria.dart';

class CategoriaController {
  final CollectionReference<Map<String, dynamic>> categoriaRef =
      FirebaseFirestore.instance.collection('categorias');

  // Método para obtener las categorías
  Future<List<Categoria>> fetchCategorias() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await categoriaRef.get();

      List<Categoria> categorias = querySnapshot.docs.map((doc) {
        return Categoria.fromFirestore(doc);
      }).toList();
      return categorias;
    } catch (e) {
      print('Error al obtener categorías: $e');
      return [];
    }
  }

  // Método para agregar una nueva categoría
  Future<void> agregarCategoria(Categoria categoria) async {
    await categoriaRef.add(categoria.toMap());
  }

  // Método para editar una categoría existente
  Future<void> editarCategoria(Categoria categoria) async {
    await categoriaRef.doc(categoria.id).update(categoria.toMap());
  }

  // Método para eliminar una categoría existente
  Future<void> eliminarCategoria(String id) async {
    await categoriaRef.doc(id).delete();
  }
}
