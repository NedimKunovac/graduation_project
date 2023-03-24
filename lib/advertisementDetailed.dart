import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_project/updateAdvertisementForm.dart';
import 'flashBar.dart';

///Page that displays detailed information about post

class AdvertisementDetailed extends StatefulWidget {
  ///User data
  Map<String, dynamic> data;
  var userType;

  AdvertisementDetailed({Key? key, required this.data, required this.userType})
      : super(key: key);

  @override
  State<AdvertisementDetailed> createState() => _AdvertisementDetailedState();
}

class _AdvertisementDetailedState extends State<AdvertisementDetailed> {
  applyToPost() async {
    try {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.data['postID'])
          .update({
        "applicationSubmitted":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
      });
      await flashBar.showBasicsFlashSuccessful(
        duration: Duration(seconds: 7),
        context: context,
        message:
            'You just applied to ${widget.data['title']}! Great job! \nYou can find this again post under the profile section.',
      );
    } catch (e) {
      await flashBar.showBasicsFlashFailed(
        duration: Duration(seconds: 5),
        context: context,
        message: e.toString(),
      );
    }
    Navigator.pop(context);
  }

  deletePost() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are you sure you want to delete this post?'),
        content: const Text(
            'Deleted posts cannot be recovered, and you will lose all your applicants. Think twice before you do this.'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('Posts')
                    .doc(widget.data['postID'])
                    .delete();
                await flashBar.showBasicsFlashFailed(
                  duration: Duration(seconds: 5),
                  context: context,
                  message:
                      'You just deleted your post! Maybe try adding a new one?',
                );
                Navigator.pop(context);
              } catch (e) {
                await flashBar.showBasicsFlashFailed(
                  duration: Duration(seconds: 5),
                  context: context,
                  message: e.toString(),
                );
              }
              Navigator.pop(context);
            },
            child: const Text(
              'I understand, delete this post',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, 'No, I want to keep this post'),
            child: const Text(
              'No, I want to keep this post',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bottomAppBarGenerator() {
    if (widget.data['authorID'] == FirebaseAuth.instance.currentUser?.uid ||
        widget.userType == 0) {
      return BottomAppBar(
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                          'Are you sure you want to edit this post?'),
                      content: const Text(
                          'Once you edit your post, you cannot revert your changes!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => updateAdvertisementForm(
                                      data: widget.data))),
                          child: const Text(
                            'I understand, I want to edit this post',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(
                              context, 'No, I don\'t want to edit this post'),
                          child: const Text(
                            'No, I don\'t want to edit this post',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.edit_calendar),
                color: Colors.red,
                iconSize: 35.0,
              ),
              IconButton(
                onPressed: deletePost,
                icon: Icon(Icons.delete_forever),
                color: Colors.red,
                iconSize: 35.0,
              ),
            ],
          ),
        ),
      );
    } else {
      return BottomAppBar(
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: applyToPost,
                icon: Icon(Icons.check_circle),
                color: Colors.red,
                iconSize: 35.0,
              ),
              // add additional icons here as needed
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Actual Page
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            '${widget.data['title']}',
            style: TextStyle(
              color: Colors.red.shade400,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ///PHOTO AT TOP + COMPANY NAME
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.data['profilePhotoUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.data['authorName'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ///DUE DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Due date:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${DateTime.fromMillisecondsSinceEpoch(widget.data['dueDate'].seconds * 1000).day}-${DateTime.fromMillisecondsSinceEpoch(widget.data['dueDate'].seconds * 1000).month}-${DateTime.fromMillisecondsSinceEpoch(widget.data['dueDate'].seconds * 1000).year}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    ///START DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Start Date:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${DateTime.fromMillisecondsSinceEpoch(widget.data['startDate'].seconds * 1000).day}-${DateTime.fromMillisecondsSinceEpoch(widget.data['startDate'].seconds * 1000).month}-${DateTime.fromMillisecondsSinceEpoch(widget.data['startDate'].seconds * 1000).year}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    ///END DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'End date:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${DateTime.fromMillisecondsSinceEpoch(widget.data['endDate'].seconds * 1000).day}-${DateTime.fromMillisecondsSinceEpoch(widget.data['endDate'].seconds * 1000).month}-${DateTime.fromMillisecondsSinceEpoch(widget.data['endDate'].seconds * 1000).year}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    ///LENGTH OF JOB
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Length of job:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${((widget.data['endDate'].seconds - widget.data['startDate'].seconds) / 86400).round()}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    ///NUMBER OF APPLICANTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Accepted applicants:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.data['applicants'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    ///DESCRIPTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Work description:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.data['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    ///REQUIREMENTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Requirements:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.data['requirements'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    ///OPPORTUNITIES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Opportunities:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.data['opportunities'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
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

        ///ACCEPT BUTTON
        bottomNavigationBar: bottomAppBarGenerator(),
      ),
    );
  }
}
