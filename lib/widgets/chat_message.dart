import 'package:chat_app/widgets/message_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
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
            reverse: true,
            itemBuilder: (cxt, index) {
              final chatMsg = messages[index].data();
              final nxtMsg = index + 1 < messages.length
                  ? messages[index + 1].data()
                  : null;
              final currUsr = chatMsg['userId'];
              final nxtUsr = nxtMsg != null ? nxtMsg['userId'] : null;
              final isSameUser = currUsr == nxtUsr;
              if (isSameUser) {
                return MessageBubble.next(
                    message: chatMsg['text'], isMe: currUsr == currentUser);
              }
              return MessageBubble.first(
                  username: chatMsg['username'],
                  message: chatMsg['text'],
                  isMe: currUsr == currentUser);
            },
          );
        });

    // return Center(
    //   child: Text('No Messages'),
    // );
  }
}
