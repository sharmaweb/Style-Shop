import '../Providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  CartItem({this.id, this.price, this.quantity, this.title, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: EdgeInsets.only(right: 15),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_sweep,
          size: 35,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context,
        builder: (ctx)=>
        AlertDialog(
          title: Text('Are you sure'),
          content: Text('Do you want to remove the item from your cart'),
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: Text('No')),
            FlatButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: Text('Yes'))
          ],
        ));
      },
      onDismissed: (direction){
        Provider.of<Cart>(context, listen:false).deleteItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        '\$$price',
                      ))),
            ),
            title: Text(title),
            subtitle: Text('\$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
