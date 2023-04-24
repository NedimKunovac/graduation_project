import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [

          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Container(
              alignment: Alignment.centerRight,
              width: 290,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: (){
                // Action for the send button
              },
              icon: Icon(Icons.send, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
