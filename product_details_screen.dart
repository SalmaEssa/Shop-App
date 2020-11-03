import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  
static const routeName="/Product Details";
  @override
  
  Widget build(BuildContext context) {
    final id=ModalRoute.of(context).settings.arguments as String;
    final product=Provider.of<Products>(context, listen: false).getItemById(id);
    return Scaffold(
      /* appBar: AppBar(title: Text(product.title,),

      
      ), */
      body: CustomScrollView(
        slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(title:Text(product.title,), background: Hero(
                  tag: product.id,
                                child: Image.network(product.imageUrl,
                  fit: BoxFit.cover,
                  ),
                ) ),
        ),
        SliverList(delegate: SliverChildListDelegate([

          SizedBox(
                  height: 10,
                ),
              Text("\$${product.price}",style: TextStyle(color: Colors.grey,fontSize: 20),)
              ,
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(product.description, softWrap: true,
                textAlign: TextAlign.center,),
              ),
             SizedBox(height: 800,),

        ]))
        ],
            
      ),
    );
  }
}