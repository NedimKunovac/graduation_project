import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/flash_bar.dart';
import 'package:graduation_project/widgets/tag_field.dart';
import 'package:intl/intl.dart';

class TaskFormPage extends StatefulWidget {
  TaskFormPage({Key? key, required this.postID, this.data, this.taskID}) : super(key: key);

  String? postID;
  String? taskID;
  Map<dynamic, dynamic>? data;

  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? pickedDate;
  final timeController = TextEditingController();
  TimeOfDay? pickedTime = TimeOfDay(hour:00,minute: 00);
  final _durationController = TextEditingController();

  final List<String> volunteerNames = <String>[];
  final List<String> volunteerIDs = <String>[];

  final List<String> preAddedIDs = <String>[];

  bool toggle = false;


  updateForm() async {
    if(PeopleField.addedChips.length<=0){
      flashBar.showBasicsFlashFailed(
          duration: Duration(seconds: 3),
          context: context,
          message: 'Please enter at least one volunteer');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    List <String> addedPeopleIDs = <String>[];
    for(int i=0; i<PeopleField.addedChips.length; i++){
      addedPeopleIDs.add(volunteerIDs[volunteerNames.indexOf(PeopleField.addedChips[i])]);
    }

    print(_titleController.text);
    print(_descriptionController.text);
    print(Timestamp.fromDate(pickedDate!).toString());
    print(timeController.text);
    print(_durationController.text);
    print(PeopleField.addedChips.toString());
    print(addedPeopleIDs.toString());

    try {
      FirebaseFirestore usersCollection = FirebaseFirestore.instance;
      await usersCollection.collection('Posts').doc(widget.postID).collection('Tasks').doc(widget.taskID).update({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': Timestamp.fromDate(pickedDate!),
        'time': timeController.text.trim(),
        'duration': _durationController.text.trim(),
        'workers': addedPeopleIDs
      });
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

  submitForm() async {
    if(PeopleField.addedChips.length<=0){
      flashBar.showBasicsFlashFailed(
          duration: Duration(seconds: 3),
          context: context,
          message: 'Please enter at least one volunteer');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    List <String> addedPeopleIDs = <String>[];
    for(int i=0; i<PeopleField.addedChips.length; i++){
      addedPeopleIDs.add(volunteerIDs[volunteerNames.indexOf(PeopleField.addedChips[i])]);

    }

    try {
      FirebaseFirestore usersCollection = FirebaseFirestore.instance;
      await usersCollection.collection('Posts').doc(widget.postID).collection('Tasks').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': Timestamp.fromDate(pickedDate!),
        'time': timeController.text.trim(),
        'duration': _durationController.text.trim(),
        'workers': addedPeopleIDs
      });
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


  ///Skills Field
  var PeopleField = null;

  getPeopleField() {
    if (PeopleField == null)
      return SizedBox.shrink();
    else
      return PeopleField;
  }


  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (PeopleField == null) {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postID)
            .get()
            .then((DocumentSnapshot documentFirstSnapshot) async {
          if (documentFirstSnapshot.exists) {
            for (int i = 0;
                i < documentFirstSnapshot['acceptedApplicants'].length;
                i++) {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(documentFirstSnapshot['acceptedApplicants'][i])
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  volunteerNames.add(documentSnapshot['name'].toString());
                  volunteerIDs.add(documentSnapshot.id.toString());

                } else {
                  print('Document does not exist on the database');
                }
              });
            }

            List<String> addedPeople = <String>[];
            List<ChipObjectData> chipDataList = <ChipObjectData>[];

            if(widget.data!=null){
              toggle = true;
              for (var i = 0; i < (widget.data!['workers'] as List).map((item) => item as String).toList().length; i++) {
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.data!['workers'][i])
                    .get()
                    .then((DocumentSnapshot documentThirdSnapshot) {
                  if (documentThirdSnapshot.exists) {
                    addedPeople.add(documentThirdSnapshot['name'].toString());
                    chipDataList.add(ChipObjectData(documentThirdSnapshot['name'].toString()));
                  } else {
                    print('Document does not exist on the database');
                  }
                });
            }
              print(addedPeople.toString());
             // PeopleField.addedChips = List.from(addedPeople);
            }


            if(addedPeople.length!=0){
              List <String> VolunteerNamesCopy = List.from(volunteerNames);

              for(int i=0; i<addedPeople.length; i++)
                if(VolunteerNamesCopy.contains(addedPeople[i]))
                  VolunteerNamesCopy.remove(addedPeople[i]);

              List<String> copyList = List.from(VolunteerNamesCopy);
              PeopleField =
                  TagsField(suggestionsList: copyList, plusIcon: false);
              PeopleField.addedChips = List<String>.from(addedPeople);
              PeopleField.chipDataList = List<ChipObjectData>.from(chipDataList);
            } else {
              List<String> copyList = List.from(volunteerNames);
              PeopleField =
                  TagsField(suggestionsList: copyList, plusIcon: false);
            }


            setState(() {
              widget.data=null;
            });
          } else {
            print('Document does not exist on the database');
          }
        });
      }
    });


    if(widget.data!=null){
      _titleController.text=widget.data!['title'];
      _descriptionController.text=widget.data!['description'];
      dateController.text = DateFormat.yMMMMd('en_US')
          .format(widget.data!['date'].toDate())
          .toString();
      pickedDate = widget.data!['date'].toDate();
      timeController.text = widget.data!['time'];
      pickedTime = TimeOfDay(hour:int.parse(widget.data!['time'].split(":")[0]),minute: int.parse(widget.data!['time'].split(":")[1]));
      _durationController.text = widget.data!['duration'];
    }

    return PeopleField==null ? Scaffold(
      body: Center(
        child: Text('Loading'),
      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          toggle ? 'Edit task' : 'Add task',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Enter the title of the task',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Enter the description of the task',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () async {
                    DateTime? possibleLastDate =
                    DateTime.now().add(const Duration(days: 365));

                    pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate:
                        DateTime.parse(possibleLastDate.toString()));

                    if (pickedDate != null) {
                      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat.yMMMMd('en_US')
                          .format(pickedDate!)
                          .toString();
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      pickedDate = DateTime.now();
                      print("Date is not selected");
                    }
                  },
                  validator: (value) => value != null && value.isEmpty
                      ? 'Please enter a job start date'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Enter a job start date',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: timeController,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () async {

                    pickedTime = await showTimePicker(context: context, initialTime: pickedTime!);


                    if (pickedTime != null) {

                      setState(() {
                        timeController.text =
                        '${pickedTime!.hour}:${pickedTime!.minute}'; //set output date to TextField value.
                      });
                    } else {
                      pickedDate = DateTime.now();
                      print("Date is not selected");
                    }
                  },
                  validator: (value) => value != null && value.isEmpty
                      ? 'Please enter a job start time'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Enter a job start time',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter the duration in minutes',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter a duration in minutes';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('Enter the volunteers the task will be assigned to'),
                getPeopleField(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(

                      onPressed: () {
                        toggle ? updateForm() : submitForm();
                      },
                      child: Container(child: Align(child: Text(toggle ? 'Update' : 'Submit'), alignment: Alignment.center,),
                      width: MediaQuery.of(context).size.width-70,),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
