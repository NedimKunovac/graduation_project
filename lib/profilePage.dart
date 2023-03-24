import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage('assets/volunteer (1).png'),
              ),
              SizedBox(height: 16.0),
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Age: 25',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Location: Sarajevo, Bosnia and Herzegovina',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Profile info:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(
                    'Lorem ipsum doddddddddddddddddddddddddddddddddddddddddddddddddddddddlor sit amet, consectetur adipisciaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaang elit. Vestibulum congue dapibus risus, eget commodo nisi ultricies eget. Sed vitae pulvinar tellus, vel elementum augue. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse eleifend est non est tincidunt dictum. Nullam non eros nec libero bibendum iaculis vel ac arcu. Suspendisse potenti. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam bibendum, urna euismod faucibus gravida, lorem enim vestibulum augue, eu blandit lectus nisl ut justo. Fusce sit amet consequat velit. Duis bibendum augue vel neque commodo lacinia. Donec porttitor vel augue quis auctor. Fusce rhoncus neque quis eros pretium, in egestas eros euismod. Sed id luctus augue, id commodo metus. Sed sed nunc mi.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Skills:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Wrap(
                children: <Widget>[
                  Chip(
                    label: Text(
                      'Skill 1 ',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 2.0),
                  Chip(
                    label: Text(
                      'Skill 2 ',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 2.0),
                  Chip(
                    label: Text(
                      'Skill 3 ',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 2.0),
                  Chip(
                    label: Text(
                      'Skill 4 ',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 2.0),
                  Chip(
                    label: Text(
                      'Skill 5 ',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 2.0),
                  Chip(
                    label: Text(
                      'Skiiiiiiiiiiiiiiiiiiiill 6 ',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 2.0),
                  Chip(
                    label: Text(
                      'blbaaaaaaaaaaaaa ',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Active engagement:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 200.0,
                      height: 200.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 200.0,
                      height: 200.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 200.0,
                      height: 200.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 200.0,
                      height: 200.0,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Logout'),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Sign out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'No'),
                        child: const Text('No'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
