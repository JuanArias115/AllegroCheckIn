import 'dart:convert';
import 'dart:io';

import 'package:allegrocheckin/Service/RestService.dart';
import 'package:allegrocheckin/models/ProductsEstadia.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/estadias.dart';
import 'package:allegrocheckin/models/products.dart';

class ReserveService {
  // GET
  Future<CommandResult> getEstadias() async {
    final result = await RestService().httpGet("/getEstadias");
    return result;
  }

  Future<CommandResult> getproductsEstadias(id) async {
    final result = await RestService().httpGet("getDetalleEstadia?id=$id");
    return result;
  }

  Future<CommandResult> getproducts() async {
    final result = await RestService().httpGet("getCatalogo");
    return result;
  }

  // CREATE

  Future<CommandResult> addProductsEstadia(ProductoEstadia product) {
    final result =
        RestService().httpPost("addDetalleEstadia", product.toJson());
    return result;
  }

  Future<CommandResult> addReserva(Estadia estadia) async {
    final result = await RestService().httpPost("addEstadia", estadia.toJson());
    return result;
  }

  Future<CommandResult> addProducts(Producto product) {
    final result = RestService().httpPost("addItemCatalogo", product.toJson());
    return result;
  }

  //DELETE

  Future<CommandResult> deleteProductsEstadias(id) async {
    final result = await RestService().httpGet("deleteDetalleEstadia?id=$id");
    return result;
  }

  Future<CommandResult> deleteEstadias(id) async {
    final result = await RestService().httpGet("deleteEstadia?id=$id");
    return result;
  }

  Future<CommandResult> deleteProduct(id) async {
    final result = await RestService().httpGet("deleteItemCatalogo?id=$id");
    return result;
  }

  //UPDATE

  Future<CommandResult> updateProductsEstadia(
      ProductoEstadia productoEstadia) async {
    final result = await RestService()
        .httpPost("editDetalleEstadia", productoEstadia.toJson());
    return result;
  }
}
