import 'package:enjoyfood/pages/ItemPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';
import 'dart:convert';

class SizeConfig {
  double heightSize(BuildContext context, double value) {
    value /= 100;
    value = MediaQuery.of(context).size.height * value;
    if (value > 150) value = 150;
    return value;
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }
}

class Newslist extends StatefulWidget {
  @override
  _NewslistState createState() => _NewslistState();
}

class _NewslistState extends State<Newslist> {
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: menuItems.map((item) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  // Navigate to ItemPage with the specific item details
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
                  width: SizeConfig().widthSize(context, 95.0),
                  height: SizeConfig().heightSize(context, 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[700]!,
                        spreadRadius: 1,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.network(
                            'http://${AppConstants.apiBaseUrl}:3000/images/${item['image_path']}',
                            width: 120,
                            height: 150,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.white,
                          width: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color(0xFF1B285B),
                                ),
                              ),
                              Text(
                                item['description'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1B285B),
                                ),
                              ),
                              Text(
                                '₹ ${item['price']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B285B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 4),
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
