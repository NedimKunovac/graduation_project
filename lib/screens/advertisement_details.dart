import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_project/screens/applicants.dart';
import 'package:graduation_project/screens/taskManagement/details.dart';
import 'package:graduation_project/screens/taskManagement/trello_home_page.dart';
import 'package:graduation_project/widgets/tag_field.dart';
import 'package:graduation_project/screens/advertisement_form_update.dart';
import '../utilities/flash_bar.dart';

///Page that displays detailed information about post

class AdvertisementDetailed extends StatefulWidget {
  ///User data
  Map<String, dynamic> data;
  var userType;
  bool? viewingPost;

  AdvertisementDetailed({Key? key, required this.data, required this.userType, this.viewingPost})
      : super(key: key);


  @override
  State<AdvertisementDetailed> createState() => _AdvertisementDetailedState();
}

class _AdvertisementDetailedState extends State<AdvertisementDetailed> {
  ///Post loading options for volunteers, and first post set
  final List<bool> selectedLoading = <bool>[true, false, false];
  List<String> loadingTypes = <String>[
    'Tasks',
    'Applicants',
    'Post Details',
  ];

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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  bottomAppBarGenerator() {
    if (widget.data['authorID'] == FirebaseAuth.instance.currentUser?.uid ||
        widget.userType == 0) {
      if (selectedLoading[2])
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
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          updateAdvertisementForm(
                                              data: widget.data)));
                            },
                            child: const Text(
                              'I understand, I want to edit this post',
                              style: TextStyle(
                                color: Colors.black,
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
                                  color: Colors.red),
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
    } else if (widget.data['acceptedApplicants']
            .contains(FirebaseAuth.instance.currentUser?.uid) ||
        widget.data['applicationSubmitted']
            .contains(FirebaseAuth.instance.currentUser?.uid)) {
      return null;
    } else {
      return BottomAppBar(
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: applyToPost,
                color: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Apply',
                  style: TextStyle(color: Colors.white),
                ),
              )
              // add additional icons here as needed
            ],
          ),
        ),
      );
    }
  }

  getAppBar() {
    if(widget.viewingPost!){
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      );
    }

    if (widget.userType == 2 &&
        widget.data['acceptedApplicants']
            .contains(FirebaseAuth.instance.currentUser?.uid))
      return null;
    else
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      );
  }

  pagePicker() {
    if (widget.data['authorID'] == FirebaseAuth.instance.currentUser?.uid) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: 2,
            ),
            Ink(
              width: 350,
              height: 37,
              color: Colors.transparent,
              child: GridView.count(
                primary: true,
                crossAxisCount: 3,
                //set the number of buttons in a row
                crossAxisSpacing: 20,
                //set the spacing between the buttons
                childAspectRatio: 3,
                //set the width-to-height ratio of the button,
                //>1 is a horizontal rectangle
                children: List.generate(selectedLoading.length, (index) {
                  //using Inkwell widget to create a button
                  return InkWell(
                      splashColor: Colors.yellow,
                      //the default splashColor is grey
                      onTap: () {
                        //set the toggle logic
                        setState(() {
                          for (int indexBtn = 0;
                              indexBtn < selectedLoading.length;
                              indexBtn++) {
                            if (indexBtn == index) {
                              selectedLoading[indexBtn] = true;
                            } else {
                              selectedLoading[indexBtn] = false;
                            }
                          }
                        });
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          //set the background color of the button when it is selected/ not selected
                          color: selectedLoading[index]
                              ? Colors.red.shade400
                              : Colors.white,
                          // here is where we set the rounded corner
                          borderRadius: BorderRadius.circular(8),
                          //don't forget to set the border,
                          //otherwise there will be no rounded corner
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            loadingTypes[index],
                            style: TextStyle(
                              color: selectedLoading[index]
                                  ? Colors.white
                                  : Colors.red.shade400,
                            ),
                          ),
                        ),
                      ));
                }),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  pageGenerator() {
    if(widget.viewingPost!){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                ///CATEGORY
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Category:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.data['category'][0],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

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
                      child: RenderTags(
                          addedChips: List<String>.from(
                              widget.data['requirements'] as List)),
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
      );
    }
    if (widget.userType == 2) {
      return !widget.data['acceptedApplicants']
              .contains(FirebaseAuth.instance.currentUser?.uid)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      ///CATEGORY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Category:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              widget.data['category'][0],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

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
                            child: RenderTags(
                                addedChips: List<String>.from(
                                    widget.data['requirements'] as List)),
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
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: DetailPage(data: widget.data),
            );
    } else
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///PHOTO AT TOP + COMPANY NAME
          selectedLoading[2]
              ? Container(
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
                )
              : SizedBox.shrink(),

          ///BOX WITH DATA
          selectedLoading[2]
              ? Container(
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
                      ///CATEGORY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Category:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              widget.data['category'][0],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

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
                            child: RenderTags(
                                addedChips: List<String>.from(
                                    widget.data['requirements'] as List)),
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
                )
              : SizedBox.shrink(),

          selectedLoading[1]
              ? Center(child: AcceptedApplicants(data: widget.data))
              : SizedBox.shrink(),
          selectedLoading[0]
              ? SizedBox(
                  height: MediaQuery.of(context).size.height -
                      80 -
                      AppBar().preferredSize.height,
                  child: TrelloHomePage(postID: widget.data['postID'],))
              : SizedBox.shrink(),

          ///Zamotati u scaffold i dodati button
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.viewingPost==null) widget.viewingPost=false;
    ///Actual Page
    return Scaffold(
      appBar: getAppBar(),
      body: Column(
        children: [
          pagePicker(),
          Expanded(
            child: SingleChildScrollView(child: pageGenerator()),
          ),
        ],
      ),

      ///ACCEPT BUTTON
      bottomNavigationBar: bottomAppBarGenerator(),
    );
  }
}
