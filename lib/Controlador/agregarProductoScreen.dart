// ignore_for_file: use_key_in_widget_constructors, file_names, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:puntoventa/Controlador/almacenController.dart';
import 'package:puntoventa/Modelo/producto.dart';

class AgregarProductoScreen extends StatefulWidget {
  @override
  _AgregarProductoScreenState createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final AlmacenController _almacenController = AlmacenController();
  String _codigoBarras = '';

  Future<void> _scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

      if (barcodeScanRes != '-1') {
        setState(() {
          _codigoBarras = barcodeScanRes;
        });
      }
    } catch (e) {
      setState(() {
        _codigoBarras = 'Error al escanear el código de barras';
      });
    }
  }

  Future<void> _agregarProducto() async {
    if (_codigoBarras.isNotEmpty &&
        _codigoBarras != 'Error al escanear el código de barras') {
      try {
        Producto producto = await Producto.fromBarcode(_codigoBarras);
        await _almacenController.agregarProducto(producto);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto agregado con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
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
            Text('Código de Barras: $_codigoBarras'),
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
