import 'package:flutter/material.dart';

class CartItem {
  final String id;

  final String title;
  final int quantity;
  final double price;
  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items =
      {}; // ={} is done so that we get zero insted of null
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalamount {
    var total = 0.0;
    total.toStringAsFixed(2);
    _items.forEach((key, item) {
      total += (item.price * item.quantity);
    });
    return total;
  }

  void deleteItem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void addItem(String productId, String titleI, double priceI) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: titleI,
          price: priceI,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingelItem(String productId) {
    if (!_items.containsKey(productId))
      return;
    else if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (exixtingCartId) => CartItem(
                id: exixtingCartId.id,
                title: exixtingCartId.title,
                price: exixtingCartId.price,
                quantity: exixtingCartId.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
  }
}
