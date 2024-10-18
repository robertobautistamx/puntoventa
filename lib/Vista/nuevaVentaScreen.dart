// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/almacenController.dart';
import 'package:puntoventa/Controlador/ventaController.dart';
import 'package:puntoventa/Modelo/producto.dart';
import 'package:puntoventa/Modelo/venta.dart';
import 'package:puntoventa/Vista/ventasScreen.dart';

class NuevaVentaScreen extends StatefulWidget {
  @override
  _NuevaVentaScreenState createState() => _NuevaVentaScreenState();
}

class _NuevaVentaScreenState extends State<NuevaVentaScreen> {
  final AlmacenController _almacenController = AlmacenController();
  final VentaController _ventaController = VentaController();
  List<Producto> _productosSeleccionados = [];
  double _total = 0.0;

  void _agregarProducto(Producto producto) {
    setState(() {
      _productosSeleccionados.add(producto);
      _total += producto.precio;
    });
  }

  void _eliminarProducto(Producto producto) {
    setState(() {
      _productosSeleccionados.remove(producto);
      _total -= producto.precio;
    });
  }

  Future<void> _realizarVenta() async {
    if (_productosSeleccionados.isNotEmpty) {
      Venta venta = Venta(
        id: '',
        fecha: DateTime.now(),
        productos: _productosSeleccionados
            .map((producto) => producto.toMap())
            .toList(),
        total: _total,
      );
      await _ventaController.agregarVenta(venta);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Venta realizada con éxito')),
      );
      setState(() {
        _productosSeleccionados.clear();
        _total = 0.0;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VentasScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Venta'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Producto>>(
              future: _almacenController.fetchProductos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay productos disponibles.'));
                } else {
                  final List<Producto> productos = snapshot.data!;
                  return ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      return ListTile(
                        title: Text(producto.nombre),
                        subtitle: Text(
                            'Cantidad: ${producto.cantidad}, Precio: \$${producto.precio}'),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _agregarProducto(producto),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Divider(),
          Text('Productos Seleccionados:'),
          Expanded(
            child: ListView.builder(
              itemCount: _productosSeleccionados.length,
              itemBuilder: (context, index) {
                final producto = _productosSeleccionados[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text(
                      'Cantidad: ${producto.cantidad}, Precio: \$${producto.precio}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => _eliminarProducto(producto),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Text('Total: \$$_total'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _realizarVenta,
            child: Text('Realizar Venta'),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
