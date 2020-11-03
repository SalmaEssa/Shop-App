import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String title;
   final String id;
  final String description;
  final double price;
    final String imageUrl;
    bool isFavorite=false;

    Product({@required this.id, @required this.title,
    @required this.description,
    @required this.price,@required this.imageUrl,
     this.isFavorite=false})
;
Future<void> toggleFavorite(String id, String authtokent, String userid) async
{
  final old=isFavorite;
  isFavorite=!isFavorite;
    notifyListeners();

try{
 final url="https://flutter-updates-fdb5c.firebaseio.com/FavoriteUser/$userid/$id.json?auth=$authtokent"; //cant be const becaouse it will changes in run time multipl
    final respone= await http.put(url, body: json.encode(  
         this.isFavorite
      ));
if(respone.statusCode>=400)
{
  isFavorite=old;
  notifyListeners();

  
}

}
catch(error){
  isFavorite=old;
  notifyListeners();
}
  


  notifyListeners();
}
}