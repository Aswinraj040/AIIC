//routes.dart
import 'package:flutter/material.dart';
import 'screens/order_list_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/bill_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/orders': (context) => OrderListScreen(),
  '/order-details': (context) => OrderDetailsScreen(orderId: ModalRoute.of(context)!.settings.arguments as String),
  '/bill': (context) => BillScreen(orderId: ModalRoute.of(context)!.settings.arguments as String),
};
