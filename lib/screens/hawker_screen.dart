import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/fetch_stall_model.dart';
import 'package:hawkerbro/screens/consmer_leave_review.dart';
import 'package:hawkerbro/screens/edit_stall_screen.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:hawkerbro/widgets/loading_screen.dart';
import 'package:hawkerbro/widgets/review_row.dart';

class HawkerStallScreen extends StatefulWidget {
  final String unitNumber;
  final String postalCode;

  const HawkerStallScreen({
    Key? key,
    required this.unitNumber,
    required this.postalCode,
  }) : super(key: key);

  @override
  State<HawkerStallScreen> createState() => _HawkerStallScreenState();
}

class _HawkerStallScreenState extends State<HawkerStallScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  FetchStallModel? stall;

  @override
  void initState() {
    super.initState();
    _fetchStallData();
  }

  Future<void> _refreshData() async {
    final stallData = await _fetchStallData();

    if (stallData != null) {
      setState(() {
        stall = stallData;
      });
    }
  }

  Future<FetchStallModel?> _fetchStallData() async {
    try {
      final DocumentSnapshot stallSnapshot = await FirebaseFirestore.instance
          .collection('hawkerCentres')
          .doc(widget.postalCode)
          .collection('stalls')
          .doc(widget.unitNumber)
          .get();

      if (stallSnapshot.exists) {
        debugPrint("stall info exists in snapshot");

        final stallData = stallSnapshot.data() as Map<String, dynamic>;

        debugPrint('stallData: $stallData');

        return FetchStallModel.fromJSON(stallData);
      }
    } catch (e) {
      throw Exception('Error fetching stall data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      child: FutureBuilder<FetchStallModel?>(
        future: _fetchStallData(),
        builder: (context, stallSnapshot) {
          if (stallSnapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }

          if (stallSnapshot.hasError) {
            debugPrint('Error: ${stallSnapshot.error}');
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('Error loading stall data - data has error'),
              ),
            );
          }

          if (!stallSnapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('Error loading stall data - no data'),
              ),
            );
          }

          var stall = stallSnapshot.data!;
          debugPrint('there are ${stall.stallImages.length} images');
          debugPrint('Stall Images: ${stall.stallImages}');

          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(right: 12),
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStallScreen(
                          unitNumber: stall.unitNumber,
                          postalCode: stall.postalCode,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        stall = result;
                      });
                    }
                  },
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                SizedBox(
                  height: 280.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stall.stallImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Card(
                          child: Image.network(
                            stall.stallImages[index],
                            fit: BoxFit.cover,
                            width: 350,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  stall.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
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
                Text('Address: ${stall.unitNumber} ${stall.postalCode}'),
                Text('Opening Hours: ${stall.openingHours}'),
                const SizedBox(height: 16.0),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(stall.bio),
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
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildMenuItems(),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Ratings and Reviews',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Review Rows

                SizedBox(
                  height: 200, // Set a specific height that fits your layout
                  child: SingleChildScrollView(
                    child: Column(
                      children: stall.reviews
                          .asMap()
                          .entries
                          .map(
                            (entry) => ReviewRow(
                              username: 'User',
                              reviewText: entry.value,
                              rating: stall.ratings[entry.key].toString(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  child: CustomButton(
                    text: "Leave A Review",
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaveReviewScreen(
                            unitNumber: stall.unitNumber,
                            postalCode: stall.postalCode,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          stall = result;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    // Replace this with your logic to generate menu items
    List<Widget> menuItems = [];
    for (int i = 0; i < 4; i++) {
      menuItems.add(
        Column(
          children: [
            Card(
              child: Column(
                children: [
                  SizedBox(
                    width: 120.0,
                    height: 80.0,
                    child: Center(
                      child: Text('Food Item ${i + 1}'),
                    ),
                  ),
                ],
              ),
            ),
            Text("Food ${i + 1}")
          ],
        ),
      );
    }
    return menuItems;
  }
}
