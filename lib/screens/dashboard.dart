import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:graduation_project/screens/messagingScreens/Messaging.dart';
import 'package:graduation_project/screens/profile_page.dart';
import 'package:graduation_project/widgets/reportIssue.dart';
import '../widgets/view_advertisements.dart';
import 'advertisement_form.dart';
import 'package:graduation_project/screens/edit_profile.dart';

///Dashboard, main page of the app
///Make sure hide code for easier view

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, context}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ///List of pages for botton navbar
  ///N pages must be equal to n buttons
  final List<Widget> _widgetOptions = <Widget>[];

  ///Bottom navbar logic
  ///Set navbar page to tapped icon
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex != index)
      setState(() {
        _selectedIndex = index;
      });
  }

  AppBarBulder(data) {
    final searchBar = TextEditingController();
    List<Widget> actionOptions = <Widget>[];
    if (_selectedIndex == 2) {
      actionOptions.add(
        PopupMenuButton(
          color: Colors.black54,
          onSelected: (result) {
            // Do something when an option is selected
            if (result == "Edit Profile") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(data: data)));
            } else if (result == "Report Issue") {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReportIssue();
                  });

            }else if (result == "Logout") {
              showDialog<String>(
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
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'No'),
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: "Edit Profile",
              child: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
            PopupMenuItem(
              value: "Report Issue",
              child: Text(
                "Report Issue",
                style: TextStyle(color: Colors.white),
              ),
            ),
            PopupMenuItem(
              value: "Logout",
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else if (_selectedIndex == 1) {
      return null;
    }

    return AppBar(
      elevation: 0,
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      title: AppBarTitleBulder(data),
      automaticallyImplyLeading: false,
      actions: actionOptions,
    );
  }

  ///Dynamically changes AppBar title based on page that is opened
  AppBarTitleBulder(data) {
    if (_selectedIndex == 2) {
      return Center(
          child: Text('Profile', style: TextStyle(color: Colors.black)));
    } else {
      var message = '';
      if (data['type'] == 0 || data['type'] == 2)
        message = 'Your currently available volunteering opportunities:';
      else
        message = 'Your currently active posts:';
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Welcome ${data['name']}!',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(message,
                style: TextStyle(color: Colors.grey, fontSize: 15)),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      );
    }
  }

  ///Adds Floating Action Button logic
  FloatingActionButtonBuilder(data) {
    if (_selectedIndex == 0 && (data['type'] == 0 || data['type'] == 1)) {
      return FadeIn(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeIn,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Are you sure you want to add a post?'),
              content: const Text(
                  'You will be redirected to the post creation page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdvertisementForm(
                                userID: FirebaseAuth.instance.currentUser?.uid,
                                userName: data['name'],
                                userProfilePhoto: data['profilePhotoUrl'],
                              ))),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'No'),
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  ///Structure itself
  Widget build(BuildContext context) {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          data["userID"] = FirebaseAuth.instance.currentUser?.uid;
          _widgetOptions.add(ViewAdvertisements(userData: data));
          _widgetOptions.add(Messaging());
          _widgetOptions.add(ProfilePage());

          return Scaffold(
            appBar: AppBarBulder(data),

            ///Body opens selected page/widget based on list above
            body: Container(child: _widgetOptions.elementAt(_selectedIndex)),

            ///Button that routes to create new advertisement page, doesn't load if volunteer is logged in
            floatingActionButton: FloatingActionButtonBuilder(data),

            ///Bottom navbar, tapped icons set index of page, aka call _onItemTapped()
            bottomNavigationBar: Container(
              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                )
              ]),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                items: const <BottomNavigationBarItem>[
                  ///HOME PAGE ICON
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: Colors.grey,
                  ),

                  ///MESSAGES ICON
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Messages',
                    backgroundColor: Colors.grey,
                  ),

                  ///PROFILE ICON
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profile',
                    backgroundColor: Colors.grey,
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue.shade500,
                onTap: _onItemTapped,
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Text('Loading'),
          ),
        );
      },
    );
  }
}
