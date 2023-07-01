import 'package:allegrocheckin/Products/add_products_reserve.dart';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:allegrocheckin/models/ProductsEstadia.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';

class ProductList extends StatefulWidget {
  final String id;
  ProductList({required this.id});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<ProductoEstadia> _products = [];
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchProductList();
  }

  Future<void> _fetchProductList() async {
    try {
      CommandResult result =
          await ReserveService().getproductsEstadias(widget.id);
      List<ProductoEstadia> products =
          ProductoEstadia.parseMyDataList(result.data);
      setState(() {
        _products = products;
        _calculateTotal();
      });
    } catch (error) {
      // Manejar el error de manera adecuada
    }
  }

  void _calculateTotal() {
    double total = 0.0;
    for (var product in _products) {
      total += double.parse(product.valor);
    }
    setState(() {
      _total = total;
    });
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await ReserveService().deleteProductsEstadias(productId);
      _fetchProductList();
    } catch (error) {
      // Manejar el error de manera adecuada
    }
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
                  onPressed: () async {
                    var mensaje = ganerarMensaje();
                    try {
                      await FlutterShare.share(
                        title: 'Compartir en WhatsApp',
                        text: mensaje,
                        chooserTitle: 'Compartir mensaje',
                      );
                    } catch (e) {
                      print('Error al compartir en WhatsApp: $e');
                    }
                  },
                  child: Text("Finalizar Reserva"),
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  var r = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductListaAdd(idEstadia: widget.id),
                    ),
                  );
                  _fetchProductList();
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Total: \$ ${_total.toStringAsFixed(0)}'),
        ),
        body: Container(
          child: _products.isNotEmpty
              ? ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    ProductoEstadia product = _products[index];
                    TextEditingController controller =
                        TextEditingController(text: product.valor.toString());

                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text(product.item),
                        subtitle: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          onChanged: (value) async {
                            _products[index].valor =
                                (double.tryParse(value) ?? 0)
                                    .toStringAsFixed(0);
                            await ReserveService()
                                .updateProductsEstadia(product);
                            _calculateTotal();
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteProduct(product.id);
                          },
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text('No hay productos agregados'),
                ),
        ),
      ),
    );
  }

  ganerarMensaje() {
    var mensaje = "Resumen de cuenta: \n";
    "\n";
    mensaje += "Allegro eco Glamping \n";
    for (var product in _products) {
      mensaje += product.item + " - " + product.valor + "\n";
    }
    "\n";
    mensaje += "Total: " + _total.toStringAsFixed(0);
    return mensaje;
  }
}
