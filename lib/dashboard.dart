import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
  SingleChildScrollView(
    child: Column(
    children: <Widget>[
      Advertisement(),
      Advertisement(),
      Advertisement(),
      Advertisement(),
      Advertisement(),
  ],
  ),
  ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currently Available Ads'),
      ),
      body: Container(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: onPressed,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class Advertisement extends StatefulWidget {
  const Advertisement({Key? key}) : super(key: key);

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

void onPressed() {
  // TODO: implement onPressed
}

class _AdvertisementState extends State<Advertisement> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
              child: ElevatedButton(
                onPressed: onPressed,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Padding(
                         padding: EdgeInsets.fromLTRB(0, 13, 10, 10),
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(20.0),
                           child: Container(
                             height: 55.0,
                             width: 55.0,
                             child: Image(
                                 image:AssetImage('assetsTesting/guySmiling.jpg'),
                             ),
                           ),
                         ),
                       ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 13, 10, 10),
                            child: Text(
                                'Lorem ipsum dolor sit amet',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                                  'Fusce porta, metus at vehicula blandit, dui velit maximus lorem, '
                                  'at dictum nulla felis id est. Phasellus non justo ac sem '
                                  'lacinia suscipit.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                              ),),
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

  }
}

