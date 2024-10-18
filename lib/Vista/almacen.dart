// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/almacenController.dart';
import 'package:puntoventa/Modelo/producto.dart';

class Almacen extends StatefulWidget {
  @override
  _AlmacenViewState createState() => _AlmacenViewState();
}

class _AlmacenViewState extends State<Almacen> {
  final AlmacenController _almacenController = AlmacenController();
  List<String> productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() async {
    List productosCargados = await _almacenController.fetchProductos();
    setState(() {
      productos = List<String>.from(productosCargados);
    });
  }

  void _agregarProducto(String nombreProducto) async {
    await _almacenController.agregarProducto(nombreProducto as Producto);
    _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Almacén'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(productos[index]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: (value) {
                _agregarProducto(value);
              },
              decoration: InputDecoration(
                labelText: 'Nuevo Producto',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
