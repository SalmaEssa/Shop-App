import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/providers/products.dart';
import 'package:shopApp/screens/edit_product_screen.dart';

class ProductUserItem extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String id;

  ProductUserItem(this.id,this.imgUrl,this.title) ;
  @override
  Widget build(BuildContext context) {
    final scaf=Scaffold.of(context);
    return ListTile(
      leading:CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ) ,
      title:Text(title) ,
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.edit, color:Theme.of(context).primaryColor,  ), onPressed:(){
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments:id );
            }),
            IconButton(icon: 
            Icon(Icons.delete, color: Theme.of(context).errorColor), 
            
            onPressed:() async{
              try{
      await Provider.of<Products>(context,listen: false).remove_Item(id);
          // print("okkkk salmaa") ;
              }
              catch(error){
                scaf.removeCurrentSnackBar();
              scaf.showSnackBar(SnackBar(content: Text(error.toString())));
              //throw error;
              }
            }
            
             )
          ],
        ),
      ),
    );
  }
}