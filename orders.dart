import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem{
final String id;
final List<CartItem> cartItems;
final DateTime date;
final double amount;
OrderItem({@required this.id,@required this.amount,@required this.cartItems
,@required this.date});

}

class Orders with ChangeNotifier{
 List<OrderItem> _items=[];
final authtokent;
final userId;
Orders(this.authtokent,this._items, this.userId);
List<OrderItem>  get items{
  return [..._items];

}

List<Map<String,dynamic>> encodeMap(List<CartItem> l   )
{  List<Map<String,dynamic>>list=[];

  for(int i=1 ; i<l.length; ++i)
  {   list.add({
"id":l[i].id,
"price":l[i].price,
"title":l[i].title,
"quantity":l[i].quantity

  });
     

  }
return list;
}
Future<void> addOrder( List<CartItem> l, double amount) async
{    final date=DateTime.now();

  final url="https://flutter-updates-fdb5c.firebaseio.com/orders/$userId.json?auth=$authtokent";
try{
final response=await http.post(url,body: json.encode({
"amount":amount,
"date": date.toIso8601String(),
"cartItems":encodeMap(l)
})
);
_items.insert(0,OrderItem(id:json.decode(response.body)['name'] ,amount: amount,cartItems: l,date: DateTime.now()));
}
catch(error){
  throw error;
}
notifyListeners();
}
Future<void> fetchOrder()async {
  final  url="https://flutter-updates-fdb5c.firebaseio.com/orders/$userId.json?auth=$authtokent";
  try{
final response= await http.get(url);
final data=json.decode(response.body) as Map<String,dynamic>;
final List<OrderItem> loadedOrders=[];
data.forEach((key, value) {
loadedOrders.add(
  OrderItem(id: key, amount: value["amount"], cartItems: (value["cartItems"] as List<dynamic>).map((e){
return CartItem(id: e["id"],title:  e["title"],price:  e["price"],quantity:  e["quantity"]);

  }).toList()  , date:DateTime.parse(value["date"]) )
    );


 });
_items=loadedOrders;
notifyListeners();
  }
  catch(error){
    throw error;
  }


}


}