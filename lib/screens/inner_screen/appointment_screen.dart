import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/appointment_model.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/empty_apt.dart';
import '../../../widgets/title_text.dart';
import 'appointment_widget.dart';
import 'confirm_screen.dart';

class AppointmentsScreenFree extends StatefulWidget {
  static const routeName = '/AppointmentsScreenFree';

  const AppointmentsScreenFree({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreenFree> createState() => _AppointmentsScreenFreeState();
}

class _AppointmentsScreenFreeState extends State<AppointmentsScreenFree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(
          label: 'Scheduled Appointments',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ordersAdvanced').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return EmptyAptWidget(
              imagePath: AssetsManager.view,
              title: "No appointment has been booked yet",
              subtitle: "",
              buttonText: '',
            );
          }

          final appointments = snapshot.data!.docs
              .map((doc) => Appointment.fromFirestore(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.separated(
            itemCount: appointments.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmAppointmentScreen(
                          appointment: appointments[index],
                        ),
                      ),
                    );
                  },
                  child: AppointmentsWidgetFree(appointment: appointments[index]),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
    );
  }
}
