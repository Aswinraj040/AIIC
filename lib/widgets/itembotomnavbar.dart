import 'package:enjoyfood/widgets/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Itembtmnav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return BottomAppBar(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Total",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B285B),
                    )),
                SizedBox(width: 15),
                Text("₹${cartProvider.totalPrice}",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B285B),
                    )),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "cartPage");
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF1B285B)),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 13, horizontal: 15)),
              ),
              icon: Icon(
                CupertinoIcons.cart,
                color: Colors.white,
              ),
              label: Text("Go to cart",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
