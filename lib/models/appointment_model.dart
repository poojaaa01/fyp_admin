import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String docTitle;
  final String imageUrl;
  final String bookDate;
  final int price;
  final String username;

  Appointment({
    required this.docTitle,
    required this.imageUrl,
    required this.bookDate,
    required this.price,
    required this.username,
  });

  factory Appointment.fromFirestore(Map<String, dynamic> data) {
    final Timestamp? timestamp = data['bookDate'];
    final String formattedDate = timestamp != null
        ? DateFormat('MMM dd, yyyy – hh:mm a').format(timestamp.toDate())
        : 'Unknown Date';

    return Appointment(
      docTitle: data['docTitle'] ?? 'Unknown Doctor',
      imageUrl: data['imageUrl'] ?? '',
      bookDate: formattedDate,
      price: (data['price'] as num?)?.toInt() ?? 0, // ✅ Fix here
      username: data['username'] ?? 'Unknown User',
    );
  }
}
