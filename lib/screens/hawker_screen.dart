import 'package:flutter/material.dart';
import 'package:hawkerbro/widgets/search_bar.dart';

class HawkerStallScreen extends StatefulWidget {
  final String stallName;
  final String stallAddress;
  final String stallDescription;

  const HawkerStallScreen({
    super.key,
    required this.stallName,
    required this.stallAddress,
    required this.stallDescription,
  });

  @override
  State<HawkerStallScreen> createState() => _HawkerStallScreenState();
}

class _HawkerStallScreenState extends State<HawkerStallScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FloatingSearchBarWidget(),
        ],
      ),
      bottomNavigationBar: GNavWidget(),
    );
  }

  // Your other methods here...
}
