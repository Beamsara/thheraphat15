import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theeraphat15/pages/update_page.dart';
import 'package:theeraphat15/pages/add_page.dart'; // Make sure to import AddPage

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  void _deleteUser(String docId) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['ชื่อ']),
                subtitle: Text(data['อีเมล']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, // Ensures the row is as small as possible
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePage(
                              docId: document.id,
                              currentName: data['ชื่อ'],
                              currentEmail: data['อีเมล'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteUser(document.id);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(), // Navigate to AddPage
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add User',
      ),
    );
  }
}
