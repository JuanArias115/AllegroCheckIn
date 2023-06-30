import 'package:allegrocheckin/Products/add_products_reserve.dart';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:allegrocheckin/models/ProductsEstadia.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductList extends StatefulWidget {
  final String id;
  ProductList({required this.id});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 230,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {},
                  child: Text("Finalizar Reserva"),
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  var r = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListaAdd()),
                  );
                  setState(() {
                    var i = 1;
                  });
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        appBar: AppBarComponents(),
        body: Container(
          child: FutureBuilder<CommandResult>(
            future: ReserveService().getproductsEstadias(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error al cargar los datos'),
                );
              } else if (snapshot.hasData) {
                List<ProductoEstadia> products =
                    ProductoEstadia.parseMyDataList(snapshot.data!.data);
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    ProductoEstadia product = products[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text(product.item),
                          subtitle: Text('Valor: \$${product.valor}'),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              var r = await ReserveService()
                                  .deleteProductsEstadias(product.id);
                              setState(() {
                                var i = 1;
                              });
                            },
                          )),
                    );
                    ;
                  },
                );
              } else {
                return Center(
                  child: Text('No hay datos disponibles'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
