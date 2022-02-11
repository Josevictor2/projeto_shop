import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_gerenciamento/models/cart.dart';
import 'package:shop_gerenciamento/models/cart_item.dart';
import 'package:shop_gerenciamento/models/order.dart';
import 'package:shop_gerenciamento/utils/constants.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([this._userId = '', this._token = '', this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final resp = await http
        .get(Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'));
    if (resp.body == 'null') return;
    Map data = jsonDecode(resp.body);
    data.forEach(
      (orderId, orderData) {
        items.add(Order(
          id: orderId,
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    productId: item['productId'],
                    name: item['name'],
                    quality: item['quality'],
                    price: item['price'],
                  ))
              .toList(),
          date: DateTime.parse(orderData['date']),
        ));
      },
    );
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'name': cartItem.name,
                    'quality': cartItem.quality,
                    'price': cartItem.price,
                  })
              .toList(),
          'date': date.toIso8601String(),
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.insert(
        0,
        Order(
          id: id,
          total: cart.totalAmount,
          products: cart.items.values.toList(),
          date: date,
        ));

    notifyListeners();
  }
}
