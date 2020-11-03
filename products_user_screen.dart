import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../main_drawer.dart';
import '../providers/products.dart';
import '../widgets/product_user_item.dart';

class ProductsUserScreen extends StatelessWidget {
  static const routeName="\ProductUser";
  Future<void> _refresh(BuildContext ctx) async{
await Provider.of<Products>(ctx,listen: false).fetchData(true);

  }
  @override
  Widget build(BuildContext context) {
      //final products=Provider.of<Products>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed:()=> Navigator.of(context).pushNamed(EditProductScreen.routeName)
          )
        ],
      ),
      
      body: FutureBuilder(
        future:_refresh(context),
        builder: (ctx, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
          return Center(child:CircularProgressIndicator(),);
          return RefreshIndicator(
          onRefresh: ()=>_refresh(context),
                child: Padding(
            padding: EdgeInsets.all(8),
                  child: Consumer<Products>( builder: (ctx, products,_ )=>ListView.builder(itemBuilder: (ctx,ind){
              return Column(
                children: [
                    ProductUserItem(products.items[ind].id, products.items[ind].imageUrl,products.items[ind].title),
                    Divider()
                ],
              );
            },
            itemCount: products.items.length,),
                                      
                  ),
          ),
        );
        },
            
      ),
      drawer: MainDrawer(),
    );
  }
}