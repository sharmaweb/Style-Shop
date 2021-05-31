import '../screens/edit_product_screen.dart';

import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/product_providers.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Produts'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (ctx, i) => UserProductItem(
                  productsData.items[i].title,
                  productsData.items[i].imageUrl,
                  productsData.items[i].id)),
        ),
      ),
    );
  }
}
