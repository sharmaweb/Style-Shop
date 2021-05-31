import '../Providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({this.id, this.amount, this.dateTime, this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }
   Future<void> fetchAndSetOrders() async {
    const url = 'https://shop-flutter-8d6ea.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }


  

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = 'https://shop-flutter-8d6ea.firebaseio.com/orders.json';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateAndTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'quantity': prod.quantity,
                    'price': prod.price,
                  })
              .toList()
        }));
  
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: cartProducts));
    notifyListeners();
  }
}