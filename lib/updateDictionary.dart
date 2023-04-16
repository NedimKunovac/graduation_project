import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class updateDictionary {


  updateSkills(List<String> skills) async {
    await FirebaseFirestore.instance.collection('Dictionary').doc('Skills').update({
      'skills': FieldValue.arrayUnion(skills)
    });
  }

  updateInterests(List<String> interests) async {
    await FirebaseFirestore.instance.collection('Dictionary').doc('Interests').update({
      'interests': FieldValue.arrayUnion(interests)
    });
  }
}
