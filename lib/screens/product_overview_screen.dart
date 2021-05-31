import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';

import '../Providers/product_providers.dart';
import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../widgets/products_grid.dart';
import '../Providers/cart.dart';
import '../screens/cart_screen.dart';

enum FIlterOptions {
  Favorites,
  All,
}

class ProductOverview extends StatefulWidget {
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isloading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Products>(context,listen: false).fetchAndSetData();
      setState(() {
        _isloading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stlye Shop'),
          actions: [
            PopupMenuButton(
                onSelected: (FIlterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FIlterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FIlterOptions.Favorites,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: FIlterOptions.All,
                      )
                    ]),
            Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showOnlyFavorites));
  }
}
