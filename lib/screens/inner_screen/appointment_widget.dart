import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import '../../../consts/app_constants.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import '../../models/appointment_model.dart';

class AppointmentsWidgetFree extends StatelessWidget {
  final Appointment appointment;

  const AppointmentsWidgetFree({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.25,
              width: size.width * 0.25,
              imageUrl: appointment.imageUrl,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitlesTextWidget(
                          label: appointment.docTitle,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // implement delete logic if needed
                        },
                        icon: const Icon(Icons.clear, color: Colors.red, size: 22),
                      ),
                    ],
                  ),
                  SubtitleTextWidget(
                    label: 'Date: ${appointment.bookDate}',
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      const TitlesTextWidget(label: 'Price:  ', fontSize: 15),
                      SubtitleTextWidget(
                        label: "Rs ${appointment.price}",
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  SubtitleTextWidget(
                    label: 'User: ${appointment.username}',
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
