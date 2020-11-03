import 'package:flutter/cupertino.dart';
import 'package:shopApp/widgets/cart_item.dart';

class CartItem{
  final String id;
  final String title;
  final double price;
  final int quantity;
CartItem({this.id,this.price,this.title,this.quantity});
}

class Cart with ChangeNotifier{
Map<String,CartItem>_items={};

Map<String,CartItem> get items{
  return {..._items};
}

void addItem(String prodId, String title, double price){
  if(_items.containsKey(prodId))
  {
    _items.update(prodId, (value) => CartItem(id:value.id, price: value.price,
    title: value.title, quantity: value.quantity+1));
  }
  else{
    _items.putIfAbsent(prodId, () => CartItem(quantity: 1,
    title: title,price: price,id: DateTime.now().toString()));
  }
  notifyListeners();
}
int get itemsCount{
  return _items.length;
}
double get totalAmount{
  double sum=0;
  _items.forEach((key, value) {
    sum+=(value.price*value.quantity);
  });
  return sum;

}
void removeFromCart(String id){
  _items.remove(id);
  notifyListeners();
}
void undoAdding(String id){
  if(_items[id].quantity==1)
  _items.remove(id);
  else{
    _items.update(id, (current) =>CartItem(id:current.id,
     title:current.title,
      price:current.price, 
      quantity :current.quantity-1) );
  }
  notifyListeners();
}
void clear(){
  _items={};
  notifyListeners();
}
}