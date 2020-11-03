import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
    final String title;
    final double price;
    final int quantity;
    final Function remove_item;
    final item_id;
    CartItem(this.id,this.title,this.price, this.quantity,this.remove_item,this.item_id);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, size: 40, color: Colors.white,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),

      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction)
      { remove_item(item_id);

      },
          child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(padding: EdgeInsets.all(8),
        child: ListTile(
           leading: CircleAvatar(
             child: Padding(
               padding: const EdgeInsets.all(5),
               child: FittedBox(
                 child: Text("$price"),
               ),
             ),
           ) ,
           title: Text(title),
           subtitle: Text("Total ${(price*quantity)}"),
           trailing: Text("$quantity x"),
        ),
        ),
      ),
      confirmDismiss:(direction){
       return showDialog(context: context,builder: (ctx){
 return AlertDialog(
   title: Text("Are you sure?"),
   content: Text("Do you  want to remove this item from the cart?"),
actions: [FlatButton(onPressed: ()=>Navigator.of(ctx).pop(true), child: Text("ok"),),
FlatButton(onPressed:()=> Navigator.of(ctx).pop(false), child: Text("cancle"))]
 );
      });
      },
    );
  }
}