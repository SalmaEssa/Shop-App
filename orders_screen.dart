import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName="\orders";

  @override
  Widget build(BuildContext context) {
   // print("build function");
    //final order=Provider.of<Orders>(context);
    return Scaffold( appBar: AppBar(title: Text("Your Orders"),),
    body: FutureBuilder(builder: (ctx, data){
 if(data.connectionState==ConnectionState.waiting)
 return Center(child: CircularProgressIndicator());
 else if (data.error!=null)
 return Center(child: Text("error acured"),);
 else 
 return Consumer<Orders>(builder: (cont,order,child){
   return ListView.builder(itemBuilder: (ctx,ind)=>OrderItem(order.items[ind]),
    itemCount: order.items.length,
    );
 });
  
    }, future:  Provider.of<Orders>(context,listen: false).fetchOrder(),)
    
    ,
    drawer: MainDrawer(),
    
    
    );
      
    
  }
}