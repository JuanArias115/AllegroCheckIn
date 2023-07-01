import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                  subtitle: Text('Value: \$${productList[index].valor}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await ReserveService()
                          .deleteProduct(productList[index].id);
                      setState(() {
                        var i = 1;
                      });
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
                title: Text('Add Product'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(labelText: 'Category'),
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
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Add'),
                    onPressed: () async {
                      Producto product = Producto(
                        id: "0",
                        item: nameController.text,
                        categoria: categoryController.text,
                        valor: valueController.text,
                      );
                      await ReserveService().addProducts(product);
                      nameController.clear();
                      categoryController.clear();
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
