import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static Future<void> sendAppointmentConfirmation({
    required String userEmail,
    required String userName,
    required String doctorName,
    required String date,
    required String time,
    required String meetLink,
    required String price,
    required String qrCodeUrl,
  }) async {
    const serviceId = 'service_3xxfmfc';
    const templateId = 'template_cgv0xho';
    const userPublicKey = 'pvaSv4wr7bNX559Ed';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost', // or your domain if hosted
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userPublicKey,
        'template_params': {
          'user_email': userEmail,
          'user_name': userName,
          'doctor_name': doctorName,
          'date': date,
          'time': time,
          'meet_link': meetLink,
          'price': price,
          'qr_code_url': qrCodeUrl,
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email: ${response.body}');
    }
  }
}
