import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorType with ChangeNotifier{
  final String docId,
      docTitle,
      docPrice,
      docCategory,
      docDescription,
      docImage,
      docQuantity;
  Timestamp? createdAt;
  DoctorType({
    required this.docId,
    required this.docTitle,
    required this.docPrice,
    required this.docCategory,
    required this.docDescription,
    required this.docImage,
    required this.docQuantity,
    this.createdAt
  });
}
