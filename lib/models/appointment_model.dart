import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String bookId;
  final String docTitle;
  final String imageUrl;
  final Timestamp bookDate;
  final int price;
  final String userName;
  final String userEmail;

  Appointment({
    required this.bookId,
    required this.docTitle,
    required this.imageUrl,
    required this.bookDate,
    required this.price,
    required this.userName,
    required this.userEmail,
  });

  factory Appointment.fromFirestore(Map<String, dynamic> data) {
    return Appointment(
      bookId: data['bookId'] ?? '',
      docTitle: data['docTitle'] ?? 'Unknown Doctor',
      imageUrl: data['imageUrl'] ?? '',
      bookDate: data['bookDate'] ?? Timestamp.now(),
      price: (data['price'] as num?)?.toInt() ?? 0,
      userName: data['userName'] ?? 'Unknown User',
      userEmail: data['userEmail'] ?? '',
    );
  }

  String get formattedDate =>
      DateFormat('MMM dd, yyyy – hh:mm a').format(bookDate.toDate());
}
