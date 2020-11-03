import 'package:flutter/material.dart';
import 'package:shopApp/providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Product>(context,listen: false);
  final cart=Provider.of<Cart>(context,listen: false);
  final auth=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
       borderRadius: BorderRadius.circular(10),
          child: GridTile(
        child:GestureDetector(
          onTap: ()=>Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,arguments: product.id),
          child: Hero(
            tag: product.id,
                      child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image:NetworkImage(product.imageUrl,) ,
               fit: BoxFit.cover
              ),
          )
          ) ,
        footer: GridTileBar(
          title: Text(product.title,textAlign: TextAlign.center,),
          backgroundColor: Colors.black87,           
          leading:Consumer<Product>(
            builder: (ctx, product, child){
              return IconButton(icon:
             Icon(product.isFavorite? Icons.favorite
             :Icons.favorite_border), onPressed:() async{
               await product.toggleFavorite(product.id,auth.token,auth.userId);

             },
            color: Theme.of(context).accentColor);
            },
                    
          ),

          trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed:(){
            cart.addItem(product.id,product.title,product.price);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Item added  to the Cart!"),
            duration: Duration(seconds: 2),
            action: SnackBarAction(label: "Undo",onPressed:()=>cart.undoAdding(product.id),)));

          
          }, 
          color: Theme.of(context).accentColor
          ,) ,
        ),
      ),
    );
  }
}