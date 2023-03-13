import 'companySignup.dart';
import 'volunteerSignup.dart';
import 'package:flutter/material.dart';

class SignUpRouter extends StatelessWidget {
  const SignUpRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      //return button in the app bar
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text(
                      '  Which one are you?',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanySignup()));
                          },
                          child: Icon(
                            Icons.corporate_fare_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.all(65),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VolunteerSignup()));
                          },
                          child: Icon(
                            Icons.volunteer_activism,
                            size: 40,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.all(65),
                          ),
                        )
                      ],
                    ),
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}