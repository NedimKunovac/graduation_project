import 'package:flutter/material.dart';

class TaskFormPage extends StatefulWidget {
  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  final _slotController = TextEditingController();
  final _usersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Add Task',
          style:TextStyle(
              color: Colors.black
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(

                    labelText: 'Enter the title of the task',
                    border: OutlineInputBorder(
                    ),
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
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Enter time for the start of the task',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _slotController,
                  decoration: InputDecoration(
                    labelText: 'Enter the time-slot for the task',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter a slot';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _usersController,
                  decoration: InputDecoration(
                    labelText: 'Enter Volunteers responsible for the task',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter the users responsible';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(


                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save the form data here
                          // You can access the field values using the TextEditingController instances
                          Navigator.pop(context);
                        }
                      },



                      child: Text('Submit'),
                    ),
                  ],/*ElevatedButton(

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the form data here
                      // You can access the field values using the TextEditingController instances
                      Navigator.pop(context);
                    }
                  },



                    child: Text('Submit'),
                  ),*/
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
