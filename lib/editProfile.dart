import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_project/imagePicker.dart';
import 'package:image_picker/image_picker.dart';
import 'tagField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'checkboxTiles.dart';
import 'flashBar.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key, required this.data}) : super(key: key);

  Map<String, dynamic> data;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  TextEditingController _VATController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  XFile? pickedImage;

  DateTime? pickedDate;

  ///Skills Field
  var SkillsField = null;

  getSkillsField() {
    if (SkillsField == null)
      return SizedBox.shrink();
    else
      return SkillsField;
  }

  ///Category Field
  var InterestsTiles = null;

  getCategoryField() {
    if (InterestsTiles == null)
      return SizedBox.shrink();
    else
      return InterestsTiles;
  }


  Future updateData() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if(widget.data['type']==2){
      if (SkillsField.addedChips.length < 3) {
        flashBar.showBasicsFlashFailed(
            duration: Duration(seconds: 3),
            context: context,
            message: 'Please enter at least three skills');
        return;
      }
      if (InterestsTiles.added.length < 1){
        flashBar.showBasicsFlashFailed(
            duration: Duration(seconds: 3),
            context: context,
            message: 'Please enter at least one interest');
        return;
      }
    }


    // try {
    //   String? userReference = FirebaseAuth.instance.currentUser?.uid;
    //   userReference.toString();
    //
    //   Reference referenceRoot = FirebaseStorage.instance.ref();
    //   Reference referenceDirImages = referenceRoot.child('${userReference}');
    //   Reference referenceImageToUpload =
    //   referenceDirImages.child('profile_photo');
    //   await referenceImageToUpload.putFile(File(pickedImage!.path));
    //   var imageUrl = await referenceImageToUpload.getDownloadURL();
    //
    //   FirebaseFirestore usersCollection = FirebaseFirestore.instance;
    //   await usersCollection.collection('Users').doc(userReference!).set({
    //     'name': fullNameController.text.trim(),
    //     'type': 2,
    //     'interests': InterestsTiles.added,
    //     'dateOfBirth': Timestamp.fromDate(pickedDate!),
    //     'profilePhotoUrl': imageUrl,
    //     'skills': SkillsField.addedChips
    //   });
    //   await updateDictionary().updateSkills(SkillsField.addedChips);
    //   await FirebaseAuth.instance.signOut();
    //   await Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => LoginPage(
    //               passedEmail: emailController.text, newAccount: true)));
    //
    // } on FirebaseException catch (e) {
    //   print(e);
    // }

  }

  @override
  void initState() {
    super.initState();
    // Set default values for text controllers
    _nameController.text = widget.data['name'];
    _dobController.text = widget.data['dateOfBirth']!=null ? DateFormat('yyyy-mm-dd').format(DateTime.fromMillisecondsSinceEpoch(
        widget.data['dateOfBirth'].seconds * 1000)) : '';
    _infoController.text =
        widget.data['description'] != null ? widget.data['description'] : '';
    _VATController.text =
        widget.data['vatNum'] != null ? widget.data['vatNum'] : '';
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SkillsField == null && widget.data['type']==2) {
        await FirebaseFirestore.instance
            .collection('Dictionary')
            .doc('Skills')
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('Document data: ${documentSnapshot.data()}');
            SkillsField = TagsField(
                suggestionsList:
                    List<String>.from(documentSnapshot['skills'] as List));
            SkillsField.addedChips =
                List<String>.from(widget.data['skills'] as List);
            for (var i = 0;
                i < List<String>.from(widget.data['skills'] as List).length;
                i++) {
              print(widget.data['skills'][i]);
              SkillsField.chipDataList.add(
                ChipObjectData(widget.data['skills'][i]),
              );
            }
            for (var i = 0;
                i < List<String>.from(widget.data['skills'] as List).length;
                i++) {
              print(widget.data['skills'][i]);
              if (SkillsField.suggestionsList
                  .contains(widget.data['skills'][i]))
                SkillsField.suggestionsList.remove(widget.data['skills'][i]);
            }
            print(SkillsField.suggestionsList);
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
      if (InterestsTiles == null && widget.data['type']==2) {
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
            InterestsTiles.added = List<String>.from(widget.data['interests'] as List);
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () async {
                  pickedImage = await imagePicker.imgPickDialog(context);
                  setState(() {});
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                    radius: 60,
                    backgroundImage: pickedImage == null
                        ? NetworkImage(widget.data['profilePhotoUrl'])
                        : Image.file(File(pickedImage!.path)).image),
              ),

              SizedBox(height: 16.0),

              // Name
              Text('Name'),
              TextFormField(
                obscureText: false,
                controller: _nameController,
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) => value != null && value.length < 3
                    ? 'Please enter your full name'
                    : null,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),

              widget.data['dateOfBirth'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.0),
                        // Date of Birth
                        Text('Date of Birth'),
                        TextFormField(
                          obscureText: false,
                          controller: _dobController,
                          readOnly: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  DateFormat('yyyy-MM-dd').format(pickedDate!);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                _dobController.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your date of birth',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),

              SizedBox(height: 16.0),

              // Profile Info
              Text('Profile Info'),
              TextFormField(
                controller: _infoController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),

              SizedBox(height: 16.0),

              widget.data['vatNum'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VAT number'),
                        TextFormField(
                          obscureText: false,
                          controller: _VATController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) => value != null &&
                              value.length != 12
                              ? 'Please enter a proper VAT Number \nA VAT Number contains 12 numbers'
                              : null,
                          decoration: InputDecoration(
                            hintText: 'Enter your VAT number (12 digits)',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),

              widget.data['skills'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.0),
                        Text('Your skills'),
                        getSkillsField(),
                      ],
                    )
                  : SizedBox.shrink(),

              widget.data['interests'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.0),
                        Text('Your interests'),
                        getCategoryField(),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          print('You pressed me!');
          updateData();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
