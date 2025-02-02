import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String> getName() async {
    var temp =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    return (temp.data()?['name']);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getName(), // Call the async function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                  "Loading..."); // Show temporary text instead of CircularProgressIndicator
            } else if (snapshot.hasError) {
              return Text("Error"); // Handle errors gracefully
            } else {
              return Text(
                  snapshot.data ?? "No Name"); // Display the fetched name
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: const [
              Expanded(child: ChatMessage()),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
