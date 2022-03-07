import 'package:flutter/material.dart';
import 'package:flutter_chodi_app/services/firebase_authentication_service.dart';

import 'package:flutter_chodi_app/screens/calendar/calendar_screen.dart';
import 'package:flutter_chodi_app/screens/foryou/for_you_screen.dart';
import 'package:flutter_chodi_app/screens/impact/impact_screen.dart';
import 'package:flutter_chodi_app/viewmodel/main_view_model.dart';
import 'messages/messages_screen.dart';
import 'package:provider/provider.dart';
import '../configs/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<String> getFutureName() async {
  String name = await FirebaseService().getUsername();
  //String name = '';
  return Future.delayed(const Duration(seconds: 1), () => name);
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late Widget _nowWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFEEEAEA),
          selectedItemColor: Colors.blue,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/images/impact.png"),
                  size: 20,
                ),
                label: "Impact"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/images/events.png"),
                  size: 20,
                ),
                label: "Calendar"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/images/for_you.png"),
                  size: 20,
                ),
                label: "For You"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/images/messages.png"),
                  size: 20,
                ),
                label: "Messages"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/images/notifications.png"),
                  size: 20,
                ),
                label: "Notifications")
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) {
                Provider.of<MainScreenViewModel>(context, listen: false)
                    .setWidget(const ImpactScreen());
              } else if (index == 1) {
                Provider.of<MainScreenViewModel>(context, listen: false)
                    .setWidget(const CalendarScreen());
              } else if (index == 2) {
                Provider.of<MainScreenViewModel>(context, listen: false)
                    .setWidget(const ForYouScreen());
              } else if (index == 3) {
                Provider.of<MainScreenViewModel>(context, listen: false)
                    .setWidget(const MessagesScreen());
              } else if (index == 4) {
                Provider.of<MainScreenViewModel>(context, listen: false)
                    .setWidget(const MessagesScreen());
              }
            });
          },
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Provider.of<MainScreenViewModel>(context, listen: true).widget,
        ));
  }
}
