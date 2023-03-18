//Import statements
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/advertisementForm.dart';
import 'advertisementWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, context}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

//Main part, navigation and all
class _DashboardState extends State<Dashboard> {
  static CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  static Future<DocumentSnapshot<Object?>>? fetchDoc() async {
    return await users.doc('${FirebaseAuth.instance.currentUser?.uid}').get();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'Your currently active volunteering opportunities:',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            Advertisement(
                title: 'OSCE',
                description:
                    'The OSCE stands for the Organization for Security and Co-operation in Europe.',
                adImage:
                    Image(image: AssetImage('assetsTesting/guySmiling.jpg')),
                accepted: true),
            Advertisement(
                title: 'The United Nations (UN)',
                description:
                    'The United Nations (UN) is an intergovernmental organization whose stated purposes are to maintain international peace and security, develop friendly relations among nations, achieve international cooperation, and be a centre for harmonizing the actions of nations.',
                adImage: Image(
                    image:
                        AssetImage('assetsTesting/advertisementIconTest.jpg')),
                accepted: true),
            Text(
              'Currently available volunteering opportunities:',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            Advertisement(
                title:
                    'Red Cross',
                description:
                    'The International Committee of the Red Cross (ICRC) ensuring humanitarian protection and assistance for victims of war and other situations of violence.',
                adImage:
                    Image(image: AssetImage('assetsTesting/flutterLogo.jpg')),
                accepted: false),
            Advertisement(
                title: 'AIESEC',
                description:
                    'AIESEC is an international youth-run and led, non-governmental and not-for-profit organization that provides young people with leadership development, cross-cultural internships, and global volunteer exchange experiences.',
                adImage:
                    Image(image: AssetImage('assetsTesting/flutterBird.png')),
                accepted: false),
            Advertisement(
                title: 'Sarajevo Film Festival',
                description:
                    'The Sarajevo Film Festival is the premier and largest film festival in Southeast Europe, and is one of the largest film festivals in Europe.',
                adImage: Image(
                    image:
                        AssetImage('assetsTesting/advertisementIconTest.jpg')),
                accepted: false),
          ],
        ),
      ),
      floatingActionButton: FutureBuilder<DocumentSnapshot>(
        future: fetchDoc(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return SizedBox.shrink();
          } else if (snapshot.hasData && !snapshot.data!.exists) {
            users.doc('${FirebaseAuth.instance.currentUser?.uid}').get();

            return SizedBox.shrink();
          } else if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            if (data['type'] == 0 || data['type'] == 1)
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
                      content: const Text('You will be redirected to the post creation page.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdvertisementForm())),
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () =>  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard())),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }

          return SizedBox.shrink();
        },
      ),
    ),
    Center(child: Text('Imagine you can see some messages')),
    SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: fetchDoc(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong",
                style: TextStyle(color: Colors.blue));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist",
                style: TextStyle(color: Colors.blue));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(children: <Widget>[
              //TODO: Create profile generator here
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        Image.network('${data['profilePhotoUrl']}').image,
                  ),
                  Text(
                    "Welcome ${data['name']}!",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Row(
                children: [Text('Name - ${data['name']}')],
              )
            ]);
          }

          return Text("loading", style: TextStyle(color: Colors.blue));
        },
      ),
    ),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          title: FutureBuilder<DocumentSnapshot>(
            future: fetchDoc(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return SizedBox.shrink();
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return SizedBox.shrink();
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return FadeIn(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  child: Text(
                    'Welcome ${data['name']}!',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              }

              return SizedBox.shrink();
            },
          ),
          leading: IconButton(
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
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          )),
      body: Container(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
