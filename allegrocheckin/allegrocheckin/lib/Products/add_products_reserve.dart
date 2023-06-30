import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:allegrocheckin/models/ProductsEstadia.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/products.dart';
import 'package:flutter/material.dart';

class ProductListaAdd extends StatefulWidget {
  final String idEstadia;

  const ProductListaAdd({super.key, required this.idEstadia});
  @override
  _ProductListaAddState createState() => _ProductListaAddState();
}

class _ProductListaAddState extends State<ProductListaAdd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponents(),
      body: FutureBuilder<CommandResult>(
        future: ReserveService().getproducts(),
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
            List<Producto> products =
                Producto.parseMyDataList(snapshot.data!.data);
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Producto product = products[index];
                return ProductCard(
                  product: product,
                  onAdd: () async {
                    var result = await ReserveService().addProductsEstadia(
                        ProductoEstadia(
                            id: "0",
                            idEstadia: widget.idEstadia.toString(),
                            item: product.item,
                            valor: product.valor));
                    Navigator.of(context).pop(result);
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text('No hay datos disponibles'),
            );
          }
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Producto product;
  final VoidCallback onAdd;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.shopping_cart),
        title: Text(product.item),
        subtitle: Text('Valor: \$${product.valor}'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: onAdd,
        ),
      ),
    );
  }
}
