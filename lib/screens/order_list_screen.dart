//order_list_screen.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../widgets/order_card.dart';
import 'dart:async';
import 'dart:html' as html; // Import dart:html to access localStorage
import 'package:enjoyfood/pages/login.dart'; // Import LoginPage
import '../main.dart'; // Import the logout function

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    _loadOrders();

    // Set up a timer to trigger the refresh every 20 seconds
    Timer.periodic(Duration(seconds: 20), (Timer timer) {
      _handleRefresh();
    });
  }

  Future<void> _loadOrders() async {
    setState(() {
      _orders = ApiService.getOrders();
    });
  }

  Future<void> _handleRefresh() async {
    List<Order> orders = await ApiService.getOrders();
    List<String> updatedOrderIds = orders
        .where((order) => order.isUpdated)
        .map((order) => order.uniqueOrderId)
        .toList();
    await ApiService.resetUpdates(updatedOrderIds);
    setState(() {
      _orders = Future.value(orders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1b285b),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white, // Set the icon color to white
            ),
            onPressed: () {
              logout(context); // Call the logout function
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF1b285b),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<Order>>(
          future: _orders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders available',style: TextStyle(color: Colors.white),));
            } else {
              List<Order> orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  Order order = orders[index];
                  return OrderCard(
                    order: order,
                    onOrderClosed: _handleRefresh,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
