
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopApp/models/http_exception.dart';
import './product.dart';



class Products with ChangeNotifier{

 List<Product> _items= [
   /*  Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
    
  ];
  final  authtoken;
  final userid;
  Products(this.authtoken,this._items, this.userid);
List<Product> get items{
  return [..._items];

}
List<Product> get favorited{
  return _items.where((element) => element.isFavorite).toList();

}
Future<void> addItem(Product item) async {
  final url='https://flutter-updates-fdb5c.firebaseio.com/products.json?auth=$authtoken';
  
  try{
    final response= await http.post(url, body: json.encode(
    { 
      "title":item.title,
    "description":item.description,
    "price":item.price,
    "imageUrl":item.imageUrl,
    "creatorId":userid

    
    }
  ));
Product new_item=Product(id: json.decode(response.body)['name'], title: item.title,
 description: item.description, price: item.price, imageUrl: item.imageUrl);
_items.add(new_item);
notifyListeners();
  }
catch(error){
//print(error);
throw error;

}

}

Future<void> fetchData([bool edit=false]) async{
  String ur="";
  if(edit)
  ur='&orderBy="creatorId"&equalTo="$userid';

var url='https://flutter-updates-fdb5c.firebaseio.com/products.json?auth=$authtoken"$ur"';
try{final response=await http.get(url);
url='https://flutter-updates-fdb5c.firebaseio.com/FavoriteUser/$userid.json?auth=$authtoken';

final data=json.decode(response.body) as Map<String,dynamic>;
if(data==null){
//print("krkrkrkr");
return;
}
final favresponse=await http.get(url);
final favdata=json.decode(favresponse.body);
List<Product> loadProducts=[];
data.forEach((iD, value) {
  loadProducts.add(Product(id: iD, title: value['title'], 
  description: value['description'], price: value["price"], imageUrl:value["imageUrl"],
  isFavorite: favdata==null? false: favdata[iD]??false
  )
  );
});
_items=loadProducts;
notifyListeners();
print(_items.length);
}
catch(error){

  throw error;
}

}
Product getItemById(String id){
return _items.firstWhere((element) => element.id==id);
}
Future<void> editItem(String id, Product item) async
{
  final url="https://flutter-updates-fdb5c.firebaseio.com/products/$id.json?auth=$authtoken"; //cant be const becaouse it will changes in run time multipl
     await http.patch(url, body: json.encode(
        {
          "title":item.title, 
          "description":item.description,
          "imageUrl":item.imageUrl,
          "price":item.price,

        }
      ));
 int ind=_items.indexWhere((element) => element.id==id);
  if (ind>=0){
      _items[ind]=item;
      notifyListeners();
  }
}
Future<void> remove_Item (String id) async{
 final url="https://flutter-updates-fdb5c.firebaseio.com/products/$id.json?auth=$authtoken";
  var ind=_items.indexWhere((element) => element.id==id);
    var removedItem=_items[ind];
  _items.removeWhere((element) => element.id==id);
notifyListeners();
  try{
    final response= await http.delete(url);
    
     // print("h3h3h3h31");
      if(response.statusCode>=400)
      throw HttpExceptions("Faild To Delete");
      else removedItem=null;
 }
 catch(error){
// print("hhhhhhhh");
       _items.insert(ind,  removedItem);
             notifyListeners();

           //notifyListeners();

       throw error;
 }
   
  /* return http.delete(url).then((response){
    print("fiirst");
    if(response.statusCode>=400)
      {       _items.insert(ind,  removedItem);
 notifyListeners();

        throw HttpExceptions("Faild To Delete");
      }
      else removedItem=null;
  });
    
 notifyListeners(); */

  
//print("first");
}
}

