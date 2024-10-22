import 'package:enjoyfood/pages/login.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';

class SizeConfig {
  double fontSize(BuildContext context, double value) {
    value /= 100;
    value = MediaQuery.of(context).size.height * value;
    if (value > 30) value = 30;
    return value;
  }
}

class Drawerwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF1b285b),
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1B285B),
              ),
              accountName: Text("Aswin",
                  style: TextStyle(
                      fontSize: SizeConfig().fontSize(context, 2.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              accountEmail: Text("aswinraj040@gmail.com",
                  style: TextStyle(
                      fontSize: SizeConfig().fontSize(context, 2.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assests/avat.jpg"),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "homePage");
            },
            leading: Icon(
              CupertinoIcons.home,
              color: Colors.white,
            ),
            title: Text("Home",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "cartPage");
            },
            leading: Icon(
              CupertinoIcons.cart_fill,
              color: Colors.white,
            ),
            title: Text("My Orders",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
          ListTile(
            onTap: () {
              // Clear all localStorage data
              html.window.localStorage.clear();

              // Clear all context and navigate to LoginPage using its route name
              Navigator.pushNamed(
                context,
                '/'
              );
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: Text("Log Out",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
