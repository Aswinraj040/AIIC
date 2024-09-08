import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Constants.dart';


const Color primaryColor = Color(0xFF1b285b);
const Color unavailableColor = Colors.red;

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
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    var url = Uri.parse('http://${AppConstants.apiBaseUrl}:3000/menuitems');
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
      _fetchMenuItems(); // Refresh the list after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete menu item")),
      );
    }
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
        bool isAvailable = menuItem['available'] ?? true; // Fetching availability status
        return Container(
          color: isAvailable ? Colors.white : unavailableColor.withOpacity(0.2),
          child: ListTile(
            leading: menuItem['image_path'] != null
                ? Image.network(
              'http://${AppConstants.apiBaseUrl}:3000/images/${menuItem['image_path']}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : null,
            title: Text(menuItem['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menuItem['description']),
                Text('₹${menuItem['price']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _menuItems[index]['available'] = value; // Locally update the UI
                    });
                    _updateMenuItem(menuItem['name'], value); // Update on the server
                  },
                  activeColor: primaryColor,
                  inactiveThumbColor: unavailableColor,
                  inactiveTrackColor: unavailableColor.withOpacity(0.5),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _confirmDeleteMenuItem(menuItem['name']); // Show confirmation dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
