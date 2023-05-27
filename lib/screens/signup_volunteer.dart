import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_project/screens/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import '../utilities/flash_bar.dart';
import '../utilities/image_picker_custom.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/tag_field.dart';
import '../utilities/update_dictionary.dart';
import '../widgets/checkbox_tiles.dart';

///TODO: ADD SKILLS FOR VOLUNTEERS
///Volunteer sign up page
///Page made for volunteers to sign up, basically one big form
///Doesn't take any arguments, routes to login page

class VolunteerSignup extends StatefulWidget {
  const VolunteerSignup({Key? key}) : super(key: key);

  @override
  State<VolunteerSignup> createState() => _VolunteerSignupState();
}

class _VolunteerSignupState extends State<VolunteerSignup> {
  ///Controllers
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final dateinputController = TextEditingController();
  DateTime? pickedDate;
  final imageController = TextEditingController();
  XFile? pickedImage;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  ///Category Field
  var InterestsTiles = null;

  getCategoryField() {
    if (InterestsTiles == null)
      return SizedBox.shrink();
    else
      return InterestsTiles;
  }

  ///Skills Field
  var SkillsField = null;

  getSkillsField() {
    if (SkillsField == null)
      return SizedBox.shrink();
    else
      return SkillsField;
  }

  ///Clear all controllers
  void clearControllers() {
    fullNameController.clear();
    dateinputController.clear();
    imageController.clear();
    emailController.clear();
    passwordController.clear();
  }

  ///Function that adds the login info to Firebase Auth
  ///Displays flash card if failed for any reason
  addLoginInfo() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);

      flashBar.showBasicsFlashFailed(
          duration: Duration(seconds: 3), context: context, message: e.message);
    }
    return false;
  }

  ///Function that adds rest of the account info after adding the the account to auth
  Future createAccount() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (SkillsField.addedChips.length < 3) {
      flashBar.showBasicsFlashFailed(
          duration: Duration(seconds: 3),
          context: context,
          message: 'Please enter at least three skills');
      return;
    }
    if (InterestsTiles.added.length < 1) {
      flashBar.showBasicsFlashFailed(
          duration: Duration(seconds: 3),
          context: context,
          message: 'Please enter at least one interest');
      return;
    }

    if (await addLoginInfo()) {
      try {
        String? userReference = FirebaseAuth.instance.currentUser?.uid;
        userReference.toString();

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('${userReference}');
        Reference referenceImageToUpload =
            referenceDirImages.child('profile_photo');
        await referenceImageToUpload.putFile(File(pickedImage!.path));
        var imageUrl = await referenceImageToUpload.getDownloadURL();

        FirebaseFirestore usersCollection = FirebaseFirestore.instance;
        await usersCollection.collection('Users').doc(userReference!).set({
          'name': fullNameController.text.trim(),
          'type': 2,
          'interests': InterestsTiles.added,
          'dateOfBirth': Timestamp.fromDate(pickedDate!),
          'profilePhotoUrl': imageUrl,
          'skills': SkillsField.addedChips
        });
        await UpdateDictionary().updateSkills(SkillsField.addedChips);
        await FirebaseAuth.instance.signOut();
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                    passedEmail: emailController.text, newAccount: true)));

        clearControllers();
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Functions that fetch data from Dictionary after page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SkillsField == null) {
        await FirebaseFirestore.instance
            .collection('Dictionary')
            .doc('Skills')
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('Document data: ${documentSnapshot.data()}');
            SkillsField = TagsField(
              suggestionsList:
                  List<String>.from(documentSnapshot['skills'] as List),
              chipColor: Colors.blue,
              iconColor: Colors.white,
              textStyle: TextStyle(color: Colors.white),
            );
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
      if (InterestsTiles == null) {
        await FirebaseFirestore.instance
            .collection('Dictionary')
            .doc('Interests')
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('Document data: ${documentSnapshot.data()}');
            InterestsTiles = CheckboxTiles(
              tileValues:
                  List<String>.from(documentSnapshot['interests'] as List),
            );
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
    });

    ///Actual page
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          )),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  ///SIGN UP TEXT
                  Text(
                    'Sign up',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Create your account.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  ///FORM DATA
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        ///FULL NAME FORM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Full Name',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              obscureText: false,
                              controller: fullNameController,
                              autovalidateMode: AutovalidateMode.disabled,
                              validator: (value) =>
                                  value != null && value.length < 3
                                      ? 'Please enter your full name'
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),

                        ///PROFILE PHOTO FORM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Your profile photo',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              obscureText: false,
                              controller: imageController,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () {
                                ///Image picker
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  pickedImage =
                                      await imagePicker.imgPickDialog(context);
                                  imageController.text = pickedImage!.name;
                                });
                              },
                              validator: (value) =>
                                  value != null && value.isEmpty
                                      ? 'Please select a profile picture'
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),

                        ///ENTER DATE FORM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date of Birth',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              obscureText: false,
                              controller: dateinputController,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () async {
                                ///Entire date selection logic
                                ///Wanted to wrap in external func, too much hassle
                                ///Age limit can be edited here
                                pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now()
                                      .subtract(const Duration(days: 6575)),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 20075)),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime.now()
                                      .subtract(const Duration(days: 6575)),
                                );

                                ///Logic so controller displays the selected date
                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate!);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    dateinputController.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                              validator: (value) =>
                                  value != null && value.isEmpty
                                      ? 'Please enter your date of birth'
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),

                        ///CATEGORY
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Please select the category of jobs you would be interested in',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            getCategoryField(),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),

                        ///ENTER SKILLS FORM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Please enter your skills',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            getSkillsField(),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),

                        ///EMAIL FORM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              obscureText: false,
                              controller: emailController,
                              autovalidateMode: AutovalidateMode.disabled,
                              validator: (email) => email != null &&
                                      !EmailValidator.validate(email)
                                  ? 'Please enter a valid email'
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),

                        ///PASSWORD FORM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              autovalidateMode: AutovalidateMode.disabled,
                              validator: (value) =>
                                  value != null && value.length < 6
                                      ? 'Please enter at least 6 characters'
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),

                        ///CONFIRM PASSWORD
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Conifrm password',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: confirmPasswordController,
                              autovalidateMode: AutovalidateMode.disabled,
                              validator: (value) =>
                                  value != null && value.length < 6 ||
                                          value != passwordController.text
                                      ? 'Please make sure the passwords match'
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  ///SIGN UP BUTTON
                  Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Colors.blue.shade500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: createAccount),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
