import 'package:enjoyfood/pages/adminhome.dart';
import 'package:flutter/material.dart';
import 'add_menu_screen.dart';
import 'update_menu_screen.dart';

const Color primaryColor = Color(0xFF1b285b);

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomeScreen(),  // New Home Screen with Update GST button
    const AddMenuScreen(),
    const UpdateMenuScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Restaurant Automation",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Update Menu",
          ),
        ],
      ),
    );
  }
}

// New HomeScreen widget with "Update GST" button
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to AdminHome page when "Update GST" button is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AdminHome()),
          );
        },
        child: const Text("Update GST"),
      ),
    );
  }
}
