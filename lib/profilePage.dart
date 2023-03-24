import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  Map<String, dynamic> data;

  ProfilePage({Key? key, required this.data}) : super(key: key);

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
                backgroundImage: NetworkImage(data['profilePhotoUrl']),
              ),
              SizedBox(height: 16.0),
              Text(
                data['name'],
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                //'Age: ${(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(data['dateOfBirth'].seconds * 1000)).inDays/365).round()}',
                'Age: TODO',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                //'Date of birth: ${DateFormat('dd.mm.yyyy.').format(DateTime.fromMillisecondsSinceEpoch(data['dateOfBirth'].seconds * 1000))}',
                'Date of birth: TODO',
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
                    'Hi, I\'m a free-spirited adventurer with a passion for exploring the great outdoors. I love hiking, camping, and discovering hidden gems off the beaten path. When I\'m not out exploring, you can find me indulging in my other love: cooking up a storm in the kitchen. I\'m always up for new experiences and meeting interesting people along the way!',
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
