import 'Dashboard.dart';
import 'signUpRouter.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
          icon: Icon(Icons.arrow_back_ios,
          size: 20,
          color: Colors.black,)

        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width:double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Login',
                    style: TextStyle(fontSize:30,
                      fontWeight:FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text('Login to your account',
                    style: TextStyle(
                      fontSize:14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),)
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal:40),
                child:Column(
                  children: <Widget>[
                    inputFile(label: 'Email'),
                    inputFile(label: 'password',obscureText: true)
                  ],
                )
                ),
                Padding(padding: EdgeInsets.symmetric(
                  horizontal: 40),
                  child:Container(
                    padding: EdgeInsets.only(top:70,left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),

                    ),
                    child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Colors.red.shade400,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),

                        ),
                        child: Text('Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder:(context)=>Dashboard()));
                        }),
                ),

    )



                ]),

                 ),

                  Container(
                    padding: EdgeInsets.only(top: 100),
                    height:200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/permission.png'),
                        fit: BoxFit.fitHeight
                    ),
                  ),
                  ),
                  ],
              )),
            );





  }
}
//Widget for text fields
Widget inputFile({label,obscureText=false}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color:Colors.black,
        ),
      ),
      SizedBox(height: 5,),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400
            ),
          ),
        ),
      ),
      SizedBox(height: 10,)
    ],

  );
}