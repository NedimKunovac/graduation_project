import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';


class ChatSample extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(right: 80),
          child: ClipPath(
            clipper: UpperNipMessageClipper(MessageType.receive),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),

              ),
              child: Text('Hi, Developer How are you?',
                style: TextStyle(
                    fontSize: 16
                ),),
            ),

          ),
        ),
        Padding(padding: EdgeInsets.only(right: 80),
          child: ClipPath(
            clipper: UpperNipMessageClipper(MessageType.receive),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),

              ),
              child: Text('Hi, Developer How are you?',
                style: TextStyle(
                    fontSize: 16
                ),),
            ),

          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20,left: 110),
          child: ClipPath(
            clipper: LowerNipMessageClipper(MessageType.send),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),


              ),
              child: Text('Hi, Developer How are you. I am wirting a long text message for testing sake as I wish to see wether this container will hold all the text or if the overwflow or underflow will happen?',
                style: TextStyle(
                    fontSize: 16
                ),),
            ),

          ),
        ),
      ],
    );
  }
}