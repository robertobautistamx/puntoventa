// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/opcionesController.dart';
import 'package:puntoventa/Controlador/authController.dart';

class Opciones extends StatelessWidget {
  final OpcionesController _controller = OpcionesController();
  final AuthController _authController = AuthController();

  Future<void> _signOut(BuildContext context) async {
    await _authController.signOut();
    Navigator.of(context).pushReplacementNamed(
        '/login'); // Asegúrate de tener una ruta de inicio de sesión configurada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                // Navegar a la pantalla de inicio
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                // Acción para configuración (actualmente no hace nada)
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 4,
              child: ListTile(
                leading: Image.asset('lib/assets/inicio.png'),
                title: Text('Almacen'),
                onTap: () => _controller.goToAlmacen(context),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Image.asset('lib/assets/icons8-categorias-100.png'),
                title: Text('Categorías'),
                onTap: () => _controller.goToCategorias(context),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Image.asset('lib/assets/productos.png'),
                title: Text('Productos'),
                onTap: () => _controller.goToProductos(context),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Image.asset('lib/assets/ventas.png'),
                title: Text('Ventas'),
                onTap: () => _controller.goToVentas(context),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Image.asset('lib/assets/nuevaVenta.png'),
                title: Text('Nueva venta'),
                onTap: () => _controller.goToNuevaVenta(context),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Image.asset('lib/assets/perfil.png'),
                title: Text('Mi Perfil'),
                onTap: () => _controller.goToMiPerfil(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
