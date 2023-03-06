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
import 'package:flutter/material.dart';
import 'advertisementWidget.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

generateAds() {
  List<Widget> genAds = [];
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

//Main part, navigation and all
class _DashboardState extends State<Dashboard> {
  String searchValue = '';
  List<String> _suggestions = ['Ad1', 'Ad2', 'Ad3'];

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
    Center(child: Text('Imagine you can see a profile')),
    Center(child: Text('Imagine you can see some settings')),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          foregroundColor: Colors.blue,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              flex: 1,
              child: Image(
                image: AssetImage('assetsTesting/flutterLogo.jpg'),
                height: 35,
                width: 35,
              ),
            ),
            Expanded(
              flex: 10,
              child: Center(child: Text('Imagine there is a title here')),
            ),
          ]),
          onSearch: (value) => setState(() => searchValue = value),
          suggestions: _suggestions),
      body: Container(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Can you not?'),
            content: const Text('I really don\'t like you pressing buttons'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Okay'),
                child: const Text('Okay'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Fine'),
                child: const Text('Fine'),
              ),
            ],
          ),
        ),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
