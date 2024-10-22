//bill_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../Constants.dart';
import '../models/order.dart';

class BillScreen extends StatefulWidget {
  final String orderId;

  BillScreen({required this.orderId});

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late Future<Order> _orderHistory;

  @override
  void initState() {
    super.initState();
    _orderHistory = ApiService.getOrderHistory(widget.orderId);
  }

  void _handlePayment(String paymentMethod) async {
    var response = await http.post(
      Uri.parse('http://${AppConstants.apiBaseUrl}:3000/orders/payment/${widget.orderId}'),
      headers: {'Content-Type': 'application/json'},
      body: '{"paymentMethod": "$paymentMethod"}',
    );

    if (response.statusCode == 200) {
      var message = '';
      if (paymentMethod == 'cash') {
        message = 'Please pay the final amount in cash.';
      } else if (paymentMethod == 'online') {
        message = 'Payment link has been sent to your email.';
      } else if (paymentMethod == 'credit') {
        message = 'The final amount has been added to your credit limit.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Successful'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Error'),
            content: Text('An error occurred during the payment process.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildDataTable(List<OrderItem> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Menu Item', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        ],
        rows: items.map(
              (item) => DataRow(
            cells: [
              DataCell(Text(item.menuItem, style: TextStyle(color: Colors.white))),
              DataCell(Text(item.quantity.toString(), style: TextStyle(color: Colors.white))),
              DataCell(Text('Rs.${item.individualPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.white))),
              DataCell(Text('Rs.${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.white))),
            ],
          ),
        ).toList(),
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Color(0xFF1b285b); // Header color
          },
        ),
        dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Color(0xFF1b285b); // Row color
          },
        ),
        dividerThickness: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Bill', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1b285b),
      ),
      body: FutureBuilder<Order>(
        future: _orderHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Order not found'));
          } else {
            Order order = snapshot.data!;
            String formattedTime = DateFormat('yyyy-MM-dd – kk:mm').format(
                order.time);

            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      // Responsive width
                      constraints: BoxConstraints(maxWidth: 600),
                      // Max width to avoid too large size
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1b285b), // Background color
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Table Number: ${order.tableNumber}',
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Order Time: $formattedTime',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Order Items',
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          buildDataTable(order.items),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Final Price:',
                                style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Rs.${order.finalPrice.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () => _handlePayment('cash'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .white, // Button color
                                    ),
                                    child: Text('Pay with Cash',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () => _handlePayment('online'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .white, // Button color
                                    ),
                                    child: Text('Pay Online',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () => _handlePayment('credit'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .white, // Button color
                                    ),
                                    child: Text('Pay with Credit',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}