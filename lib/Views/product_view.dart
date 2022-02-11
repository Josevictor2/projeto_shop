import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_gerenciamento/components/app_dawer.dart';
import 'package:shop_gerenciamento/components/product_item.dart';
import 'package:shop_gerenciamento/models/product_list.dart';
import 'package:shop_gerenciamento/utils/app_routes.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadPorducts();
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<ProductList>(context); // jeito que eu fiz é assim
    final ProductList products = Provider.of(context); // jeito que leo fez
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productForm);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ProductItem(product: products.items[i]),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
