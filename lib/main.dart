import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_gerenciamento/Views/auth_or_home.dart';
import 'package:shop_gerenciamento/Views/auth_view.dart';
import 'package:shop_gerenciamento/Views/cart_view.dart';
import 'package:shop_gerenciamento/Views/orders_view.dart';
import 'package:shop_gerenciamento/Views/product_detail.dart';
import 'package:shop_gerenciamento/Views/product_form_view.dart';
import 'package:shop_gerenciamento/Views/product_view.dart';
import 'package:shop_gerenciamento/Views/products_overview.dart';
import 'package:shop_gerenciamento/models/order_list.dart';
import 'package:shop_gerenciamento/models/product_list.dart';
import 'package:shop_gerenciamento/utils/app_routes.dart';

import 'models/auth.dart';
import 'models/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (BuildContext context) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
                auth.userId ?? '', auth.token ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (BuildContext context) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
                auth.userId ?? '', auth.token ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
            primary: Colors.blue,
            secondary: Colors.deepOrange,
          ),
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ).copyWith(
            headline6: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        routes: {
          AppRoutes.authorhome: (cxt) => const AuthOrHome(),
          AppRoutes.productDetail: (cxt) => const ProductDetail(),
          AppRoutes.cart: (cxt) => const CartView(),
          AppRoutes.orders: (cxt) => const OrdersView(),
          AppRoutes.productview: (cxt) => const ProductView(),
          AppRoutes.productForm: (cxt) => const ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
