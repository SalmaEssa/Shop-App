import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName="/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
      final cart=Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Her is Your Cart"),),
body: Column(
  children: [
Card(
  margin: EdgeInsets.all(15),

child: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
    children: [
  
      Text("Total",style: TextStyle(fontSize: 20),)
  ,
  Chip(label: Text("\$${cart.totalAmount.toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).primaryTextTheme.headline1.color),),
  backgroundColor: Theme.of(context).primaryColor,)
    ,FlatButton( onPressed : cart.totalAmount<=0? null: () async
    {   setState(() {
      isLoading=true;
    });
    try{
     await  Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(),cart.totalAmount);
    cart.clear();
    setState(() {
      isLoading=false;
    });
    }
    catch(error)  {
     await showDialog<Null>(context: context, builder: (ctx){ // return null in show dialog (it's future) because .pop() dont erturn anyting, it's return null, and the returnong from the alert is what's coming from .pop
return AlertDialog(title: Text("un error occurred!"),
actions: [
    FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Ok"))
],
content: Text("something went wrong"),
);
});
setState(() {
     isLoading=false;

});

    }
    }
    , child: isLoading? CircularProgressIndicator(): Text("Order Now",style: TextStyle(color: Theme.of(context).primaryColor),
  
   )
    )
    ],
  
  ),
),
),
Expanded(child: ListView.builder(itemBuilder:(ctx,ind){
return CartItem(cart.items.values.toList()[ind].id
,cart.items.values.toList()[ind].title,
cart.items.values.toList()[ind].price,
cart.items.values.toList()[ind].quantity,
cart.removeFromCart,
cart.items.keys.toList()[ind]);

}
,
itemCount: cart.itemsCount,),
)
  ],
),
    );
  }
}