import 'package:flutter/material.dart';

class AcceptedApplicants extends StatelessWidget {
  const AcceptedApplicants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(25.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          width: 370.0,
          height: 90.0,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 8.0, top: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Name of the user',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Role of the user',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(25.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          width: 370.0,
          height: 90.0,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 8.0, top: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Name of the user',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Role of the user',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(25.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          width: 370.0,
          height: 90.0,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 8.0, top: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Name of the user',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Role of the user',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}