// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/almacenController.dart';
import 'package:puntoventa/Modelo/producto.dart';

class AlmacenScreen extends StatefulWidget {
  @override
  _AlmacenScreenState createState() => _AlmacenScreenState();
}

class _AlmacenScreenState extends State<AlmacenScreen> {
  final AlmacenController _almacenController = AlmacenController();
  late Future<List<Producto>> _productosFuture;

  @override
  void initState() {
    super.initState();
    _productosFuture = _almacenController.fetchProductos();
  }

  void _refreshProductos() {
    setState(() {
      _productosFuture = _almacenController.fetchProductos();
    });
  }

  void _editarProducto(Producto producto) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nombreController =
            TextEditingController(text: producto.nombre);
        final TextEditingController precioController =
            TextEditingController(text: producto.precio.toString());
        final TextEditingController cantidadController =
            TextEditingController(text: producto.cantidad.toString());

        return AlertDialog(
          title: Text('Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
              ),
              TextField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                producto.nombre = nombreController.text;
                producto.precio = double.parse(precioController.text);
                producto.cantidad = int.parse(cantidadController.text);
                await _almacenController.editarProducto(producto);
                Navigator.of(context).pop();
                _refreshProductos();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarProducto(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Producto'),
          content: Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _almacenController.eliminarProducto(id);
                Navigator.of(context).pop();
                _refreshProductos();
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
        title: Text('Almacén'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductoSearchDelegate(_almacenController),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Producto>>(
        future: _productosFuture,
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
                return ListTile(
                  title: Text(productos[index].nombre),
                  subtitle: Text(
                    'Cantidad: ${productos[index].cantidad}, Precio: \$${productos[index].precio.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editarProducto(productos[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _eliminarProducto(productos[index].id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ProductoSearchDelegate extends SearchDelegate<Producto> {
  final AlmacenController _almacenController;

  ProductoSearchDelegate(this._almacenController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(
            context,
            Producto(
                id: '',
                nombre: '',
                precio: 0.0,
                cantidad: 0,
                codigoBarras: '',
                categoriaId: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: _almacenController.fetchProductos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay productos disponibles.'));
        } else {
          final List<Producto> productos = snapshot.data!
              .where((producto) =>
                  producto.nombre.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(productos[index].nombre),
                subtitle: Text(
                  'Cantidad: ${productos[index].cantidad}, Precio: \$${productos[index].precio.toStringAsFixed(2)}',
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: _almacenController.fetchProductos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay productos disponibles.'));
        } else {
          final List<Producto> productos = snapshot.data!
              .where((producto) =>
                  producto.nombre.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(productos[index].nombre),
                subtitle: Text(
                  'Cantidad: ${productos[index].cantidad}, Precio: \$${productos[index].precio.toStringAsFixed(2)}',
                ),
                onTap: () {
                  query = productos[index].nombre;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }
}
