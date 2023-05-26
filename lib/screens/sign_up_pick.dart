import 'signup_company.dart';
import 'signup_volunteer.dart';
import 'package:flutter/material.dart';

///Page made so user can select if he is a company or a volunteer
///Legit just a router, just redirects user to other pages

class SignUpRouter extends StatelessWidget {
  const SignUpRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///Actual Page
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      //return button in the app bar
      appBar: AppBar(
        elevation: 0,
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
                  ///Text
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
                        ///Company button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanySignup()));
                          },
                          child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/512/3061/3061341.png')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // set background color to white
                            // set text color
                            shape: CircleBorder(),
                          ),
                        ),

                        ///Volunteer button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VolunteerSignup()));
                          },
                          child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/512/3045/3045363.png')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // set background color to white
                            // set text color
                            shape: CircleBorder(
                                //Mora ostati da bi buttons sa slikama ostali okrugli
                                ),
                          ),
                        ),
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
