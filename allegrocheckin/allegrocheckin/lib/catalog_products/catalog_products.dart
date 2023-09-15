import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/models/categorias.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/products.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  List<Categoria> categoryOptions =
      []; // Actualizar para usar el servicio async

  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    loadCategoryOptions(); // Cargar las opciones de categoría al iniciar la página
  }

  Future<void> loadCategoryOptions() async {
    // Llamar al servicio async para obtener las opciones de categoría
    try {
      CommandResult result = await ReserveService().getCategorias();
      setState(() {
        selectedCategory = result.data[0][
            'nombre']; // Establecer la primera opción como la opción seleccionada
        categoryOptions = Categoria.parseMyDataList(
            result.data); // Actualizar las opciones de categoría en el estado
      });
    } catch (error) {
      print('Error al cargar las opciones de categoría: $error');
      // Manejar el error de carga de opciones de categoría
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CommandResult>(
        future: ReserveService().getproducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los productos'));
          } else {
            List<Producto> productList =
                Producto.parseMyDataList(snapshot.data!.data);
            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(productList[index].item),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Value: \$${productList[index].valor}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Categoría: ${productList[index].categoria}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      if (await confirm(context,
                          title: const Text("Allegro Glamping"),
                          content: const Text(
                              "¿Está seguro que desea eliminar el producto?"))) {
                        await ReserveService()
                            .deleteProduct(productList[index].id);
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Añadir Producto'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    DropdownButtonFormField(
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Category'),
                      items: categoryOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option.nombre,
                          child: Text(option.nombre),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: valueController,
                      decoration: InputDecoration(labelText: 'Value'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                        // Permite solo números y hasta 2 decimales
                      ],
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () async {
                      Producto product = Producto(
                        id: "0",
                        item: nameController.text,
                        categoria: selectedCategory,
                        valor: valueController.text,
                      );
                      await ReserveService().addProducts(product);
                      nameController.clear();
                      valueController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          setState(() {
            var i = 1;
          });
        },
      ),
    );
  }
}
