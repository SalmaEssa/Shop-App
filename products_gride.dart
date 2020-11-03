import 'package:flutter/material.dart';
import 'package:shopApp/providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';

class ProductsGride extends StatelessWidget {
  final fav;
  ProductsGride(this.fav);
  @override
  Widget build(BuildContext context) {
    final L=Provider.of<Products>(context);
    List<Product> loadedProducts=[];
    if(fav)
    loadedProducts=L.favorited;
    else{
          loadedProducts=L.items;

    }

    return loadedProducts.length==0?Center(child: Text("No Items to Show")): GridView.builder(
        padding: const EdgeInsets.all(10.0),
        
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: loadedProducts[i],
                  child: ProductItem(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      );
  }
}