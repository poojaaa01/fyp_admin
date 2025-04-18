import 'package:flutter/material.dart';
import 'package:fyp_admin/providers/doc_provider.dart';
import 'package:fyp_admin/screens/dashboard_screen.dart';
import 'package:fyp_admin/screens/edit_add_form.dart';
import 'package:fyp_admin/screens/inner_screen/appointment_screen.dart';
import 'package:fyp_admin/screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:fyp_admin/providers/theme_provider.dart';
import 'consts/theme_data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return DocProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Moksha App Admin',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const DashboardScreen(),
            routes: {
              AppointmentsScreenFree.routeName: (context) => const AppointmentsScreenFree(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              EditAddScreen.routeName: (context) => const EditAddScreen(),

            },
          );
        },
      ),
    );
  }
}
