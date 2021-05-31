import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/orders_providers.dart';
import '../widgets/order_item.dart'as wg;

class OrderScreen extends StatefulWidget {
  static const  routeName='/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isInit=true;
  var _isLoading=false;
  @override
  void didChangeDependencies()  {
    if(_isInit){
    Provider.of<Orders>(context, listen:false).fetchAndSetOrders();
    }
    _isInit=false;
    super.didChangeDependencies();
  }
  //  void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final orderData=Provider.of<Orders>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(itemCount: orderData.orders.length,
      itemBuilder: (ctx,i)=>wg.OrderItem(
        orderData.orders[i],
      ),),
      
      
    );
  }
}