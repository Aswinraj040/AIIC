import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:enjoyfood/widgets/appbarwidgets.dart';
import 'package:enjoyfood/widgets/drawer.dart';
import 'package:enjoyfood/widgets/alllist.dart';
import 'package:enjoyfood/widgets/popularlist.dart';
import 'package:flutter/cupertino.dart';

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

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String apiUrlCategories = 'http://localhost:3000/api/categories';
  final String apiUrlMenuItems = 'http://localhost:3000/menuitems';
  final String apiUrlSearch = 'http://localhost:3000/menuitems/search';

  List<String> categories = [];
  List<Map<String, dynamic>> menuItems = [];
  String? selectedCategory;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchAllMenuItems(); // Fetch all items by default
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrlCategories));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = ['All Items']; // Add "All Items" category
          categories.addAll(data.map((item) => item['name'] as String).toList());
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> _fetchAllMenuItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrlMenuItems));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          menuItems = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      print('Failed to load menu items: $e');
    }
  }

  Future<void> _fetchMenuItemsByCategory(String category) async {
    try {
      if (category == 'All Items') {
        _fetchAllMenuItems();
      } else {
        final response = await http.get(Uri.parse('$apiUrlMenuItems/category/$category'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            menuItems = data.map((item) => item as Map<String, dynamic>).toList();
          });
        } else {
          throw Exception('Failed to load menu items by category');
        }
      }
    } catch (e) {
      print('Failed to load menu items: $e');
    }
  }

  Future<void> _searchMenuItems(String query) async {
    try {
      final response = await http.get(Uri.parse('$apiUrlSearch?q=$query'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          menuItems = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to search menu items');
      }
    } catch (e) {
      print('Failed to search menu items: $e');
    }
  }

  void _showCategoryMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: ListView(
            children: categories.map((category) {
              return ListTile(
                leading: Icon(Icons.category),
                title: Text(category),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  setState(() {
                    selectedCategory = category;
                  });
                  _fetchMenuItemsByCategory(category);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      selectedCategory = null; // Clear category selection
    });
    _searchMenuItems(query); // Search as the user types
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: ListView(
          children: [
            Appbarwidget(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _onSearchChanged, // Search as user types
                decoration: InputDecoration(
                  labelText: 'Search food items',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "Popular items",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig().fontSize(context, 3.0),
                  color: Color(0xFF1B285B),
                ),
              ),
            ),
            Popularlist(),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "All items",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig().fontSize(context, 3.0),
                  color: Color(0xFF1B285B),
                ),
              ),
            ),
            AllList(menuItems: menuItems),
          ],
        ),
        drawer: Drawerwidget(),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 80,
              right: 10,
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
            Positioned(
              bottom: 150,
              right: 10,
              child: FloatingActionButton(
                onPressed: _showCategoryMenu,
                child: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 26,
                ),
                backgroundColor: Color(0xFF1B285B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


