import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:graduation_project/utilities/flash_bar.dart';

class ReportIssue extends StatefulWidget {
  const ReportIssue({Key? key}) : super(key: key);

  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  submitIssue(){
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    final firebase = FirebaseFirestore.instance.collection('Issues');
    firebase.add({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim()
    });
    flashBar.showBasicsFlashSuccessful(
        duration: Duration(seconds: 3), context: context, message: 'Your issue was reported!'
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Report an issue'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          maxLines: null,
                          controller: titleController,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) =>
                          value != null && value.length < 3
                              ? 'Please enter a title'
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Issue Title',
                            icon: Icon(Icons.label_important_outline),
                          ),
                        ),
                        TextFormField(
                          maxLines: null,
                          controller: descriptionController,
                          validator: (value) =>
                          value != null && value.length < 3
                              ? 'Please enter a description'
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Issue Description',
                            icon: Icon(Icons.email),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () => submitIssue()),
                  TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );

  }
}
