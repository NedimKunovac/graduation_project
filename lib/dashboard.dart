/*
Section by Edin Žiga
Unique signature, totally not copied from random website
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣤⣤⣤⣤⣶⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠛⠉⠙⠛⠛⠛⠛⠻⢿⣿⣷⣤⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠋⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠈⢻⣿⣿⡄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣸⣿⡏⠀⠀⠀⣠⣶⣾⣿⣿⣿⠿⠿⠿⢿⣿⣿⣿⣄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⢰⣿⣿⣯⠁⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⡄⠀
⠀⠀⣀⣤⣴⣶⣶⣿⡟⠀ ⠀⢸⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷⠀
⠀⢰⣿⡟⠋⠉⣹⣿⡇⠀⠀⠘⣿⣿⣿⣿⣷⣦⣤⣤⣤⣶⣶⣶⣶⣿⣿⣿⠀
⠀⢸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀
⠀⣸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠉⠻⠿⣿⣿⣿⣿⡿⠿⠿⠛⢻⣿⡇⠀⠀
⠀⣿⣿⠁⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣧⠀⠀
⠀⣿⣿⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀
⠀⣿⣿⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀
⠀⢿⣿⡆⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀
⠀⠸⣿⣧⡀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠃⠀⠀
⠀⠀⠛⢿⣿⣿⣿⣿⣇⠀ ⠀⠀⣰⣿⣿⣷⣶⣶⣶⣶⠶⠀⢠⣿⣿⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⣽⣿⡏⠁⠀⠀⢸⣿⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⢹⣿⡆⠀⠀⠀⣸⣿⠇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢿⣿⣦⣄⣀⣠⣴⣿⣿⠁⠀⠈⠻⣿⣿⣿⣿⡿⠏⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⠿⠿⠿⠿⠋⠁⠀
*/
//Import statements
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'advertisementWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

generateAds() {
  List<Widget> genAds = [];
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, context}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

//Main part, navigation and all
class _DashboardState extends State<Dashboard> {
  static CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

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
    SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Advertisement(
              title: 'Lorem ipsum dolor sit amet',
              description:
                  'Tincidunt fermentum imperdiet. Fusce semper lectus id metus tincidunt, '
                  'sit amet pellentesque tellus consectetur.',
              adImage:
                  Image(image: AssetImage('assetsTesting/guySmiling.jpg'))),
          Advertisement(
              title: 'Duis dignissim diam quis sodales efficitur.',
              description:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec lacinia nulla eget mollis sollicitudin. '
                  'Donec aliquam lorem et varius fringilla. ',
              adImage: Image(
                  image:
                      AssetImage('assetsTesting/advertisementIconTest.jpg'))),
          Advertisement(
              title: 'Etiam auctor semper arcu, vel consequat arcu feugiat at.',
              description:
                  'Nulla mi nibh, dapibus sed bibendum vulputate, posuere sed massa. '
                  'Integer justo lorem, ultricies quis enim eu, lobortis elementum velit. ',
              adImage:
                  Image(image: AssetImage('assetsTesting/flutterLogo.jpg'))),
          Advertisement(
              title: 'Sed porttitor justo quis enim bibendum auctor.',
              description:
                  'Fusce vulputate dolor vitae sapien mollis, quis dapibus eros semper. '
                  'Donec sollicitudin metus odio, et pulvinar enim vestibulum non.',
              adImage:
                  Image(image: AssetImage('assetsTesting/flutterBird.png'))),
        ],
      ),
    ),
    Center(child: Text('Imagine you can see some messages')),
    SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: users.doc('${FirebaseAuth.instance.currentUser?.uid}').get(),
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
          title: Text('Welcome!'),
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
