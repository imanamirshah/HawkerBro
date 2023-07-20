import 'package:flutter/cupertino.dart';
import 'package:hawkerbro/screens/account_screen.dart';
import 'package:hawkerbro/screens/explore_screen.dart';
import 'package:hawkerbro/screens/favourites_screen.dart';

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
            label: 'Explore',
            icon: Icon(CupertinoIcons.compass),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(CupertinoIcons.person),
          ),
          BottomNavigationBarItem(
            label: 'Favourites',
            icon: Icon(CupertinoIcons.bookmark),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const ExploreScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const AccountScreen(),
            );
          case 2:
          default:
            return CupertinoTabView(
              builder: (context) => const FavouritesScreen(),
            );
        }
      },
    );
  }
}
