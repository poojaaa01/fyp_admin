import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String appointmentId;
  final String bookId;
  final String docTitle;
  final String imageUrl;
  final Timestamp bookDate;
  final int price;
  final String userName;
  final String userEmail;
  final bool? confirmed;

  Appointment({
    required this.appointmentId,
    required this.bookId,
    required this.docTitle,
    required this.imageUrl,
    required this.bookDate,
    required this.price,
    required this.userName,
    required this.userEmail,
    this.confirmed,
  });

  factory Appointment.fromFirestore(String id, Map<String, dynamic> data) {
    return Appointment(
      appointmentId: id,
      bookId: data['bookId'] ?? '',
      docTitle: data['docTitle'] ?? 'Unknown Doctor',
      imageUrl: data['imageUrl'] ?? '',
      bookDate: data['bookDate'] ?? Timestamp.now(),
      price: (data['price'] as num?)?.toInt() ?? 0,
      userName: data['userName'] ?? 'Unknown User',
      userEmail: data['userEmail'] ?? '',
      confirmed: data['confirmed'] ?? false,
    );
  }

  String get formattedDate =>
      DateFormat('yyyy-MM-dd').format(bookDate.toDate());
}
