
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _VATController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    // Set default values for text controllers
    _nameController.text = 'John Doe';
    _dobController.text = '01/01/1990';
    _infoController.text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
    _skillsController.text = 'Flutter, Dart, Mobile Development';
    _VATController.text = '111111111111111';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Edit Profile',style: TextStyle(color: Colors.white
        ),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: () {
                // TODO: Implement image picker
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
            ),

            SizedBox(height: 16.0),

            // Name
            Text('Name'),
            TextFormField(
              controller: _nameController,
              readOnly: !_isEditing,
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

            SizedBox(height: 16.0),

            // Date of Birth
            Text('Date of Birth'),
            TextFormField(
              controller: _dobController,
              readOnly: !_isEditing,
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

            SizedBox(height: 16.0),

            // Profile Info
            Text('Profile Info'),
            TextFormField(
              controller: _infoController,
              readOnly: !_isEditing,
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

            // Skills
            Text('Skills'),
            TextFormField(
              controller: _skillsController,
              readOnly: !_isEditing,
              decoration: InputDecoration(
                hintText: 'Enter your skills (comma-separated)',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Skills
            Text('VAT number'),
            TextFormField(
              controller: _VATController,
              readOnly: !_isEditing,
              decoration: InputDecoration(
                hintText: 'Enter your VAT number(15 digits)',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        child: Icon(_isEditing ? Icons.check : Icons.edit),
      ),
    );
  }
}