import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/home_screen_provider.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/add_friends_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/main_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/my_events_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/schedule_screen.dart';
import 'package:flutter_events_2023/View/Screens/AppScreens/settings_screen.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _buildPage(model.currentTab),
          bottomNavigationBar: BottomNavigationBar(
            //backgroundColor: LightColor.primary,
            //fixedColor: LightColor.primary,
            selectedItemColor: LightColor.primary,
            unselectedItemColor: LightColor.primary,
            currentIndex: model.currentTab,
            onTap: (index) => model.changeTab(index),
            items: [
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                icon: const Icon(Icons.home_filled),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                label: "Add friends",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: "My Events",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Schedule",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const MainScreen();
      case 1:
        return const AddFriendScreen();
      case 2:
        return const MyEventScreen();
      case 3:
        return const ScheduleEventScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const MainScreen();
    }
  }
}
