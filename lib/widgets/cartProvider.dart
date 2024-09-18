//cartProvider.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../Constants.dart';
import 'package:http/http.dart' as http;

class CartProvider with ChangeNotifier {
  Map<String, Map<String, dynamic>> _itemDetails = {};
  Map<String, int> _items = {};
  String _remarks = "";

  String get remarks => _remarks;
  Map<String, int> get items => _items;
  Map<String, Map<String, dynamic>> get itemDetails => _itemDetails;

  void setRemarks(String newRemarks) {
    _remarks = newRemarks;
    notifyListeners();
  }

  void addItem(dynamic item) {
    String itemName = item['name'];

    if (!_itemDetails.containsKey(itemName)) {
      _itemDetails[itemName] = item;
    }

    if (_items.containsKey(itemName)) {
      _items[itemName] = _items[itemName]! + 1;
    } else {
      _items[itemName] = 1;
    }
    notifyListeners();
  }

  void removeItem(dynamic item) {
    String itemName = item['name'];

    if (_items.containsKey(itemName) && _items[itemName]! > 1) {
      _items[itemName] = _items[itemName]! - 1;
    } else {
      _items.remove(itemName);
      _itemDetails.remove(itemName);
    }
    notifyListeners();
  }

  int getItemCount(dynamic item) {
    return _items[item['name']] ?? 0;
  }

  int get totalItemCount {
    return _items.values.fold(0, (total, count) => total + count);
  }

  int get totalPrice {
    return _items.entries.fold(0, (total, entry) {
      String itemName = entry.key;
      int count = entry.value;
      int price = _itemDetails[itemName]!['price'] as int;
      return total + (price * count);
    });
  }

  // Fetch existing order on login
  Future<void> fetchExistingOrder(String memberId) async {
    final String url = 'http://${AppConstants.apiBaseUrl}:3000/orders/fetch-order';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'member_id': memberId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['orderExists']) {
          loadOrderData(responseData['orderData']); // Load the order data into the cart
        }
      } else {
        print('No existing order found for memberId: $memberId');
      }
    } catch (error) {
      print('Error fetching existing order: $error');
    }
  }

  // Load order data into cart
  void loadOrderData(Map<String, dynamic> orderData) {
    List items = orderData['items'];

    for (var item in items) {
      _items[item['menuItem']] = item['quantity'];
      _itemDetails[item['menuItem']] = {
        'price': item['individual_price'],
        'name': item['menuItem'],
      };
    }
    notifyListeners();
  }

  Future<String?> checkOrderExistence(String memberId) async {
    final String url = 'http://${AppConstants.apiBaseUrl}:3000/orders/check-order';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'member_id': memberId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['orderExists']) {
          return responseData['orderId']; // Return existing order ID
        }
      }
    } catch (error) {
      print('Error checking order existence: $error');
    }
    return null; // No existing order found
  }

  Future<void> submitOrder(String uniqueOrderId, String tableNumber, String? memberId, BuildContext context, bool isFirst, String? remarks) async {
    if (isFirst) {
      final String url = 'http://${AppConstants.apiBaseUrl}:3000/orders/create-order';

      List<Map<String, dynamic>> items = _items.entries.map((entry) {
        String itemName = entry.key;
        int quantity = entry.value;
        int price = _itemDetails[itemName]!['price'] as int;
        return {
          'menuItem': itemName,
          'quantity': quantity,
          'individual_price': price,
          'total_price': quantity * price,
        };
      }).toList();

      final orderData = {
        'unique_order_id': uniqueOrderId,
        'tableNumber': tableNumber,
        'member_id': memberId,
        'items': items,
        'remarks': remarks
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(orderData),
        );

        if (response.statusCode == 201) {
          print('Order created successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Order created successfully'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('Failed to create order: ${response.body}');
        }
      } catch (error) {
        print('Error sending order: $error');
      }
    } else {
      final String url = 'http://${AppConstants.apiBaseUrl}:3000/orders/update-order';
      List<Map<String, dynamic>> items = _items.entries.map((entry) {
        String itemName = entry.key;
        int quantity = entry.value;
        int price = _itemDetails[itemName]!['price'] as int;
        return {
          'menuItem': itemName,
          'quantity': quantity,
          'individual_price': price,
          'total_price': quantity * price,
        };
      }).toList();

      final updateData = {
        'member_id': memberId,
        'items': items,
        'remarks': remarks,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updateData),
        );

        if (response.statusCode == 200) {
          print('Order updated successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Order updated successfully'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('Failed to update order: ${response.body}');
        }
      } catch (error) {
        print('Error updating order: $error');
      }
    }
  }

  Future<void> updateOrder(String orderId, String tableNumber, String? memberId, BuildContext context) async {
    final String url = 'http://${AppConstants.apiBaseUrl}:3000/orders/update-order';

    List<Map<String, dynamic>> items = _items.entries.map((entry) {
      String itemName = entry.key;
      int quantity = entry.value;
      int price = _itemDetails[itemName]!['price'] as int;
      return {
        'menuItem': itemName,
        'quantity': quantity,
        'individual_price': price,
        'total_price': quantity * price,
      };
    }).toList();

    final orderData = {
      'order_id': orderId,
      'tableNumber': tableNumber,
      'member_id': memberId,
      'items': items,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        print('Order updated successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Order updated successfully'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to update order: ${response.body}');
      }
    } catch (error) {
      print('Error updating order: $error');
    }
  }
}
