// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntoventa/Modelo/venta.dart';

class VentaController {
  final CollectionReference<Map<String, dynamic>> ventaRef =
      FirebaseFirestore.instance.collection('ventas');

  // Método para obtener las ventas
  Future<List<Venta>> fetchVentas() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await ventaRef.get();

      List<Venta> ventas = querySnapshot.docs.map((doc) {
        return Venta.fromFirestore(doc);
      }).toList();
      return ventas;
    } catch (e) {
      print('Error al obtener ventas: $e');
      return [];
    }
  }

  // Método para agregar una nueva venta
  Future<void> agregarVenta(Venta venta) async {
    await ventaRef.add(venta.toMap());
  }

  // Método para eliminar una venta existente
  Future<void> eliminarVenta(String id) async {
    await ventaRef.doc(id).delete();
  }
}
