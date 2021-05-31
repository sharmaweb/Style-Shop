import '../screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import '../Providers/cart.dart';
import '../Providers/product_providers.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String id;
  // final String title;
  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final producte = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    var scaffold= Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetail.routeName,
                arguments: producte.id,
              );
            },
            child: Image.network(
              producte.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
              title: Text(
                producte.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (ctx, producte, child) => IconButton(
                  icon: Icon(
                    producte.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () async{
                    try{
                    await Provider.of<Products>(context,listen: false).updateFavoriteStatus(producte.id, producte);
                    }catch(error){
                       scaffold.showSnackBar(
                        SnackBar(content: !producte.isFavorite? Text('Can\'nt add to favorites'):Text('Can\'t remove from favorites.'),
                      ));
                    }
                    // producte.toggleFavoriteStatus();
                  },
                ),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    cart.addItem(producte.id, producte.title, producte.price);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Item added to cart'),
                      duration: Duration(
                        seconds: 2,
                      ),
                      action: SnackBarAction(label: 'UNDO', onPressed: () {
                        cart.removeSingelItem(producte.id);

                      }),
                    ));
                  }))),
    );
  }
}
