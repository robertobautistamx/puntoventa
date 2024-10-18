import 'package:puntoventa/Modelo/producto.dart';

class Ticket {
  final List<Producto> productos;
  final double total;
  final DateTime fecha;

  Ticket({
    required this.productos,
    required this.total,
    required this.fecha,
  });

  String generarTicketTexto() {
    StringBuffer ticketTexto = StringBuffer();
    ticketTexto.writeln('--- TICKET ---');
    ticketTexto.writeln('Fecha: ${fecha.toLocal()}');
    ticketTexto.writeln('----------------');

    for (var producto in productos) {
      ticketTexto.writeln(
          '${producto.nombre} - \$${producto.precio.toStringAsFixed(2)}');
    }

    ticketTexto.writeln('----------------');
    ticketTexto.writeln('Total: \$${total.toStringAsFixed(2)}');
    ticketTexto.writeln('Gracias por su compra!');
    return ticketTexto.toString();
  }
}
