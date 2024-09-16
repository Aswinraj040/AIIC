import 'dart:math';
import 'package:enjoyfood/widgets/appbarwidgets.dart';
import 'package:enjoyfood/widgets/cartProvider.dart';
import 'package:enjoyfood/widgets/drawer.dart';
import 'package:enjoyfood/widgets/itembotomnavbar.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';

// Global variable to track if it's the first time ordering
bool isFirst = true;

class CartPage extends StatelessWidget {
  final TextEditingController _remarkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context , listen: false);
    final items = cartProvider.items.keys.toList();
    _remarkController.text = cartProvider.remarks;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1B285B)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Cart",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B285B),
              )),
        ),
        body: ListView(
          children: [
            Appbarwidget(),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                        left: 10,
                      ),
                      child: Text("Order List",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xFF1B285B),
                          )),
                    ),
                    // Display each item in the cart
                    for (var itemName in items)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[700]!,
                                spreadRadius: 1,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Item Image
                              Container(
                                height: MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      'http://${AppConstants.apiBaseUrl}:3000/images/${cartProvider.itemDetails[itemName]!['image_path']}',
                                    ),
                                  ),
                                ),
                              ),
                              // Item Details
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Item Name
                                    Padding(
                                      padding: EdgeInsets.only(top: 25, bottom: 10),
                                      child: Text(
                                        itemName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1B285B),
                                        ),
                                      ),
                                    ),
                                    // Item Price
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "₹${cartProvider.itemDetails[itemName]!['price']}",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1B285B),
                                        ),
                                      ),
                                    ),
                                    // Increment/Decrement Buttons
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            cartProvider.removeItem(cartProvider.itemDetails[itemName]);
                                          },
                                          child: Icon(
                                            CupertinoIcons.minus,
                                            size: 18,
                                            color: Color(0xFF1B285B),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            '${cartProvider.getItemCount(cartProvider.itemDetails[itemName])}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B285B),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            cartProvider.addItem(cartProvider.itemDetails[itemName]);
                                          },
                                          child: Icon(
                                            CupertinoIcons.plus,
                                            size: 18,
                                            color: Color(0xFF1B285B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                      child: Text(
                        "Remarks (optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF1B285B),
                        ),
                      ),
                    ),
                    // Remark TextBox
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _remarkController,
                        onChanged: (value){
                          cartProvider.setRemarks(value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter any additional requests or remarks',
                        ),
                      ),
                    ),
                    // Payment Details Section
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                      child: Text(
                        "Payment Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0xFF1B285B),
                        ),
                      ),
                    ),
                    // Payment Summary
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[700]!,
                            spreadRadius: 1,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item Total:",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B285B),
                                  ),
                                ),
                                Text(
                                  "₹${cartProvider.totalPrice}",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B285B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xFF1B285B),
                            thickness: 1.5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total:",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B285B),
                                  ),
                                ),
                                Text(
                                  "₹${cartProvider.totalPrice}",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B285B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xFF1B285B),
                            thickness: 1.5,
                          ),
                          // Submit/Update Order Button
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                final random = Random();
                                final uniqueOrderId = 'ORDER${random.nextInt(1000000).toString().padLeft(6, '0')}'; // Generate a random order ID
                                final tableNumber = (random.nextInt(20) + 1).toString(); // Random table number between 1 and 20
                                final memberId = html.window.localStorage['membid'];
                                final remarks = _remarkController.text;// Retrieve member ID

                                // Update the global isFirst variable after submitting the order
                                cartProvider.submitOrder(uniqueOrderId, tableNumber, memberId, context , isFirst , remarks);
                                isFirst = false;
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xFF1B285B)),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                                ),
                              ),
                              child: Text(
                                isFirst ? "Submit Order" : "Update Order",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: Drawerwidget(),
      ),
    );
  }
}
