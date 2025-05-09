import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/appointment_model.dart';
import '../../../services/email_service.dart';

class ConfirmAppointmentScreen extends StatefulWidget {
  final Appointment appointment;

  const ConfirmAppointmentScreen({super.key, required this.appointment});

  @override
  State<ConfirmAppointmentScreen> createState() => _ConfirmAppointmentScreenState();
}

class _ConfirmAppointmentScreenState extends State<ConfirmAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _meetLinkController = TextEditingController();

  bool _isLoading = false;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  void _confirmAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await EmailService.sendAppointmentConfirmation(
        userEmail: widget.appointment.userEmail,
        userName: widget.appointment.userName,
        doctorName: widget.appointment.docTitle,
        date: _dateController.text.trim(),
        time: _timeController.text.trim(),
        meetLink: _meetLinkController.text.trim(),
        price: widget.appointment.price.toString(),
        qrCodeUrl: 'https://firebasestorage.googleapis.com/v0/b/moksha-313b0.firebasestorage.app/o/IMG_4123.jpeg?alt=media&token=f2921f90-9ef6-4b88-9f74-8be55816a715',
      );

      await FirebaseFirestore.instance
          .collection('ordersAdvanced')
          .doc(widget.appointment.appointmentId) // assuming appointmentId is docId
          .update({
        'confirmed': true,
        'confirmedDate': _dateController.text.trim(),
        'confirmedTime': _timeController.text.trim(),
        'meetLink': _meetLinkController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Confirmation email sent!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Appointment')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please select a date' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: _selectTime,
                  decoration: const InputDecoration(
                    labelText: 'Select Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please select a time' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _meetLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Google Meet Link',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.link),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter meet link' : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                    onPressed: _confirmAppointment,
                    icon: const Icon(Icons.send),
                    label: const Text('Confirm & Send Email'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
