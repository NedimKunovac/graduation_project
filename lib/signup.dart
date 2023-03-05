import 'package:flutter/material.dart';
import 'dashboard.dart';
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);},
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Sign up',
                      style: TextStyle(fontSize:30,
                          fontWeight:FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text('Create your account.',
                      style: TextStyle(
                          fontSize:14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                      ),)
                  ],
                ),
                Column(
                  children: <Widget>[
                    inputFile(label: 'Name and Surname'),
                    inputFile(label: 'Date of birth'),
                    inputFile(label:'Skills'),
                    inputFile(label: 'Email'),
                    inputFile(label: 'Password',obscureText: true)
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top:3,left: 3 ),
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
              ]),


        ),
      ),
    );

  }
}
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