import 'package:flutter/material.dart';

class AppConstants {
  static const String imageUrl =
      'https://www.shutterstock.com/image-vector/male-doctor-smiling-happy-face-600nw-2481032615.jpg';

  static List<String> startList = [
    'Mood Tracker',
    'Focus Mode',
    'Community',
    'Calm',
  ];

  static List<String> categoriesList = [
    'Psychiatrist',
    'Therapist',
    'Counselor'
    'Clinical Psychologist',
    'Mental Health Counselor',
    'Behavioral Therapist',
    'Child & Adolescent Psychiatrist',
    'Marriage & Family Therapist',
    'Addiction Counselor',
    'Neuropsychologist',
    'Trauma Specialist',
    'Rehabilitation Psychologist',
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
          categoriesList.length,
          (index) => DropdownMenuItem(
            value: categoriesList[index],
              child: Text(categoriesList[index]),
          ),
        );
    return menuItem;
  }
}
