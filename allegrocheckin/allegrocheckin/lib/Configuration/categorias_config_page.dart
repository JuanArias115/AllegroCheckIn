import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/models/categorias.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';

class CategoriaService {
  Future<List<Categoria>> obtenerCategorias() async {
    CommandResult res = await ReserveService().getCategorias();
    var categorias = Categoria.parseMyDataList(res.data);
    return categorias;
  }

  Future<void> eliminarCategoria(Categoria categoria) async {
    CommandResult res = await ReserveService().deleteCategorias(categoria.id);
    print(res.message);
  }

  Future<void> crearCategoria(String nombre) async {
    var categoria = Categoria(id: "0", nombre: nombre);
    CommandResult res = await ReserveService().addCategorias(categoria);
    print(res.message);
  }
}

class CategoriasCrudPage extends StatefulWidget {
  @override
  _CategoriasCrudPageState createState() => _CategoriasCrudPageState();
}

class _CategoriasCrudPageState extends State<CategoriasCrudPage> {
  final CategoriaService service = CategoriaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: Center(
        child: FutureBuilder<List<Categoria>>(
          future: service.obtenerCategorias(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error al cargar las categorías');
            } else if (snapshot.hasData) {
              final categorias = snapshot.data!;

              return ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];

                  return ListTile(
                    title: Text(categoria.nombre),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        if (await confirm(context,
                            title: const Text("Allegro Glamping"),
                            content: const Text(
                                "¿Está seguro que desea eliminar la categoría?"))) {
                          _eliminarCategoria(context, categoria);

                          setState(() {
                            var i = 1;
                          });
                        }
                        return;
                      },
                    ),
                  );
                },
              );
            } else {
              return Text('No se encontraron categorías');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _mostrarDialogoCrearCategoria(context);
        },
      ),
    );
  }

  void _eliminarCategoria(BuildContext context, Categoria categoria) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Categoría'),
          content: Text(
              '¿Estás seguro de eliminar la categoría "${categoria.nombre}"?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                await service.eliminarCategoria(categoria);
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoCrearCategoria(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear Categoría'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Nombre de la categoría',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Crear'),
              onPressed: () async {
                String nombre = controller.text;
                await service.crearCategoria(nombre);
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
