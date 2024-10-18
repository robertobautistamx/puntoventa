import 'package:cloud_firestore/cloud_firestore.dart';

class Venta {
  String id;
  DateTime fecha;
  List<Map<String, dynamic>> productos;
  double total;

  Venta({
    required this.id,
    required this.fecha,
    required this.productos,
    required this.total,
  });

  // Método para crear una instancia de Venta desde Firestore
  factory Venta.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Venta(
      id: doc.id,
      fecha: (data['fecha'] as Timestamp).toDate(),
      productos: List<Map<String, dynamic>>.from(data['productos']),
      total: (data['total'] as num).toDouble(),
    );
  }

  // Método para convertir Venta a un mapa (para agregarlo a Firestore)
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'productos': productos,
      'total': total,
    };
  }
}
