import '../Providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/product_providers.dart';
class ProductDetail extends StatelessWidget {
  static const routeName='/product-details';
  @override
  Widget build(BuildContext context) {
  final productId=ModalRoute.of(context).settings.arguments as String;
  final loadedProduct=Provider.of<Products>(context,listen: false).findById(productId);
  
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
              child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),
            ),
            SizedBox(height: 10,),
            Text('Price:- \$${loadedProduct.price}', style: TextStyle(
              color: Colors.grey,
              fontSize: 20,

            ),),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child:Text('${loadedProduct.description}',
              softWrap: true,
              textAlign: TextAlign.center,)
            )
          ],),
      ),
      
    );
  }
}