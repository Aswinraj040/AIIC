import 'package:enjoyfood/pages/home_page.dart';
import 'package:enjoyfood/screens/order_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';
import 'dart:convert';
import 'package:enjoyfood/pages/Steward.dart';
import 'package:enjoyfood/pages/home.dart';
// Import dart:html to use localStorage
import 'dart:html' as html;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  String _screen = '';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ensure that the phone number does not have any extra quotes
      String formattedPhoneNumber = _phoneNumber.replaceAll('"', '');

      final response = await http.get(
        Uri.parse('http://${AppConstants.apiBaseUrl}:3000/check?phno=$formattedPhoneNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(response.body);
        // Store the data in localStorage
        html.window.localStorage['screen'] = jsonResponse['screen'].toString();
        html.window.localStorage['phno'] = jsonResponse['phno'];
        html.window.localStorage['membid'] = jsonResponse['membid'];
        _screen = jsonResponse['screen'].toString(); // Save the screen number

        // Navigate to the appropriate screen based on the _screen value
        if (_screen == '1') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else if (_screen == '2') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderListScreen()),
          );
        } else if (_screen == '3') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        }
      } else {
        _showErrorDialog('Phone number not found');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        _phoneNumber = value;
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'Please enter phone number' : null;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: MaterialButton(
                      onPressed: _login,
                      child: Text('Login'),
                      color: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
