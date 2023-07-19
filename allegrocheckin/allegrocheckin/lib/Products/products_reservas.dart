import 'package:allegrocheckin/Products/add_products_reserve.dart';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:allegrocheckin/models/ProductsEstadia.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/estadias.dart';
import 'package:allegrocheckin/models/products.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';

class ProductList extends StatefulWidget {
  final Estadia estadia;
  ProductList({required this.estadia});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<ProductoEstadia> _products = [];
  double _total = 0.0;
  final oCcy = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    _fetchProductList();
  }

  Future<void> _fetchProductList() async {
    try {
      CommandResult result =
          await ReserveService().getproductsEstadias(widget.estadia.id);
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

  void _updateProductValue(ProductoEstadia product, String newValue) async {
    product.valor = newValue;
    await ReserveService().updateProductsEstadia(product);
    _fetchProductList();
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
              widget.estadia.estado == "ACTIVO"
                  ? SizedBox(
                      width: 230,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        onPressed: () async {
                          var mensaje = ganerarMensaje();
                          var res = await FlutterShare.share(
                            title: 'Compartir en WhatsApp',
                            text: mensaje,
                            chooserTitle: 'Compartir mensaje',
                          );

                          if (res!) {
                            Estadia estadiaTemp = widget.estadia;
                            estadiaTemp.estado = "INACTIVO";
                            var res =
                                await ReserveService().checkOut(estadiaTemp);
                            setState(() {
                              _fetchProductList();
                            });
                          }

                          Navigator.of(context).pop(true);
                        },
                        child: Text("Check Out"),
                      ),
                    )
                  : SizedBox.shrink(),
              FloatingActionButton(
                onPressed: () async {
                  var r = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductListaAdd(idEstadia: widget.estadia.id),
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
          title: Text('Total: \$ ${oCcy.format(_total)}'),
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
                        subtitle:
                            Text(oCcy.format(double.parse(product.valor))),
                        trailing: widget.estadia.estado == "ACTIVO"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      _showEditDialog(product);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      if (await confirm(
                                        context,
                                        title: const Text('Eliminar'),
                                        content: const Text(
                                            'Estas seguro que deseas continuar?'),
                                        textOK: const Text('Si'),
                                        textCancel: const Text('No'),
                                      )) {
                                        _deleteProduct(product.id);
                                      }
                                      return print('pressedCancel');
                                    },
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
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

  void _showEditDialog(ProductoEstadia product) async {
    TextEditingController controller =
        TextEditingController(text: product.valor.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Valor'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newValue = controller.text;
                _updateProductValue(product, newValue);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
    setState(() {
      _fetchProductList();
    });
  }

  String ganerarMensaje() {
    var mensaje = "Resumen de cuenta: \n";
    "\n";
    mensaje += "Nombre: ${widget.estadia.nombre.toString()}\n";
    mensaje += "Fecha: ${widget.estadia.fecha.toString().substring(0, 10)}\n";
    mensaje += "Allegro eco Glamping \n";
    for (var product in _products) {
      mensaje += product.item +
          " - " +
          oCcy.format(double.parse(product.valor)) +
          "\n";
    }
    "\n";
    mensaje += "Abono - ${oCcy.format(double.parse(widget.estadia.abono))} \n";

    mensaje +=
        "Total: " + oCcy.format(_total - double.parse(widget.estadia.abono));
    return mensaje;
  }
}
