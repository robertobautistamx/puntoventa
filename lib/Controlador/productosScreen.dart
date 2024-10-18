// ignore_for_file: file_names, use_key_in_widget_constructors, unused_field, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/almacenController.dart';
import 'package:puntoventa/Controlador/categoriaController.dart';
import 'package:puntoventa/Modelo/producto.dart';
import 'package:puntoventa/Modelo/categoria.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final AlmacenController _almacenController = AlmacenController();
  final CategoriaController _categoriaController = CategoriaController();
  String _codigoBarras = '';
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _codigoBarrasController = TextEditingController();
  String? _categoriaSeleccionada;
  late Future<List<Categoria>> _categoriasFuture;

  @override
  void initState() {
    super.initState();
    _categoriasFuture = _categoriaController.fetchCategorias();
  }

  Future<void> _scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

      if (barcodeScanRes != '-1') {
        setState(() {
          _codigoBarras = barcodeScanRes;
          _codigoBarrasController.text = barcodeScanRes;
        });
      }
    } catch (e) {
      setState(() {
        _codigoBarras = 'Error al escanear el código de barras';
      });
    }
  }

  Future<void> _agregarProducto() async {
    if (_nombreController.text.isNotEmpty &&
        _precioController.text.isNotEmpty &&
        _cantidadController.text.isNotEmpty &&
        _codigoBarrasController.text.isNotEmpty &&
        _categoriaSeleccionada != null) {
      Producto producto = Producto(
        id: '',
        nombre: _nombreController.text,
        precio: double.parse(_precioController.text),
        cantidad: int.parse(_cantidadController.text),
        codigoBarras: _codigoBarrasController.text,
        categoriaId: _categoriaSeleccionada!,
      );
      await _almacenController.agregarProducto(producto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto agregado con éxito')),
      );
      _nombreController.clear();
      _precioController.clear();
      _cantidadController.clear();
      _codigoBarrasController.clear();
      setState(() {
        _codigoBarras = '';
        _categoriaSeleccionada = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _scanBarcode,
              child: Text('Escanear Código de Barras'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _codigoBarrasController,
              decoration: InputDecoration(labelText: 'Código de Barras'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Producto'),
            ),
            TextField(
              controller: _precioController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cantidadController,
              decoration: InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            FutureBuilder<List<Categoria>>(
              future: _categoriasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No hay categorías disponibles.');
                } else {
                  final List<Categoria> categorias = snapshot.data!;
                  return DropdownButton<String>(
                    value: _categoriaSeleccionada,
                    hint: Text('Seleccionar Categoría'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _categoriaSeleccionada = newValue;
                      });
                    },
                    items: categorias
                        .map<DropdownMenuItem<String>>((Categoria categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _agregarProducto,
              child: Text('Agregar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
