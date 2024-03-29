import 'package:flutter/material.dart';
import 'package:graduation_project/screens/dashboard.dart';
import 'package:graduation_project/widgets/dropdown_field.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/tag_field.dart';
import '../utilities/update_dictionary.dart';
import '../utilities/flash_bar.dart';

///Create a post form, accessed after pressing little plus on bottom of screen
///Requires userID so it can be passed to post details

class AdvertisementForm extends StatefulWidget {
  ///Relevant user data
  String? userID;
  String? userName;
  String? userProfilePhoto;

  AdvertisementForm(
      {Key? key,
      required this.userID,
      required this.userName,
      required this.userProfilePhoto})
      : super(key: key);

  @override
  State<AdvertisementForm> createState() => _AdvertisementFormState();
}

class _AdvertisementFormState extends State<AdvertisementForm> {
  ///Controllers for form fileds
  final formKey = GlobalKey<FormState>();
  final postTitleController = TextEditingController();
  final dueDateController = TextEditingController();
  DateTime? pickedDueDate;
  final startDateController = TextEditingController();
  DateTime? pickedStartDate = DateTime.now();
  final endDateController = TextEditingController();
  DateTime? pickedEndDate;
  final numberOfPeopleController = TextEditingController();
  final workDescriptionController = TextEditingController();
  final requirementsController = TextEditingController();
  final opportunitiesController = TextEditingController();

  ///Category Field and loader
  var CategoryField = null;

  getCategoryField() {
    if (CategoryField == null)
      return SizedBox.shrink();
    else
      return CategoryField;
  }

  ///Skills Field and loader
  var SkillsField = null;

  getSkillsField() {
    if (SkillsField == null)
      return SizedBox.shrink();
    else
      return SkillsField;
  }

  ///Clear all controllers
  void clearControllers() {
    postTitleController.clear();
    dueDateController.clear();
    startDateController.clear();
    endDateController.clear();
    numberOfPeopleController.clear();
    workDescriptionController.clear();
    requirementsController.clear();
    opportunitiesController.clear();
  }

  Future submitForm() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (SkillsField.addedChips.length < 3) {
      flashBar.showBasicsFlashFailed(
          duration: Duration(seconds: 3),
          context: context,
          message: 'Please enter at least three skills');
      return;
    }

