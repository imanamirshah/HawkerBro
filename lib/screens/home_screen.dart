import 'package:flutter/cupertino.dart';
import 'package:hawkerbro/screens/explore_screen.dart';
import 'package:hawkerbro/screens/likes_screen.dart';
import 'package:hawkerbro/screens/notfications.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.systemYellow,
        activeColor: CupertinoColors.black,
        inactiveColor: CupertinoColors.black.withOpacity(0.5),
        iconSize: 22,
        height: 45,
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
            label: 'Favourites',
            icon: Icon(CupertinoIcons.heart),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => NotificationsScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const ExploreScreen(),
            );
          case 2:
          default:
            return CupertinoTabView(
              builder: (context) => const LikesScreen(),
            );
        }
      },
    );
  }
}
