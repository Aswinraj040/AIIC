import 'package:flutter/foundation.dart';

class OrderItem {
  final String menuItem;
  final int quantity;
  final double individualPrice;
  final double totalPrice;

  OrderItem({
    required this.menuItem,
    required this.quantity,
    required this.individualPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: json['menuItem'] ?? '',
      quantity: json['quantity'] ?? 0,
      individualPrice: (json['individual_price'] ?? 0.0).toDouble(),
      totalPrice: (json['total_price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem,
      'quantity': quantity,
      'individual_price': individualPrice,
      'total_price': totalPrice,
    };
  }
}

class Order {
  final String id;
  final String uniqueOrderId;
  final String tableNumber;
  final DateTime time;
  final List<OrderItem> items;
  final double finalPrice;
  final bool isClosed;
  final bool isUpdated; // New field

  Order({
    required this.id,
    required this.uniqueOrderId,
    required this.tableNumber,
    required this.time,
    required this.items,
    required this.finalPrice,
    required this.isClosed,
    this.isUpdated = false, // Default value for new orders
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<OrderItem> itemsList = itemsFromJson.map((item) => OrderItem.fromJson(item)).toList();

    return Order(
      id: json['_id'] ?? '',
      uniqueOrderId: json['unique_order_id'] ?? '',
      tableNumber: json['tableNumber'] ?? '',
      time: DateTime.parse(json['time']),
      items: itemsList,
      finalPrice: (json['final_price'] ?? 0.0).toDouble(),
      isClosed: json['isClosed'] ?? false,
      isUpdated: json['isUpdated'] ?? false, // Incorporate isUpdated field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tableNumber': tableNumber,
      'unique_order_id': uniqueOrderId,
      'items': items.map((item) => item.toJson()).toList(),
      'final_price': finalPrice,
      'isClosed': isClosed,
      'isUpdated': isUpdated, // Include isUpdated in JSON
    };
  }
}
