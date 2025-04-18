import 'package:flutter/material.dart';
import '../../../../widgets/empty_apt.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'appointment_widget.dart';

class AppointmentsScreenFree extends StatefulWidget {
  static const routeName = '/AppointmentsScreenFree';

  const AppointmentsScreenFree({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreenFree> createState() => _AppointmentsScreenFreeState();
}

class _AppointmentsScreenFreeState extends State<AppointmentsScreenFree> {
  bool isEmptyAppointments = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(
            label: 'Scheduled Appointments',
          ),
        ),
        body: isEmptyAppointments
            ? EmptyAptWidget(
          imagePath: AssetsManager.view,
          title: "No appointment has been booked yet",
          subtitle: "", buttonText: '',
        )
            : ListView.separated(
          itemCount: 15,
          itemBuilder: (ctx, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: AppointmentsWidgetFree(),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              // thickness: 8,
              // color: Colors.red,
            );
          },
        ));
  }
}
