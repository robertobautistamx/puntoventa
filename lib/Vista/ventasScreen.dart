// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/ventaController.dart';
import 'package:puntoventa/Modelo/venta.dart';

class VentasScreen extends StatefulWidget {
  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final VentaController _ventaController = VentaController();
  late Future<List<Venta>> _ventasFuture;

  @override
  void initState() {
    super.initState();
    _ventasFuture = _ventaController.fetchVentas();
  }

  void _refreshVentas() {
    setState(() {
      _ventasFuture = _ventaController.fetchVentas();
    });
  }

  void _eliminarVenta(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Venta'),
          content: Text('¿Estás seguro de que deseas eliminar esta venta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _ventaController.eliminarVenta(id);
                Navigator.of(context).pop();
                _refreshVentas();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas Realizadas'),
      ),
      body: FutureBuilder<List<Venta>>(
        future: _ventasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay ventas disponibles.'));
          } else {
            final List<Venta> ventas = snapshot.data!;
            return ListView.builder(
              itemCount: ventas.length,
              itemBuilder: (context, index) {
                final venta = ventas[index];
                return ListTile(
                  title: Text('Venta ${venta.id}'),
                  subtitle: Text('Total: \$${venta.total.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _eliminarVenta(venta.id),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Detalles de la Venta'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: venta.productos.map((producto) {
                              return ListTile(
                                title: Text(producto['nombre']),
                                subtitle: Text(
                                  'Cantidad: ${producto['cantidad']}, Precio: \$${producto['precio'].toStringAsFixed(2)}',
                                ),
                              );
                            }).toList(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
