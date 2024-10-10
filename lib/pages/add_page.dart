import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _addUser() async {
    String name = _nameController.text;
    String email = _emailController.text;

    if (name.isNotEmpty && email.isNotEmpty) {
      await _firestore.collection('users').add({
        'ชื่อ': name,
        'อีเมล': email,
      });

      // Clear the text fields
      _nameController.clear();
      _emailController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เพิ่มข้อมูลเรียบร้อย')),
      );

      // Navigate back to ListPage after adding data
      Navigator.pop(context);
    } else {
      // Show an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรอกชื่อและอีเมล')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูล'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'ชื่อ'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUser,
              child: Text('เพิ่มข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
