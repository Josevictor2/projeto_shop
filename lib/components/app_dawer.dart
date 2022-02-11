import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_gerenciamento/models/auth.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:percent_indicator/percent_indicator.dart';
import 'package:shop_gerenciamento/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo Usuário!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
              leading: const Icon(
                Icons.shop,
              ),
              title: const Text('Loja'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.authorhome);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Pedidos'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.orders);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Gerenciar Produtos'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.productview);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.authorhome);
              }),
          // Padding(
          //   padding: const EdgeInsets.all(25.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       SizedBox.fromSize(
          //         size: const Size(56, 56),
          //         child: ClipOval(
          //           child: Material(
          //             color: Colors.green,
          //             child: InkWell(
          //               splashColor: Colors.lightGreen,
          //               onTap: () {},
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: const [
          //                   Tooltip(
          //                     message: 'Sim',
          //                     child: Icon(
          //                       Icons.check_sharp,
          //                       color: Colors.white,
          //                       semanticLabel: 'Sim',
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox.fromSize(
          //         size: const Size(56, 56),
          //         child: ClipOval(
          //           child: Material(
          //             color: Colors.red,
          //             child: InkWell(
          //               splashColor: Colors.redAccent,
          //               onTap: () {},
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: const [
          //                   Tooltip(
          //                     message: 'Não',
          //                     child: Icon(
          //                       Icons.close,
          //                       color: Colors.white,
          //                       semanticLabel: 'Não',
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
          // CircularPercentIndicator(
          //   radius: 100.0,
          //   lineWidth: 6.0,
          //   percent: 0.4,
          //   center: SizedBox.fromSize(
          //     size: const Size(85, 85),
          //     child: ClipOval(
          //       child: Material(
          //         color: Colors.blue[300],
          //         child: InkWell(
          //           splashColor: Colors.blue[200],
          //           onTap: () {},
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: const [
          //               Tooltip(
          //                 message: 'Não',
          //                 child: Icon(
          //                   Icons.chevron_right,
          //                   size: 60,
          //                   color: Colors.white,
          //                   semanticLabel: 'Sim',
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          //   backgroundColor: Colors.white,
          //   progressColor: Colors.blue,
          // ),
        ],
      ),
    );
  }
}
