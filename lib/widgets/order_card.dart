//order_card.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import 'package:intl/intl.dart'; // Add this line
import '../screens/order_details_screen.dart';
import '../screens/bill_screen.dart'; // Ensure this path is correct

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onOrderClosed;

  OrderCard({required this.order, required this.onOrderClosed});

  @override
  Widget build(BuildContext context) {
    // Format the order time
    String formattedTime = DateFormat('yyyy-MM-dd – kk:mm').format(order.time);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.receipt_long, color: Colors.blue),
        title: Text(
          'Table Number: ${order.tableNumber}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Order Time: $formattedTime'),
        trailing: order.isUpdated
            ? Icon(Icons.notifications, color: Colors.red) // Bell icon for updates
            : Icon(Icons.arrow_forward_ios), // Default trailing icon
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(orderId: order.uniqueOrderId),
            ),
          );

          if (result == true) {
            // Call the callback function to update the order list
            onOrderClosed();
          }
        },
      ),
    );
  }
}
