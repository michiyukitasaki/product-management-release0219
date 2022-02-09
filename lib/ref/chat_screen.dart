import 'package:flash_chat/components/rounded_Button.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/constants/transit_button.dart';
import 'package:flash_chat/constants/color_settig.dart';
import 'package:flash_chat/screens/image_screen.dart';
import 'package:flash_chat/components/chat_screen_print.dart';
import '../../image_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedinUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;


  String messageText;
  int messagelebel = 1;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getCurrentMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs){
  //     print(message.data());
  //   }
  // }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => chat_screen_print()));
              // _auth.signOut();
            }),
        // leading: Container(
        //   padding: EdgeInsets.all(5),
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       primary: okaneru_orange, //ボタンの背景色
        //     ),
        //     onPressed: (){
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => Image_Page()),
        //       );
        //     },
        //   ),
        // ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
                // _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       primary: okaneru_orange, //ボタンの背景色
            //     ),
            //     child: Center(
            //       child: transferButton(title: 'ImagePageへ'),
            //     ),
            //     onPressed: (){
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Image_Page()),
            //       );
            //     },
            //   ),
            // ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        child: TextField(
                          controller:messageTextController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          //Implement send functionality.
                          messageTextController.clear();
                          _firestore.collection('messages').add({
                            'text': messageText,
                            'sender': loggedinUser.email,
                          });
                        },
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          ;
          final messages = snapshots.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            final messageDate  = message.data()['date'];
            final messagelebel = message.data()['lebel'];

            final currentUser = loggedinUser.email;


            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
              lebel: messagelebel,
            );
            messageBubbles.add(messageBubble);
          }

          return Expanded(
            child: ListView(
              reverse: false,
              padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: messageBubbles,
            ),
          );
        });
  }
}



class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender,this.isMe,this.lebel});
  final String text;
  final String sender;
  final bool isMe;
  final int lebel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          Material(
            borderRadius: isMe?BorderRadius.only(topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):
            BorderRadius.only(topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe? Colors.white:Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  Text('今日の気分は$lebelです。')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



