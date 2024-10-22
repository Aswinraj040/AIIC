import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart'; // Import MediaType from http_parser package
import 'dart:convert';
import 'dart:typed_data';
import '../Constants.dart';


const Color primaryColor = Color(0xFF1b285b);

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({Key? key}) : super(key: key);

  @override
  _AddMenuScreenState createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedType = "Veg";
  Uint8List? _selectedImageBytes; // To store the selected image bytes
  String? _base64Image; // To store the base64 string of the selected image
  String? _fileName; // To store the actual file name of the selected image
  Future<void> _addMenuItem() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedImageBytes == null) { // Check if an image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and pick an image")),
      );
      return;
    }

    var url = Uri.parse('http://${AppConstants.apiBaseUrl}:3000/add');
    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = _nameController.text;
    request.fields['type'] = _selectedType;
    request.fields['description'] = _descriptionController.text;
    request.fields['price'] = _priceController.text;
    request.fields['available'] = 'true';

    // Attach the image
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      _selectedImageBytes!,
      filename: _fileName ?? 'image.png', // Use the actual filename or fallback to 'image.png'
      contentType: MediaType('image', 'png'),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menu item added successfully")),
      );
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _selectedType = "Veg"; // Reset the dropdown to default
        _selectedImageBytes = null; // Clear the selected image
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add menu item: ${response.reasonPhrase}")),
      );
    }
  }
  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes(); // Read the image bytes
      setState(() {
        _selectedImageBytes = bytes; // Set the selected image bytes
        _base64Image = base64Encode(bytes); // Convert image to Base64 string if needed
        _fileName = pickedFile.name; // Set the filename
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Item'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Menu Item",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            DropdownButton<String>(
              value: _selectedType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: <String>['Veg', 'Non-Veg']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage, // Button to pick image
              child: const Text("Pick Image"),
            ),
            if (_selectedImageBytes != null) // Display the selected image using Image.memory
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.memory(
                  _selectedImageBytes!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.fill,
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _addMenuItem();
              },
              child: const Text("Add to Menu"),
            ),
          ],
        ),
      ),
    );
  }
}
