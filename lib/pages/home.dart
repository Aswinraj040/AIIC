import 'package:enjoyfood/widgets/appbarwidgets.dart';
import 'package:enjoyfood/widgets/drawer.dart';
import 'package:enjoyfood/widgets/alllist.dart';
import 'package:enjoyfood/widgets/popularlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  double heightSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  double fontSize(BuildContext context, double value) {
    value /= 100;
    value = MediaQuery.of(context).size.height * value;
    if (value > 40) value = 40;
    return value;
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: ListView(
          children: [
            // Custom appbar
            Appbarwidget(),
            // Search Button
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
              ),
            ),
            // Popular heading
            Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  "Popular items",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().fontSize(context, 3.0),
                    color: Color(0xFF1B285B),
                  ),
                )),

            // Popular items list
            Popularlist(),
            // Newest items
            Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  "All items",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().fontSize(context, 3.0),
                    color: Color(0xFF1B285B),
                  ),
                )),
            // Newest list
            Newslist()
          ],
        ),

        // Drawer
        drawer: Drawerwidget(),

        floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[600]!,
                  spreadRadius: 1,
                  blurRadius: 6,
                )
              ]),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "cartPage");
            },
            child: Icon(
              CupertinoIcons.cart,
              color: Color(0xFF1B285B),
              size: 26,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
