import 'package:flutter/material.dart';
import 'package:graduation_project/screens/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/dropdown_field.dart';
import '../utilities/flash_bar.dart';
import '../widgets/tag_field.dart';
import '../utilities/update_dictionary.dart';

///Create a post form, accessed after pressing little plus on bottom of screen
///Requires userID so it can be passed to post details

class updateAdvertisementForm extends StatefulWidget {
  ///Relevant user data
  Map<String, dynamic> data;

  updateAdvertisementForm({Key? key, required this.data}) : super(key: key);

  @override
  State<updateAdvertisementForm> createState() =>
      _updateAdvertisementFormState();
}

class _updateAdvertisementFormState extends State<updateAdvertisementForm> {
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
  final opportunitiesController = TextEditingController();

  ///Category Field
  var CategoryField = null;

  getCategoryField() {
    if (CategoryField == null)
      return SizedBox.shrink();
    else
      return CategoryField;
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
    postTitleController.clear();
    dueDateController.clear();
    startDateController.clear();
    endDateController.clear();
    numberOfPeopleController.clear();
    workDescriptionController.clear();
    opportunitiesController.clear();
  }

  Future updateForm() async {
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
      await usersCollection
          .collection('Posts')
          .doc(widget.data['postID'])
          .update({
        'title': postTitleController.text.trim(),
        'category': [CategoryField.dropdownValue],
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
        message: 'Your post was updated!',
      );
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      await flashBar.showBasicsFlashFailed(
        duration: Duration(seconds: 5),
        context: context,
        message: e.message,
      );
    }
  }

  var toggle = false;

  @override
  Widget build(BuildContext context) {
    ///There is a good reason on why I didn't use init state here
    ///but 4 weeks later, I cannot truly remember it.
    if (!toggle) {
      postTitleController.text = widget.data['title'];
      pickedDueDate = DateTime.fromMillisecondsSinceEpoch(
          widget.data['dueDate'].seconds * 1000);
      dueDateController.text = DateFormat('yyyy-MM-dd').format(pickedDueDate!);

      pickedStartDate = DateTime.fromMillisecondsSinceEpoch(
          widget.data['startDate'].seconds * 1000);
      ;
      startDateController.text =
          DateFormat('yyyy-MM-dd').format(pickedStartDate!);

      pickedEndDate = DateTime.fromMillisecondsSinceEpoch(
          widget.data['endDate'].seconds * 1000);
      endDateController.text = DateFormat('yyyy-MM-dd').format(pickedEndDate!);

      numberOfPeopleController.text = widget.data['applicants'];
      workDescriptionController.text = widget.data['description'];
      opportunitiesController.text = widget.data['opportunities'];
      toggle = true;
    }

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
                    List<String>.from(documentSnapshot['skills'] as List));
            SkillsField.addedChips =
                List<String>.from(widget.data['requirements'] as List);
            for (var i = 0;
                i <
                    List<String>.from(widget.data['requirements'] as List)
                        .length;
                i++) {
              print(widget.data['requirements'][i]);
              SkillsField.chipDataList.add(
                ChipObjectData(widget.data['requirements'][i]),
              );
            }
            for (var i = 0;
                i <
                    List<String>.from(widget.data['requirements'] as List)
                        .length;
                i++) {
              print(widget.data['requirements'][i]);
              if (SkillsField.suggestionsList
                  .contains(widget.data['requirements'][i]))
                SkillsField.suggestionsList
                    .remove(widget.data['requirements'][i]);
            }
            print(SkillsField.suggestionsList);
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
            print('Document data: ${documentSnapshot.data()}');
            CategoryField = DropdownField(
              options: List<String>.from(documentSnapshot['interests'] as List),
              textColor: Colors.white,
              dropdownColor: Colors.red.shade400,
              fontSize: 16,
              dropdownValue: widget.data['category'][0],
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
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              'Currently editing:',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            Text(
              '${widget.data['title']}',
              style: TextStyle(
                color: Colors.red,
              ),
            )
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
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
                image: NetworkImage(widget.data['profilePhotoUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
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
                            color: Colors.white,
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
                              color: Colors.white,
                            ),
                            hintText: 'Enter post title',
                            hintStyle: TextStyle(
                              color: Colors.white,
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
                            color: Colors.white,
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
                            color: Colors.white,
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
                          color: Colors.white,
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
                            color: Colors.white,
                          ),
                          hintText: 'Enter application deadline',
                          hintStyle: TextStyle(
                            color: Colors.white,
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
                          color: Colors.white,
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
                          color: Colors.white,
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
                            color: Colors.white,
                          ),
                          hintText: 'Enter job start date',
                          hintStyle: TextStyle(
                            color: Colors.white,
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
                          color: Colors.white,
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
                          color: Colors.white,
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
                            color: Colors.white,
                          ),
                          hintText: 'Enter job end date',
                          hintStyle: TextStyle(
                            color: Colors.white,
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
                          color: Colors.white,
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
                            color: Colors.white,
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
                              color: Colors.white,
                            ),
                            hintText: 'How many will be accepted',
                            hintStyle: TextStyle(
                              color: Colors.white,
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),

                ///WORK DESCRIPTION FILED
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Work description:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: 'Enter work description',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
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
                            color: Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Opportunities:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: 'Enter opportunities',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
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
              height: 60,
              color: Colors.red.shade400,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                'Edit post',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: updateForm),
          SizedBox(height: 10,)
        ]),
      ),



    ));
  }
}
