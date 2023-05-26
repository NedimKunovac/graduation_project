import 'dart:io';

import 'package:flutter/material.dart';
import '../utilities/image_picker_custom.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/tag_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../widgets/checkbox_tiles.dart';
import '../utilities/flash_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utilities/update_dictionary.dart';

///Edit profile page, pretty self explanatory

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key, required this.data}) : super(key: key);

  ///Input data map that contains user data
  Map<String, dynamic> data;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ///Controllers, form-key, image and date inputs
  TextEditingController _nameController = TextEditingController();
  TextEditingController _repController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  TextEditingController _VATController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  XFile? pickedImage;
  DateTime? pickedDate;

  ///Skills Field and loader
  var SkillsField = null;

  getSkillsField() {
    if (SkillsField == null)
      return SizedBox.shrink();
    else
      return SkillsField;
  }

  ///Category Field and loader
  var InterestsTiles = null;

  getCategoryField() {
    if (InterestsTiles == null)
      return SizedBox.shrink();
    else
      return InterestsTiles;
  }

  ///Function that passes changed user data to firebase
  Future updateData() async {
    ///Check if form is valid
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (widget.data['type'] == 2) {
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
    }

    ///Pass logic different based on user type
    if (widget.data['type'] == 1) {
      try {
        var imageUrl = null;
        String userReference = widget.data['userID'];

        ///Firebase Storage
        if (pickedImage != null) {
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages =
              referenceRoot.child('${userReference}');
          Reference referenceImageToUpload =
              referenceDirImages.child('profile_photo');
          await referenceImageToUpload.putFile(File(pickedImage!.path));
          imageUrl = await referenceImageToUpload.getDownloadURL();
        }

        ///Firestore
        FirebaseFirestore usersCollection = FirebaseFirestore.instance;
        await usersCollection.collection('Users').doc(userReference!).update({
          'name': _nameController.text.trim(),
          'rep': _repController.text.trim(),
          'profileInfo': _infoController.text.trim(),
          'profilePhotoUrl':
              imageUrl != null ? imageUrl : widget.data['profilePhotoUrl'],
          'vatNum': _VATController.text.trim()
        });
        flashBar.showBasicsFlashSuccessful(
            duration: Duration(seconds: 3), context: context, message: 'You have updated your profile! Please restart the app to see your changes');

        Navigator.pop(context);
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      try {
        var imageUrl = null;
        String userReference = widget.data['userID'];

        ///Firebase Storage
        if (pickedImage != null) {
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages =
              referenceRoot.child('${userReference}');
          Reference referenceImageToUpload =
              referenceDirImages.child('profile_photo');
          await referenceImageToUpload.putFile(File(pickedImage!.path));
          imageUrl = await referenceImageToUpload.getDownloadURL();
        }

        ///Firestore
        FirebaseFirestore usersCollection = FirebaseFirestore.instance;
        await usersCollection.collection('Users').doc(userReference!).update({
          'name': _nameController.text.trim(),
          'interests': InterestsTiles.added,
          'profileInfo': _infoController.text.trim(),
          'dateOfBirth': pickedDate != null
              ? Timestamp.fromDate(pickedDate!)
              : widget.data['dateOfBirth'],
          'profilePhotoUrl':
              imageUrl != null ? imageUrl : widget.data['profilePhotoUrl'],
          'skills': SkillsField.addedChips
        });
        await UpdateDictionary().updateSkills(SkillsField.addedChips);
        flashBar.showBasicsFlashSuccessful(
            duration: Duration(seconds: 3), context: context, message: 'You have updated your profile! Please restart the app to see your changes');
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  ///Init state so inputted values get passed to controllers
  @override
  void initState() {
    super.initState();
    // Set default values for text controllers
    _nameController.text = widget.data['name'];
    _repController.text = widget.data['rep'] != null ? widget.data['rep'] : '';
    _dobController.text = widget.data['dateOfBirth'] != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(
            widget.data['dateOfBirth'].seconds * 1000))
        : '';
    _infoController.text =
        widget.data['profileInfo'] != null ? widget.data['profileInfo'] : '';
    _VATController.text =
        widget.data['vatNum'] != null ? widget.data['vatNum'] : '';
  }

  @override
  Widget build(BuildContext context) {
    ///Functions that fetch data from Dictionary after page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SkillsField == null && widget.data['type'] == 2) {
        await FirebaseFirestore.instance
            .collection('Dictionary')
            .doc('Skills')
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
           // print('Document data: ${documentSnapshot.data()}');
            SkillsField = TagsField(
                suggestionsList:
                    List<String>.from(documentSnapshot['skills'] as List));
            SkillsField.addedChips =
                List<String>.from(widget.data['skills'] as List);
            for (var i = 0;
                i < List<String>.from(widget.data['skills'] as List).length;
                i++) {
             // print(widget.data['skills'][i]);
              SkillsField.chipDataList.add(
                ChipObjectData(widget.data['skills'][i]),
              );
            }
            for (var i = 0;
                i < List<String>.from(widget.data['skills'] as List).length;
                i++) {
             // print(widget.data['skills'][i]);
              if (SkillsField.suggestionsList
                  .contains(widget.data['skills'][i]))
                SkillsField.suggestionsList.remove(widget.data['skills'][i]);
            }
           // print(SkillsField.suggestionsList);
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
      if (InterestsTiles == null && widget.data['type'] == 2) {
        await FirebaseFirestore.instance
            .collection('Dictionary')
            .doc('Interests')
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
           // print('Document data: ${documentSnapshot.data()}');
            InterestsTiles = CheckboxTiles(
              tileValues:
                  List<String>.from(documentSnapshot['interests'] as List),
            );
            InterestsTiles.added =
                List<String>.from(widget.data['interests'] as List);
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile Picture
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
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
              ),

              SizedBox(height: 16.0),

              /// Name
              widget.data['type'] == 1 ? Text('Company Name') : Text('Name'),
              TextFormField(
                obscureText: false,
                controller: _nameController,
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) => value != null && value.length < 3
                    ? widget.data['type'] == 1
                        ? 'Please enter your company name'
                        : 'Please enter your full name'
                    : null,
                decoration: InputDecoration(
                  hintText: widget.data['type'] == 1
                      ? 'Enter your company name'
                      : 'Enter your full name',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),

              /// Representative
              widget.data['rep'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.0),
                        Text('Representative'),
                        TextFormField(
                          obscureText: false,
                          controller: _repController,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) =>
                              value != null && value.length < 3
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
                      ],
                    )
                  : SizedBox.shrink(),

              /// Date of Birth field
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

              /// Profile Info
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

              ///VAT Number Field
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

              /// Skills Field
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

              ///Skills Field
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
        backgroundColor: Colors.blue.shade500,
        onPressed: () {
          updateData();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
