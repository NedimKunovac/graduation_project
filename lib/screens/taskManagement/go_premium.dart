import 'package:flutter/material.dart';
class GoPremium extends StatelessWidget {
  const GoPremium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),

            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [

                    Padding(

                      padding: const EdgeInsets.all(5.0),
                      child: Text('This is your task managing tool where  you can see all your tasks',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10
                        ),),
                    )
                  ],
                ),


              ],
            ),
          )
        ],
      ),
    );
  }
}