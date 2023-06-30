import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final double value;

  Product({required this.name, required this.value});
}

class ProductService {
  Future<List<Product>> fetchProducts() async {
    // Simulación de un retardo en la respuesta del servicio
    await Future.delayed(Duration(seconds: 2));

    // Datos de ejemplo
    List<Product> products = [
      Product(name: 'Producto 1', value: 10.99),
      Product(name: 'Producto 2', value: 15.99),
      Product(name: 'Producto 3', value: 19.99),
    ];

    return products;
  }
}

class ProductListAdd extends StatefulWidget {
  @override
  _ProductListAddState createState() => _ProductListAddState();
}

class _ProductListAddState extends State<ProductListAdd> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts();
  }

  void _addProduct(Product product) {
    // Aquí puedes realizar alguna acción con el producto agregado, como enviarlo a un servicio o almacenarlo en alguna lista
    print('Producto agregado: ${product.name}, Valor: ${product.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponents(),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
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
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return ProductCard(
                  product: product,
                  onAdd: () {
                    _addProduct(product);
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
  final Product product;
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
        title: Text(product.name),
        subtitle: Text('Valor: \$${product.value.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: onAdd,
        ),
      ),
    );
  }
}
