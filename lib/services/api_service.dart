//api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../Constants.dart';


class ApiService {
  static const String baseUrl = 'http://${AppConstants.apiBaseUrl}:3000'; // Base URL of your backend

  // Fetch all orders
  static Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  // Fetch order details by ID
  static Future<Order> getOrderDetails(String unique_order_id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders/$unique_order_id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Order.fromJson(data);
      } else {
        throw Exception(
            'Failed to load order details: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }


  // Fetch order history by unique_order_id
  static Future<Order> getOrderHistory(String unique_order_id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders/orderHistory/$unique_order_id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Order.fromJson(data);
      } else {
        throw Exception('Failed to load order history: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load order history: $e');
    }
  }

// Close an order
  static Future<void> closeOrder(String unique_order_id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/close/$unique_order_id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'paymentMethod': 'cash'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to close order: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to close order: $e');
    }
  }


  // Reset updates for orders
  static Future<void> resetUpdates(List<String> orderIds) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/reset-updates'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orderIds': orderIds}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reset updates: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to reset updates: $e');
    }
  }
}

