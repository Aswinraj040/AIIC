//order_details_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  OrderDetailsScreen({required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Future<Order> _order;

  @override
  void initState() {
    super.initState();
    _order = ApiService.getOrderDetails(widget.orderId);
  }

  void _closeOrder() async {
    try {
      await ApiService.closeOrder(widget.orderId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order closed successfully')),
      );
      // Navigate to Bill Screen and wait for result
      final result = await Navigator.pushReplacementNamed(
        context,
        '/bill',
        arguments: widget.orderId,
      );

      if (result == true) {
        // Notify that the order is closed and needs a refresh
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error closing order: $e')),
      );
    }
  }

  Widget buildDataTable(List<OrderItem> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Menu Item', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: items
            .map(
              (item) => DataRow(cells: [
            DataCell(Text(item.menuItem)),
            DataCell(Text(item.quantity.toString())),
            DataCell(Text('Rs.${item.individualPrice.toStringAsFixed(2)}')),
            DataCell(Text('Rs.${item.totalPrice.toStringAsFixed(2)}')),
          ]),
        )
            .toList(),
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.grey[200]!; // Use grey color for the header
          },
        ),
        dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.white; // Use white color for the rows
          },
        ),
        headingTextStyle: TextStyle(color: Colors.black),
        dataTextStyle: TextStyle(color: Colors.black),
        dividerThickness: 2,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFF1b285b),
      body: FutureBuilder<Order>(
        future: _order,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Order not found'),
            );
          } else {
            Order order = snapshot.data!;
            String formattedTime = DateFormat('yyyy-MM-dd – kk:mm').format(order.time);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Table Number: ${order.tableNumber}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Order Time: $formattedTime',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Order Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  buildDataTable(order.items),
                  SizedBox(height: 20),
                  SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _closeOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                          child: Text('Close Order',style: TextStyle(color: Colors.black),),
                        ),
                        // Add other buttons here if needed
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
