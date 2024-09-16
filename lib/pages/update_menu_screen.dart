import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Constants.dart';

const Color primaryColor = Color(0xFF1b285b);
const Color unavailableColor = Colors.red;
const Color specialColor = Color(0xFFFFD700); // Golden color for Today's Special
const Color popularColor = Color(0xFF8A2BE2); // Violet color for Popular Items

class UpdateMenuScreen extends StatefulWidget {
  const UpdateMenuScreen({Key? key}) : super(key: key);

  @override
  _UpdateMenuScreenState createState() => _UpdateMenuScreenState();
}

class _UpdateMenuScreenState extends State<UpdateMenuScreen> {
  List<dynamic> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuItemsWithStatus();
  }

  Future<void> _fetchMenuItemsWithStatus() async {
    var url = Uri.parse('http://${AppConstants.apiBaseUrl}:3000/menu-items-status');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _menuItems = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch menu items")),
      );
    }
  }

  Future<void> _updateMenuItem(String name, bool available) async {
    var url = Uri.parse('http://${AppConstants.apiBaseUrl}:3000/update');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'name': name, 'available': available}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menu item updated successfully")),
      );
      _fetchMenuItemsWithStatus(); // Refresh the list after update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update menu item")),
      );
    }
  }

  Future<void> _deleteMenuItem(String name) async {
    var url = Uri.parse('http://${AppConstants.apiBaseUrl}:3000/delete/$name');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menu item deleted successfully")),
      );
      _fetchMenuItemsWithStatus(); // Refresh the list after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete menu item")),
      );
    }
  }

  Future<void> _toggleSpecial(String name) async {
    var url = Uri.parse('http://${AppConstants.apiBaseUrl}:3000/todays-special');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(response.body)['message'])),
        );
        _fetchMenuItemsWithStatus(); // Refresh the list
      } else {
        throw Exception('Failed to toggle Today\'s Special: ${response.body}');
      }
    } catch (error) {
      print('Error toggling Today\'s Special: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to toggle Today's Special: $error")),
      );
    }
  }

  Future<void> _togglePopular(String name) async {
    var url = Uri.parse('http://${AppConstants.apiBaseUrl}:3000/toggle-popular');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(response.body)['message'])),
        );
        _fetchMenuItemsWithStatus(); // Refresh the list
      } else {
        throw Exception('Failed to toggle Popular Item: ${response.body}');
      }
    } catch (error) {
      print('Error toggling Popular Item: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to toggle Popular Item: $error")),
      );
    }
  }

  Future<void> _editMenuItem(String name) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit option selected for $name")),
    );
    // Implement edit functionality here
  }

  void _confirmDeleteMenuItem(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete '$name'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteMenuItem(name); // Call the delete function
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        var menuItem = _menuItems[index];
        bool isAvailable = menuItem['available'] ?? true;
        bool isSpecial = menuItem['isTodaySpecial'] ?? false;
        bool isPopular = menuItem['isPopular'] ?? false;

        return Container(
          color: isSpecial
              ? specialColor.withOpacity(0.2)
              : (isAvailable ? Colors.white : unavailableColor.withOpacity(0.2)),
          child: ListTile(
            leading: menuItem['image_path'] != null
                ? Image.network(
              'http://${AppConstants.apiBaseUrl}:3000/images/${menuItem['image_path']}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : null,
            title: Row(
              children: [
                Text(menuItem['name']),
                if (isPopular) // Show a star icon for popular items
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.star,
                      color: popularColor,
                      size: 20,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menuItem['description']),
                Text('₹${menuItem['price']}'),
                Row(
                  children: [
                    Text("Available: "),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        _updateMenuItem(menuItem['name'], value);
                      },
                      activeColor: primaryColor,
                      inactiveThumbColor: unavailableColor,
                      inactiveTrackColor: unavailableColor.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editMenuItem(menuItem['name']);
                } else if (value == 'delete') {
                  _confirmDeleteMenuItem(menuItem['name']);
                } else if (value == 'togglePopular') {
                  _togglePopular(menuItem['name']);
                } else if (value == 'toggleSpecial') {
                  _toggleSpecial(menuItem['name']);
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: 'togglePopular',
                    child: Text(
                      isPopular ? 'Remove from Popular' : 'Add to Popular',
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'toggleSpecial',
                    child: Text(
                      isSpecial ? 'Remove from Today\'s Special' : 'Add to Today\'s Special',
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ];
              },
            ),
          ),
        );
      },
    );
  }
}
