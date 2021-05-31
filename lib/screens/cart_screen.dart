import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';
import '../Providers/orders_providers.dart';
import '../widgets/cart_item.dart'
    as ci; // to avoid name class, sice both cart.dart and card_item.dart have class of same name

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.totalamount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => ci.CartItem(
                        //ci.CartItem is done just to specify that we want to use cart item of cart_item.dart

                        id: cart.items.values.toList()[i].id,
                        productId: cart.items.keys.toList()[
                            i], // items return a map we cannot just use cart.items[i].id,  we use  cart.items.values.toList()[i].id
                        title: cart.items.values.toList()[i].title,
                        price: cart.items.values.toList()[i].price,
                        quantity: cart.items.values.toList()[i].quantity,
                      ))),
        ],
      ),
    );
  }
}

// We made a separate widget for the Order  Now button so that we don't have to render the whole screen, just to change the Order Now thing
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalamount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalamount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}