import 'package:flutter/cupertino.dart';
import 'package:fyp_admin/screens/inner_screen/appointment_screen.dart';
import 'package:fyp_admin/screens/search_screen.dart';
import 'package:fyp_admin/services/assets_manager.dart';

import '../screens/edit_add_form.dart';

class DashboardButtonsModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonsModel> dashboardBtnList(context) => [
    DashboardButtonsModel(
      text: "Get added",
      imagePath: AssetsManager.add,
      onPressed: () {
        Navigator.pushNamed(context, EditAddScreen.routeName);
      },
    ),
    DashboardButtonsModel(
      text: "Inspect",
      imagePath: AssetsManager.noApt,
      onPressed: () {
        Navigator.pushNamed(context, SearchScreen.routeName);
      },
    ),
    DashboardButtonsModel(
      text: "View appointments",
      imagePath: AssetsManager.view,
      onPressed: () {
        Navigator.pushNamed(context, AppointmentsScreenFree.routeName);
      },
    ),
  ];
}
