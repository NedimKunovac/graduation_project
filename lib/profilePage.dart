import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'tagField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  Map<String, dynamic> data;

  ProfilePage({Key? key, required this.data}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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
                backgroundImage: NetworkImage(widget.data['profilePhotoUrl']),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.data['name'],
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.data['dateOfBirth'] != null
                  ? Column(
                      children: [
                        SizedBox(height: 16.0),
                        Text(
                          'Age: ${(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.data['dateOfBirth'].seconds * 1000)).inDays / 365).round()}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              widget.data['dateOfBirth'] != null
                  ? Column(
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          'Date of birth: ${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.data['dateOfBirth'].seconds * 1000))}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              widget.data['profileInfo'] != null
                  ? Column(
                      children: [
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
                              widget.data['profileInfo'].toString(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              widget.data['skills'] != null
                  ? Column(
                      children: [
                        SizedBox(height: 16.0),
                        Text(
                          'Skills:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        RenderTags(
                            addedChips: List<String>.from(
                                widget.data['skills'] as List)),
                      ],
                    )
                  : SizedBox.shrink(),
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
                      width: 300.0,
                      height: 200.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                            height: 70,
                            width: 80,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 8.0, top: 8.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 300.0,
                      height: 200.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                            height: 70,
                            width: 80,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 8.0, top: 8.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 300.0,
                      height: 200.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                            height: 70,
                            width: 80,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 8.0, top: 8.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 300.0,
                      height: 200.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                            height: 70,
                            width: 80,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 8.0, top: 8.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Pending applications:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 400.0,
                      height: 80.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                            height: 50,
                            width: 70,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 40.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 400.0,
                      height: 80.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                            height: 50,
                            width: 70,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 40.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 400.0,
                      height: 80.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/4300/4300058.png'),
                            height: 50,
                            width: 70,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 40.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(right: 8.0),
                      width: 400.0,
                      height: 80.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://itkonekt.com/media/2022/09/Comtrade_transparent.png'),
                            height: 50,
                            width: 70,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 40.0, right: 8.0),
                              child: Text(
                                'Name of the company',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