    try {
      FirebaseFirestore usersCollection = FirebaseFirestore.instance;
      await usersCollection.collection('Posts').doc().set({
        'title': postTitleController.text.trim(),
        'category': [CategoryField.dropdownValue],
        'authorID': widget.userID,
        'authorName': widget.userName,
        'profilePhotoUrl': widget.userProfilePhoto,
        'applicationSubmitted': [],
        'acceptedApplicants':[],
        'dueDate': Timestamp.fromDate(pickedDueDate!),
        'startDate': Timestamp.fromDate(pickedStartDate!),
        'endDate': Timestamp.fromDate(pickedEndDate!),
        'applicants': numberOfPeopleController.text.trim(),
        'description': workDescriptionController.text.trim(),
        'requirements': SkillsField.addedChips,
        'opportunities': opportunitiesController.text.trim()
      });
      await UpdateDictionary().updateSkills(SkillsField.addedChips);
      clearControllers();
      await flashBar.showBasicsFlashSuccessful(
        duration: Duration(seconds: 5),
        context: context,
        message: 'Your post was created!',
      );
      setState(() {
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      print(e);
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
            SkillsField = TagsField(
                suggestionsList:
                    List<String>.from(documentSnapshot['skills'] as List));
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
      if (CategoryField == null) {
        await FirebaseFirestore.instance
            .collection('Dictionary')
            .doc('Interests')
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            CategoryField = DropdownField(
              options: List<String>.from(documentSnapshot['interests'] as List),
              textColor: Colors.black,
              fontSize: 16,
            );
            setState(() {});
          } else {
            print('Document does not exist on the database');
          }
        });
      }
    });

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(
          'Create your post!',
          style: TextStyle(
            color: Colors.blue.shade500,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/client.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all( color: Colors.blue.shade300),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(children: [
                ///POST TITLE FIELD
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Post Title:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: postTitleController,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) =>
                              value != null && value.length < 3
                                  ? 'Please enter a title \n'
                                  : null,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'Enter post title',
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ]),

                ///POST CATEGORY FIELD
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Post Category:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(flex: 3, child: getCategoryField())
                    ]),

                ///APPLICATION DEADLINE FIELD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Application deadline:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: dueDateController,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () async {
                          DateTime? possibleLastDate;
                          if (pickedEndDate != null) {
                            possibleLastDate = pickedEndDate;
                          } else
                            possibleLastDate =
                                DateTime.now().add(const Duration(days: 730));

                          pickedDueDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate:
                                  DateTime.parse(possibleLastDate.toString()));

                          if (pickedDueDate != null) {
                            print(
                                pickedDueDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDueDate!);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dueDateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                        validator: (value) => value != null && value.isEmpty
                            ? 'Please enter an application deadline'
                            : null,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Enter application deadline',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                ///JOB START DATE FIELD
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Job start date:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: startDateController,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () async {
                          DateTime? possibleLastDate;
                          if (pickedEndDate != null) {
                            possibleLastDate = pickedEndDate;
                          } else
                            possibleLastDate =
                                DateTime.now().add(const Duration(days: 730));

                          pickedStartDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate:
                                  DateTime.parse(possibleLastDate.toString()));

                          if (pickedStartDate != null) {
                            print(
                                pickedStartDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = DateFormat('yyyy-MM-dd')
                                .format(pickedStartDate!);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              startDateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            pickedStartDate = DateTime.now();
                            print("Date is not selected");
                          }
                        },
                        validator: (value) => value != null && value.isEmpty
                            ? 'Please enter a job start date'
                            : null,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Enter job start date',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                ///JOB END DATE FIELD
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Job end date:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: endDateController,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () async {
                          DateTime? possibleStartDate;
                          DateTime? initialDate;
                          if (pickedDueDate != null) {
                            if (pickedDueDate!.isAfter(pickedStartDate!)) {
                              possibleStartDate = pickedDueDate;
                              initialDate = pickedDueDate;
                            } else {
                              possibleStartDate = pickedStartDate;
                              initialDate = pickedStartDate;
                            }
                          } else {
                            possibleStartDate = DateTime.now();
                            initialDate = DateTime.now();
                          }

                          pickedEndDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.parse(initialDate.toString())
                                      .add(const Duration(days: 1)),
                              firstDate:
                                  DateTime.parse(possibleStartDate.toString())
                                      .add(const Duration(days: 1)),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate:
                                  DateTime.parse(pickedStartDate.toString())
                                      .add(const Duration(days: 730)));

                          if (pickedEndDate != null) {
                            print(
                                pickedEndDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedEndDate!);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              endDateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                        validator: (value) => value != null && value.isEmpty
                            ? 'Please enter a job end date'
                            : null,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Enter job end date',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                ///NUMBER OF APPLICANTS FIELD
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Accepted applicants:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numberOfPeopleController,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) =>
                              value == null || value == '' || value == '0'
                                  ? 'Invalid number of applicants'
                                  : null,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'How many will be accepted',
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ]),

                ///WORK DESCRIPTION FILED
                SizedBox(height: 10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Work description:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: TextFormField(
                            controller: workDescriptionController,
                            autovalidateMode: AutovalidateMode.disabled,
                            validator: (value) =>
                                value != null && value.length < 10
                                    ? 'Please enter a long description \n'
                                    : null,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintText: 'Enter work description',
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),

                ///REQUIREMENTS FIELD
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Requirements:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: getSkillsField(),
                        ),
                      )
                    ]),

                ///OPPORTUNITIES FIELD
                SizedBox(height: 10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Opportunities:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: TextFormField(
                            validator: (value) =>
                                value != null && value.length < 3
                                    ? 'Please enter opportunities'
                                    : null,
                            controller: opportunitiesController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintText: 'Enter opportunities',
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              ]),
            ),
          ),
        SizedBox(height: 10),
          MaterialButton(
              minWidth: MediaQuery.of(context).size.width-20,
              height: 60,
              color: Colors.blue.shade500,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                'Create post',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: submitForm),
        SizedBox(height: 10,)],
        ),

      ),
    ),
    );
  }
}
