import 'package:flutter/material.dart';
import 'package:graduation_project/screens/taskManagement/task_form_page.dart';
import 'package:graduation_project/screens/taskManagement/go_premium.dart';
import 'package:graduation_project/screens/taskManagement/tasks.dart';
import 'package:graduation_project/widgets/view_advertisements.dart';

class TrelloHomePage extends StatelessWidget {
  const TrelloHomePage({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network('https://static.vecteezy.com/system/resources/previews/000/439/863/original/vector-users-icon.jpg'),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Hi,user',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],

          ),

        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            child: Text('Welcome volunteer. This is the page where you can see all the tasks that you are responsible for',
              style: TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.bold
              ),),
          ),

          Container(
            padding: EdgeInsets.all(15),
            child: Text(
              'Tasks',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child:Tasks(), )
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar (),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF000000),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormPage()),
          );
        },
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
    );


  }
  Widget _buildBottomNavigationBar(){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10)]),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
            items:[
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home,
                  size: 30,
                  color: Colors.black,
                ),),
              BottomNavigationBarItem(
                label: 'Person',
                icon: Icon(Icons.person,
                  size: 30,
                  color: Colors.black,
                ),
              )] ),


      ),
    );
  }

}
class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: Center(
        child: Text('This is page one'),
      ),
    );
  }
}
