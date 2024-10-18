// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:puntoventa/Controlador/categoriaController.dart';
import 'package:puntoventa/Modelo/categoria.dart';

class CategoriasScreen extends StatefulWidget {
  @override
  _CategoriasScreenState createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final CategoriaController _categoriaController = CategoriaController();
  late Future<List<Categoria>> _categoriasFuture;

  @override
  void initState() {
    super.initState();
    _categoriasFuture = _categoriaController.fetchCategorias();
  }

  void _refreshCategorias() {
    setState(() {
      _categoriasFuture = _categoriaController.fetchCategorias();
    });
  }

  Future<void> _agregarCategoria(String nombre) async {
    if (nombre.isNotEmpty) {
      Categoria categoria = Categoria(id: '', nombre: nombre);
      await _categoriaController.agregarCategoria(categoria);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría agregada con éxito')),
      );
      _refreshCategorias();
    }
  }

  void _mostrarDialogoAgregarCategoria() {
    final TextEditingController _nombreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Categoría'),
          content: TextField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _agregarCategoria(_nombreController.text);
                Navigator.of(context).pop();
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _editarCategoria(Categoria categoria) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nombreController =
            TextEditingController(text: categoria.nombre);

        return AlertDialog(
          title: Text('Editar Categoría'),
          content: TextField(
            controller: nombreController,
            decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
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
                categoria.nombre = nombreController.text;
                await _categoriaController.editarCategoria(categoria);
                Navigator.of(context).pop();
                _refreshCategorias();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarCategoria(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Categoría'),
          content: Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _categoriaController.eliminarCategoria(id);
                Navigator.of(context).pop();
                _refreshCategorias();
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
        title: Text('Categorías'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Categoria>>(
                future: _categoriasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No hay categorías disponibles.'));
                  } else {
                    final List<Categoria> categorias = snapshot.data!;
                    return ListView.builder(
                      itemCount: categorias.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(categorias[index].nombre),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () =>
                                    _editarCategoria(categorias[index]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    _eliminarCategoria(categorias[index].id),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregarCategoria,
        child: Icon(Icons.add),
      ),
    );
  }
}
