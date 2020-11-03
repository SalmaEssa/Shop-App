import 'package:flutter/material.dart';
import 'package:shopApp/helper/Custom_Route.dart';
import 'package:shopApp/providers/auth.dart';
import 'package:shopApp/providers/cart.dart';
import 'package:shopApp/screens/auth_screen.dart';
import 'package:shopApp/screens/splash_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/products_user_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import 'package:provider/provider.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>( update:(ctx,auth,previousProducts)=>Products(auth.token,
         previousProducts!=null?previousProducts.items:[],auth.userId  ),
         create: null,
          )
      ,ChangeNotifierProvider.value(value:Cart()),
      ChangeNotifierProxyProvider<Auth,Orders>(create: null, update:(ctx,auth,prevorders)=>Orders(auth.token,
      prevorders==null?[]: prevorders.items, auth.userId)),
      ],
      
          child: Consumer<Auth>(
            builder: (ctx, authdata, child)=>MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android:CustomPageTransationBuilder(),
              TargetPlatform.iOS:CustomPageTransationBuilder()
            }
          ),
            primarySwatch: Colors.red,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
            primaryTextTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.black,
     // fontSize: 20,
      fontWeight: FontWeight.bold
    )
  )
        ),
        home:authdata.isAuth?ProductsOverviewScreen(): FutureBuilder(builder: (ctx, shot)=>shot.connectionState==ConnectionState.waiting?SplashScreen():AuthScreen(),
  
        future: authdata.tryautologin(),
        ),
        
        
        routes: {
            ProductDetailsScreen.routeName:(ctx)=>ProductDetailsScreen(),
            CartScreen.routeName:(ctx)=>CartScreen(),
            OrdersScreen.routeName:(ctx)=>OrdersScreen(),
            ProductsUserScreen.routeName:(ctx)=>ProductsUserScreen(),
            EditProductScreen.routeName:(ctx)=>EditProductScreen()
        },
      )
                      
          ),
    );
  }
}
