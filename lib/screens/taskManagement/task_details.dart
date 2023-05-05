import 'package:flutter/material.dart';
class TaskDetails extends StatelessWidget {
  const TaskDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.only(left: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: Image.network('https://cdn.imgbin.com/9/1/7/imgbin-small-business-company-office-corporation-office-icon-insharepics-building-zVZnhzF62vgbB3HtnjkUK9iV6.jpg'),
              ),
            ),
            SizedBox(width: 10),
            Text('Taks description',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold
              ),)
          ],
        ),
      ),


      body: Text('Description of the tasks that volunteer should perform'),
    );

  }
}