import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final apiKey = "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";

class ForumMessage {
  final String text;
  final bool isUser;

  ForumMessage({required this.text, required this.isUser});
}

class Forum extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForumState();
  }
}

class ForumState extends State<Forum> {
  TextEditingController messageController = TextEditingController();
  List<ForumMessage> forumMessages = [];

  void sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/text-davinci-003/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'prompt': message,
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        forumMessages.add(ForumMessage(text: message, isUser: true));
        forumMessages.add(ForumMessage(
            text: jsonResponse['choices'][0]['text'], isUser: false));
      });
    }
    else{
      print("Erreur : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 40,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: forumMessages.length,
                itemBuilder: (context,index){
                    final message = forumMessages[index];
                    return ChatBubble(
                      text: message.text,
                      isUser: message.isUser,
                    );
                }
              )),
          Padding(
              padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: ("Entrer votre message")
                  ),
                )),
                IconButton(onPressed: (){
                  sendMessage(messageController.text);
                  messageController.clear();
                }, icon: Icon(Icons.send))

              ],
            ),
          )
        ]
      ),
    );
  }
}


class ChatBubble extends StatelessWidget{
  final String text;
  final bool isUser;

  ChatBubble({required this.text, required this.isUser});
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Row(
        mainAxisAlignment: isUser? MainAxisAlignment.end: MainAxisAlignment.start,
        children: [
          if(!isUser)
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('AI'),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser? Colors.blue: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(text, style: TextStyle(
              color: Colors.white
            ),),
          ),
          if(isUser)
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person),
            )

        ],
      ),
    );
  }
}

