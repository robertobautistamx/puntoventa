// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/almacenScreen.dart';
import 'package:puntoventa/Controlador/productosScreen.dart';
import 'package:puntoventa/Vista/categoriaScreen.dart';
import 'package:puntoventa/Vista/miPerfil.dart';
import 'package:puntoventa/Vista/nuevaVentaScreen.dart';
import 'package:puntoventa/Vista/ventasScreen.dart';

class OpcionesController {
  void goToAlmacen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AlmacenScreen()));
  }

  void goToCategorias(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoriasScreen()));
  }

  void goToProductos(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductosScreen()));
  }

  void goToVentas(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VentasScreen()));
  }

  void goToNuevaVenta(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NuevaVentaScreen()));
  }

  void goToMiPerfil(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => miPerfil()));
  }
}
