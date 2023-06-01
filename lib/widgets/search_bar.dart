import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class FloatingSearchBarWidget extends StatelessWidget {
  const FloatingSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 70, color: Colors.white);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class GNavWidget extends StatelessWidget {
  const GNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[600],
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 16),
        child: GNav(
          gap: 8,
          color: Colors.black,
          activeColor: Colors.white,
          iconSize: 30,
          tabBackgroundColor: Colors.black,
          padding: EdgeInsets.all(10),
          tabs: [
            GButton(
              icon: LineIcons.bell,
              text: 'Notifications',
            ),
            GButton(
              icon: LineIcons.compass,
              text: 'Explore',
            ),
            GButton(
              icon: LineIcons.user,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
