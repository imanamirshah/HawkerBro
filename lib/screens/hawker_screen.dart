import 'package:flutter/material.dart';
import 'package:hawkerbro/screens/search_screen.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(
            height: 280.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Card(
                    child: Image.asset(
                      'assets/wokbackground.jpg',
                      fit: BoxFit.cover,
                      width: 350,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Card(
                    child: Image.asset(
                      'assets/wokbackground.jpg',
                      fit: BoxFit.cover,
                      width: 350,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Card(
                    child: Image.asset(
                      'assets/wokbackground.jpg',
                      fit: BoxFit.cover,
                      width: 350,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Card(
                    child: Image.asset(
                      'assets/wokbackground.jpg',
                      fit: BoxFit.cover,
                      width: 350,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Card(
                    child: Image.asset(
                      'assets/wokbackground.jpg',
                      fit: BoxFit.cover,
                      width: 350,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Restaurant Name',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star_half, color: Colors.yellow),
              Icon(Icons.star_border, color: Colors.yellow),
              SizedBox(width: 4.0),
              Text('3.5'),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Business Information',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text('Address: 123 Main Street'),
          const Text('Opening Hours: 9:00 AM - 10:00 PM'),
          const SizedBox(height: 16.0),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text('This is a description of the restaurant.'),
          const SizedBox(height: 16.0),
          const Text(
            'Menu',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 100.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                Card(
                  child: SizedBox(
                    width: 120.0,
                    child: Center(
                      child: Text('Food Item 1'),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: 120.0,
                    child: Center(
                      child: Text('Food Item 2'),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: 120.0,
                    child: Center(
                      child: Text('Food Item 3'),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: 120.0,
                    child: Center(
                      child: Text('Food Item 4'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Your other methods here...
}
