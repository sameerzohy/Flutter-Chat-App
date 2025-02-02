import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Messages'),
            );
          }

          final messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (cxt, index) {
              return Text(messages[index].data()['text']);
            },
          );
        });

    // return Center(
    //   child: Text('No Messages'),
    // );
  }
}
