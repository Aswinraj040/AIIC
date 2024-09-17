import 'package:enjoyfood/pages/adminpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html; // Import dart:html to access localStorage
import 'package:enjoyfood/pages/CartPage.dart';
import 'package:enjoyfood/pages/ItemPage.dart';
import 'package:enjoyfood/pages/home.dart';
import 'package:enjoyfood/pages/login.dart';
import 'package:enjoyfood/widgets/cartProvider.dart';
import 'screens/order_list_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/bill_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check localStorage for stored data
    String? screen = html.window.localStorage['screen'];
    String? phno = html.window.localStorage['phno'];
    String? membid = html.window.localStorage['membid'];

    Widget initialScreen;

    // Determine the initial screen based on localStorage data
    if (screen != null && phno != null && membid != null) {
      if (screen == '1') {
        initialScreen = MainScreen();
      } else if (screen == '2') {
        initialScreen = OrderListScreen();
      } else if (screen == '3') {
        initialScreen = Homepage();
      } else {
        initialScreen = LoginPage();
      }
    } else {
      initialScreen = LoginPage(); // Default to LoginPage if no data is found
    }

    return MaterialApp(
      title: 'Restaurant Order Management & Food Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFF1b285b),
      ),
      home: initialScreen, // Set the initial screen
      onGenerateRoute: (settings) {
        final args = settings.arguments as String?;

        switch (settings.name) {
          case '/orders':
            return MaterialPageRoute(builder: (context) => OrderListScreen());
          case '/order-details':
            return MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(orderId: args ?? ''),
            );
          case '/bill':
            return MaterialPageRoute(
              builder: (context) => BillScreen(orderId: args ?? ''),
            );
          case '/':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case 'homePage':
            return MaterialPageRoute(builder: (context) => Homepage());
          case 'cartPage':
            return MaterialPageRoute(builder: (context) => CartPage());
          case 'adminPage': // Add route for the admin page
            return MaterialPageRoute(builder: (context) => MainScreen());
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('404 - Not Found'),
                  leading: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Center(
                  child: Text('Page not found...'),
                ),
              ),
            );
        }
      },
    );
  }
}
