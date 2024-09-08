import 'package:enjoyfood/pages/ItemPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Constants.dart';

class SizeConfig {
  double heightSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }
}

class Popularlist extends StatefulWidget {
  @override
  _PopularlistState createState() => _PopularlistState();
}

class _PopularlistState extends State<Popularlist> {
  List<dynamic> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final response = await http.get(Uri.parse('http://${AppConstants.apiBaseUrl}:3000/menuitems'));

    if (response.statusCode == 200) {
      setState(() {
        menuItems = jsonDecode(response.body);
      });
    } else {
      print('Failed to load menu items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: menuItems.map((item) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemPage(
                        item: item,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: 170,
                  height: 270,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[700]!,
                        spreadRadius: 1,
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.network(
                          'http://${AppConstants.apiBaseUrl}:3000/images/${item['image_path']}',
                          height: 150,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1b285b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item['type'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1b285b),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹ ${item['price']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1b285b),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}