import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/providers/auth.dart';
import './screens/products_user_screen.dart';
import './screens/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Column(
        children: [
          AppBar(
            title: Text("Hello Friend!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(title: Text("Shop"),
          leading: Icon(Icons.shopping_cart),
          onTap:()=> Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(title: Text("Orders"),
          leading: Icon(Icons.payment),
          onTap:()=> Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
           Divider(),
          ListTile(title: Text("Manage Products"),
          leading: Icon(Icons.edit),
          onTap:()=> Navigator.of(context).pushReplacementNamed(ProductsUserScreen.routeName),
          ),
          Divider(),
           ListTile(title: Text("Log Out"),
          leading: Icon(Icons.exit_to_app),
          onTap:(){
        Navigator.of(context).pop();
       Provider.of<Auth>(context,listen: false).logOut();
          }
          ),
          
        ],
      ),
    );
  }
}