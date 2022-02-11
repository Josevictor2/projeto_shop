import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_gerenciamento/components/app_dawer.dart';
import 'package:shop_gerenciamento/components/order.dart';
import 'package:shop_gerenciamento/models/order_list.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  // bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<OrderList>(
  //     context,
  //     listen: false,
  //   ).loadOrders().then((_) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  Future<void> refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return const Center(
                child: Text('Ocorreu um erro!'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => refreshOrders(context),
                child: Consumer<OrderList>(
                  builder: (ctx, orders, child) => ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, i) => OrderWidget(
                      order: orders.items[i],
                    ),
                  ),
                ),
              );
            }
          }),
      // body: isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //         onRefresh: () => refreshOrders(context),
      //         child: ListView.builder(
      //           itemCount: orders.itemsCount,
      //           itemBuilder: (ctx, i) => OrderWidget(
      //             order: orders.items[i],
      //           ),
      //         ),
      //       ),
    );
  }
}
