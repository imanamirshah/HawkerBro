import 'package:flutter/cupertino.dart';
import 'package:hawkerbro/screens/account_screen.dart';
import 'package:hawkerbro/screens/notfications.dart';
import 'package:hawkerbro/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.systemYellow,
        activeColor: CupertinoColors.black,
        inactiveColor: CupertinoColors.black.withOpacity(0.5),
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: Icon(CupertinoIcons.bell),
          ),
          BottomNavigationBarItem(
            label: 'Explore',
            icon: Icon(CupertinoIcons.compass),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const NotificationsScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const SearchPage(),
            );
          case 2:
          default:
            return CupertinoTabView(
              builder: (context) => const AccountScreen(),
            );
        }
      },
    );
  }
}
