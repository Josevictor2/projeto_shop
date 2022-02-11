import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_gerenciamento/data/exceptions/http_exceptions.dart';
import 'package:shop_gerenciamento/models/product.dart';
import 'package:shop_gerenciamento/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  // ignore: prefer_final_fields
  List<Product> _items = [];

  ProductList([this._userId = '', this._token = '', this._items = const []]);

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadPorducts() async {
    _items.clear(); // importante!!!

    final resp = await http
        .get(Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'));
    if (resp.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${Constants.userFavoriteBaseUrl}/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map data = jsonDecode(resp.body);
    data.forEach(
      (productId, productData) {
        final isFavorite = favData[productId] ?? false;
        _items.add(Product(
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['Url'],
          id: productId,
          title: productData['name'],
          isFavorite: isFavorite,
        ));
      },
    );
    notifyListeners();
  }

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future addProductFromData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['Url'] as String,
      title: data['name'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
      body: jsonEncode(
        {
          'name': product.title,
          'description': product.description,
          'price': product.price,
          'Url': product.imageUrl,
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: id,
        title: product.title,
      ),
    );
    notifyListeners();
  }

  Future updateProduct(Product product) async {
    int index = _items.indexWhere((el) => el.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            'name': product.title,
            'description': product.description,
            'price': product.price,
            'Url': product.imageUrl,
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((el) => el.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();
      final response = await http.delete(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExceptions(
          msg: 'Não foi possível excluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }
}

// List<Product> get items { forma global
//     if (_showFavoriteOnly) {
//       return _itens.where((prod) => prod.isFavorite).toList();
//     }
//     return [
//       ..._itens
//     ]; //Clonando a lista para q ela não possa ser acessada indevidamente.
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }