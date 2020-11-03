import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/providers/products.dart';
import '../main_drawer.dart';
import 'package:shopApp/screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_gride.dart';

 enum popupmenue{
    Favorite,
    All
  }


class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
 bool fav=false;
 var isInit=true;
 bool isLoading=false;
 
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(isInit){
      setState(() {
              isLoading=true;

      });
      
     Provider.of<Products>(context).fetchData().then((value){
       //print("jjjjjjjjjjjjjjjjjjjjjjjjjjj222222222222222");
      setState(() {
        isLoading=false;
        isInit=false;

      });
    }).catchError((error){

setState(() {

        isLoading=false;
        isInit=false;

      });
    });
      
    
   

      
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(child: Icon(Icons.more_vert)
            ,itemBuilder: (ctx)=>[
      PopupMenuItem(child: Text("Favorites Only"),value: popupmenue.Favorite,),
            PopupMenuItem(child: Text("All"), value: popupmenue.All,),
          ],onSelected: (popupmenue value){
                    if(value==popupmenue.Favorite) 
                    setState(() {
                      fav=true;
                    });
                    else{
                      setState(() {
                                             fav=false;

                      });

                    }
                    
          },),
          Consumer<Cart>(
            builder: (_,cart,ch){
          return Badge(child:ch ,
             value:"${cart.itemsCount}" );
            },
            child:IconButton(icon: Icon(Icons.shopping_cart), 
            onPressed: ()=>Navigator.of(context).pushNamed(CartScreen.routeName)) ,
                     
          )
        ],
      ),
      body:isLoading?Center(child: CircularProgressIndicator(),) : ProductsGride(fav),
      drawer: MainDrawer(),
    );
  }
}
