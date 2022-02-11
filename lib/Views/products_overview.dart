import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_gerenciamento/components/app_dawer.dart';
import 'package:shop_gerenciamento/components/gridview_product.dart';
import 'package:shop_gerenciamento/models/cart.dart';
import 'package:shop_gerenciamento/models/product_list.dart';
import 'package:shop_gerenciamento/utils/app_routes.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverview extends StatefulWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadPorducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minha loja'),
          actions: [
            Consumer<Cart>(
              builder: (context, cart, child) => IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.cart);
                },
                icon: Badge(
                  badgeContent: Text('${cart.countItem}'),
                  child: const Icon(Icons.shopping_cart),
                ),
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  child: Text('Somente Favoritos'),
                  value: FilterOptions.favorite,
                ),
                const PopupMenuItem(
                  child: Text('Todos'),
                  value: FilterOptions.all,
                ),
              ],
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorite) {
                    _showFavoriteOnly = true;
                  } else {
                    _showFavoriteOnly = false;
                  }
                });
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridViewProduct(
                showFavoriteOnly: _showFavoriteOnly,
              ),
        drawer: const AppDrawer(),
      ),
    );
  }
}
