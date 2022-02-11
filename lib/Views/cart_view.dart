import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_gerenciamento/components/cart_item.dart';
import 'package:shop_gerenciamento/models/cart.dart';
import 'package:shop_gerenciamento/models/order_list.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('carinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      'R\$${cart.totalAmount}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  const Spacer(),
                  cartbutton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItemWidget(cartItem: items[i]),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class cartbutton extends StatefulWidget {
  const cartbutton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<cartbutton> createState() => _cartbuttonState();
}

// ignore: camel_case_types
class _cartbuttonState extends State<cartbutton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.countItem == 0
                ? null
                : () async {
                    setState(() => isLoading = true);
                    await Provider.of<OrderList>(
                      context,
                      listen: false,
                    ).addOrder(widget.cart);
                    widget.cart.clear();
                    setState(() => isLoading = false);
                  },
            child: Text(
              'COMPRAR',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
  }
}
