import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _cgstController = TextEditingController();
  final _sgstController = TextEditingController();
  String _message = '';
  Map<String, dynamic>? _latestGst;
  List<Map<String, dynamic>> _gstHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchLatestGST();
  }

  Future<void> _fetchLatestGST() async {
    try {
      final response = await http.get(
        Uri.parse('http://${AppConstants.apiBaseUrl}:3000/gst'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _latestGst = json.decode(response.body);
          _cgstController.text = _latestGst?['cgst'].toString() ?? '';
          _sgstController.text = _latestGst?['sgst'].toString() ?? '';
        });
      } else {
        setState(() {
          _message = 'Failed to fetch GST rates';
        });
      }
    } catch (error) {
      setState(() {
        _message = 'An error occurred: $error';
      });
    }
  }

  Future<void> _fetchGSTHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://${AppConstants.apiBaseUrl}:3000/gst-history'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _gstHistory = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        setState(() {
          _message = 'Failed to fetch GST history';
        });
      }
    } catch (error) {
      setState(() {
        _message = 'An error occurred: $error';
      });
    }
  }

  Future<void> _showGstHistory() async {
    // Fetch the GST history first
    await _fetchGSTHistory();

    // Once data is fetched, show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('GST History'),
          content: Container(
            width: double.maxFinite,
            child: _gstHistory.isEmpty
                ? Text('No GST history available.')
                : ListView.builder(
              shrinkWrap: true,
              itemCount: _gstHistory.length,
              itemBuilder: (BuildContext context, int index) {
                final gst = _gstHistory[index];
                return ListTile(
                  title: Text('CGST: ${gst['cgst']}%, SGST: ${gst['sgst']}%'),
                  subtitle: Text('Updated at: ${gst['timestamp']}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateGST() async {
    final cgst = _cgstController.text;
    final sgst = _sgstController.text;

    if (cgst.isEmpty || sgst.isEmpty) {
      setState(() {
        _message = 'Please enter both CGST and SGST values';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://${AppConstants.apiBaseUrl}:3000/gst'), // Updated URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'cgst': cgst,
          'sgst': sgst,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = 'GST rates updated successfully';
        });
        _fetchLatestGST(); // Fetch the latest GST rates after update
      } else {
        setState(() {
          _message = 'Failed to update GST rates';
        });
      }
    } catch (error) {
      setState(() {
        _message = 'An error occurred: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Update GST Rates',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cgstController,
              decoration: InputDecoration(
                labelText: 'CGST (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _sgstController,
              decoration: InputDecoration(
                labelText: 'SGST (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateGST,
              child: Text('Update GST'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showGstHistory,
              child: Text('View GST History'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
