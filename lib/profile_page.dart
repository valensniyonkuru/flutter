import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF00897B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(_imageFile!),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _pickImage(ImageSource.gallery);
              },
              child: Text('Pick Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.teal, // Set the button's background color here
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your logic to upload _imageFile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Implement upload logic here')),
                );
              },
              child: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.teal, // Set the button's background color here
              ),
            ),
          ],
        ),
      ),
    );
  }
}
