// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/provider/auth_provider.dart';
import 'package:hawkerbro/screens/account_screen.dart';
import 'package:hawkerbro/screens/hawker_screen.dart';
import 'package:hawkerbro/screens/search_screen.dart';
import 'package:provider/provider.dart';

Future<void> fetchDataByHawkerCentre(String postalCode) async {
  try {
    CollectionReference hawkerCentresCollection =
        FirebaseFirestore.instance.collection('hawkerCentres');

    DocumentSnapshot docSnapshot =
        await hawkerCentresCollection.doc(postalCode).get();

    if (docSnapshot.exists) {
// Check for the existence of 'name' field
      String name = docSnapshot['name'] ?? '';

// Print or process the data
      debugPrint('Hawker Centre Name: $name');
    } else {
      debugPrint('Hawker Centre not found with postal code: $postalCode');
    }
  } catch (e) {
    debugPrint('Error fetching data: $e');
  }
}

Future<List<Map<String, dynamic>>> fetchHawkerStallsData(
  String postalCode,
) async {
  try {
    CollectionReference hawkerStallsCollection = FirebaseFirestore.instance
        .collection('hawkerCentres')
        .doc(postalCode)
        .collection('stalls');

    QuerySnapshot querySnapshot = await hawkerStallsCollection.get();

    List<Map<String, dynamic>> hawkerStallsData =
        querySnapshot.docs.map<Map<String, dynamic>>((documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

// Handle 'ratings' field as List<dynamic> first
      List<dynamic> ratingsData = data['ratings'] ?? [];
// Convert 'ratingsData' to a list of integers
      List<int> ratings = ratingsData.map<int>((value) {
        if (value is int) {
          return value;
        } else if (value is String) {
          return int.tryParse(value) ?? 0;
        } else {
          return 0; // If the value is not a valid number, consider it as 0
        }
      }).toList();

// Handle 'reviews' field
      List<dynamic> reviewsData = data['reviews'] ?? [];
      List<String> reviews = reviewsData.map<String>((value) {
        if (value is String) {
          return value;
        } else {
          return ''; // If the value is not a valid string, consider it as an empty string
        }
      }).toList();

      int totalReviews = ratings.length;
      double averageRating = totalReviews > 0
          ? ratings.reduce((a, b) => a + b) / totalReviews
          : 0.0;

// Add averageRating, totalReviews, and imageUrl to the data map
      data['averageRating'] = averageRating;
      data['totalReviews'] = totalReviews;
      data['ratings'] =
          ratings; // Update the 'ratings' field with the correct list
      data['reviews'] =
          reviews; // Update the 'reviews' field with the correct list

// Get the first imageUrl if available, otherwise set it to a default value (an empty string or a default image URL)
      data['imageUrl'] = data['imageUrl'] ??
          ''; // Change this to a default image URL if available

      return data;
    }).toList();

    return hawkerStallsData;
  } catch (e) {
    debugPrint('Error fetching hawker stalls data: $e');
    return [];
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Map<String, dynamic>> _hawkerStallsData = [];
  final List<Map<String, String>> hawkerCentres = [
    {'name': 'Maxwell Hawker Centre', 'postalCode': '069184'},
    {'name': 'Hong Lim Market and Food Centre', 'postalCode': '051531'},
    {'name': 'Newton Food Centre', 'postalCode': '229495'},
    {'name': 'Tiong Bahru Food Centre', 'postalCode': '168898'},
// Add more hawker centres here
  ];

  Timer? _midnightTimer;
  List<String> _randomHawkerStalls = [];
  bool _hasRefreshedRecommendationsToday = false;

  @override
  void initState() {
    super.initState();
// Initialize _randomHawkerStalls with an empty list
    _randomHawkerStalls = [];
// Set hawker stalls data for Maxwell Hawker Centre as default
    _setDefaultHawkerStallsData();
// Schedule the first task to run at midnight
    _scheduleMidnightTask();
// Fetch initial recommendations when the screen loads
    _refreshRecommendations(); // Renamed from _fetchRecommendations
  }

  void _setDefaultHawkerStallsData() async {
// 'postalCode' for Maxwell Hawker Centre
    const maxwellPostalCode = '069184';

// Directly set the hawker stalls data for Maxwell Hawker Centre without any query
    _hawkerStallsData = await fetchHawkerStallsData(maxwellPostalCode);

    setState(() {});
  }

  Widget _buildHawkerCentreItem(Map<String, dynamic> hawkerCentreData) {
    String name = hawkerCentreData['name'] ?? '';
    String postalCode = hawkerCentreData['postalCode'] ?? '';

    return InkWell(
      onTap: () async {
        debugPrint('Tapped on Hawker Centre: $name, Postal Code: $postalCode');

        if (postalCode.isNotEmpty) {
          try {
            List<Map<String, dynamic>> hawkerStallsData =
                await fetchHawkerStallsData(postalCode);

// Update the state to display the hawker stalls dynamically below the hawker centre widgets
            setState(() {
              _hawkerStallsData = hawkerStallsData;
            });
          } catch (e) {
            debugPrint('Error fetching hawker stalls data: $e');
          }
        } else {
          debugPrint('Invalid postalCode: $postalCode');
        }
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 20,
        ), // Add a bottom margin of 20
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.yellow,
// No image associated with the hawker centre
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
// No stars and reviews information displayed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHawkerStallsList(List<Map<String, dynamic>> hawkerStallsData) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hawkerStallsData.length,
        itemBuilder: (context, index) {
          String stallName = hawkerStallsData[index]['name'] as String? ?? '';
          String imageUrl =
              hawkerStallsData[index]['imageUrl'] as String? ?? '';
          double averageRating =
              hawkerStallsData[index]['averageRating'] as double? ?? 0.0;
          int totalReviews =
              hawkerStallsData[index]['totalReviews'] as int? ?? 0;

          return _buildStallWidget(
            stallName,
            imageUrl: imageUrl,
            rating: averageRating,
            reviews: totalReviews,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HawkerStallScreen(
                    unitNumber: hawkerStallsData[index]['unitNumber'],
                    postalCode: hawkerStallsData[index]['postalCode'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

// Your _buildStallWidget function
  Widget _buildStallWidget(
    String stallName, {
    double rating = 0.0,
    int reviews = 0,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
// Create the content for the smaller white container
    final Widget content = Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            stallName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '($reviews)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );

// Calculate 3/4 of the screen width
    double containerWidth = MediaQuery.of(context).size.width * 3 / 4;

// Calculate the padding value for the white container
    double whiteContainerPadding = containerWidth * 0.05; // 5% of the width

// The entire stall widget
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 400,
        width: containerWidth,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromARGB(255, 201, 201, 201),
          image: imageUrl != null && imageUrl.isNotEmpty
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageUrl),
                )
              : null,
        ),
        child: Stack(
          children: [
// Smaller white container with stall details aligned to the bottom center
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ), // Add padding to the bottom
                child: Container(
                  height: 125, // Height of the smaller white container
                  width: containerWidth - (whiteContainerPadding * 2),
                  padding: EdgeInsets.only(
                    left: whiteContainerPadding,
                    right: whiteContainerPadding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleMidnightTask() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day, 0, 0, 0)
        .add(const Duration(days: 1));
    final durationUntilMidnight = midnight.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
// When the task runs at midnight, fetch new random recommendations
      _refreshRecommendations();
      _hasRefreshedRecommendationsToday =
          true; // Set the flag to true after refreshing
// Schedule the next task for the next midnight
      _scheduleMidnightTask();
    });
  }

  Future<void> _refreshRecommendations() async {
    if (_hasRefreshedRecommendationsToday) {
// Recommendations have already been refreshed today, skip the fetch
      return;
    }

    try {
      List<String> allHawkerStalls = await fetchAllHawkerStallNames();
      _randomHawkerStalls = getRandomHawkerStalls(allHawkerStalls);

// Update the UI by calling setState()
      setState(() {});
      _hasRefreshedRecommendationsToday = true; // Set the flag to true
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
    }
  }

  Future<List<String>> fetchAllHawkerStallNames() async {
    try {
      CollectionReference hawkerCentresCollection =
          FirebaseFirestore.instance.collection('hawkerCentres');
      QuerySnapshot hawkerCentresSnapshot = await hawkerCentresCollection.get();

      List<String> allHawkerStalls = [];

      for (var hawkerCentreDoc in hawkerCentresSnapshot.docs) {
        String hawkerCentrePostalCode = hawkerCentreDoc.id;

// Fetch the subcollection 'stalls' under the current hawker centre document
        QuerySnapshot stallsSnapshot = await hawkerCentresCollection
            .doc(hawkerCentrePostalCode)
            .collection('stalls')
            .get();

// Add all hawker stall names from the current hawker centre's subcollection to the list
        allHawkerStalls.addAll(
          stallsSnapshot.docs.map((stallDoc) {
            return stallDoc['name'] as String? ?? '';
          }).toList(),
        );
      }

      return allHawkerStalls;
    } catch (e) {
      debugPrint('Error fetching hawker stall names: $e');
      return [];
    }
  }

  List<String> getRandomHawkerStalls(List<String> allHawkerStalls) {
    final random = Random();
    allHawkerStalls.shuffle(); // Shuffle the list of all hawker stalls
    return allHawkerStalls
        .take(5)
        .toList(); // Take the first 5 hawker stalls after shuffling
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 70,
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        titleSpacing: 8,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Hi, ${ap.userModel.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Find Delicious Hawker Food',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10),
                      Text('Search...'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
// The 'Near You' Text widget has been removed.
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hawkerCentres.length,
                      itemBuilder: (context, index) {
                        return _buildHawkerCentreItem(hawkerCentres[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: _hawkerStallsData.isNotEmpty
                  ? _buildHawkerStallsList(_hawkerStallsData)
                  : Container(), // Show empty container when there are no hawker stalls data
            ),

// Add Recommendations Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Feeling Lucky?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Here are the 5 stalls you should try!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _randomHawkerStalls.length,
                      itemBuilder: (context, index) {
                        String stallName = _randomHawkerStalls[index];
                        return InkWell(
                          onTap: () {
// Implement the navigation to the HawkerStallScreen here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HawkerStallScreen(
                                  unitNumber: _hawkerStallsData[index]
                                      ['unitNumber'],
                                  postalCode: _hawkerStallsData[index]
                                      ['postalCode'],
                                ),
                              ),
                            );
                          },
                          child: _buildStallWidget(stallName),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
