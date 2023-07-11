import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/fetch_stall_model.dart';
import 'package:hawkerbro/screens/consmer_leave_review.dart';
import 'package:hawkerbro/screens/edit_stall_screen.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:hawkerbro/widgets/loading_screen.dart';
import 'package:hawkerbro/widgets/review_row.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  //bool isLiked = false;

  FetchStallModel? stall;

  @override
  void initState() {
    super.initState();
    _fetchStallData();
    //   getLikeStatus();
  }

  // Future<void> getLikeStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     isLiked = prefs.getBool('likeStatus') ??
  //         false; // Retrieve the like status or set it to false if not found
  //   });
  // }

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

  String calculateAverageRating(FetchStallModel stall) {
    final List<int> ratings = stall.ratings;

    if (ratings.isEmpty) {
      return '0.0'; // or any other default value you prefer
    } else {
      double sum = 0;
      for (int rating in ratings) {
        sum += rating;
      }
      double average = sum / ratings.length;
      return average.toStringAsFixed(1);
    }
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

          debugPrint('Reviews length: ${stall.reviews.length}');
          debugPrint('Reviews: ${stall.reviews}');

          debugPrint('Reviewers length: ${stall.reviewers.length}');
          debugPrint('Reviewers: ${stall.reviewers}');

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
                // IconButton(
                //   icon: Icon(
                //     isLiked ? Icons.favorite : Icons.favorite_border,
                //     color: isLiked ? Colors.red : null,
                //   ),
                //   onPressed: onLikeButtonTapped,
                // ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (stall.stallImages.isEmpty)
                  const SizedBox(
                    height: 100.0,
                    child: Center(
                      child: Text(
                        "This stall has no images.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )
                else
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      calculateAverageRating(stall),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.yellow),
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
                Text(
                  'Address: ${stall.address}, #${stall.unitNumber}, S${stall.postalCode}',
                ),
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
                // const Text(
                //   'Menu',
                //   style: TextStyle(
                //     fontSize: 18.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 8.0),
                // SizedBox(
                //   height: 120,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: _buildMenuItems(),
                //   ),
                // ),
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
                if (stall.reviews.isEmpty)
                  const Text(
                    'This stall has no reviews.',
                  )
                else
                  SizedBox(
                    height: 200, // Set a specific height that fits your layout
                    child: SingleChildScrollView(
                      child: Column(
                        children: stall.reviews
                            .asMap()
                            .entries
                            .map(
                              (entry) => ReviewRow(
                                username: stall.reviewers[entry.key].toString(),
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

  // Future<void> onLikeButtonTapped() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     isLiked = !isLiked; // Toggle the like status
  //   });
  //   await prefs.setBool('likeStatus', isLiked); // Save the like status
  //   // final bool success= await sendRequest();

  //   /// if failed, you can do nothing
  //   // return success? !isLiked:isLiked;
  // }

  // List<Widget> _buildMenuItems() {
  //   // Replace this with your logic to generate menu items
  //   List<Widget> menuItems = [];
  //   for (int i = 0; i < 4; i++) {
  //     menuItems.add(
  //       Column(
  //         children: [
  //           Card(
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   width: 120.0,
  //                   height: 80.0,
  //                   child: Center(
  //                     child: Text('Food Item ${i + 1}'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Text("Food ${i + 1}")
  //         ],
  //       ),
  //     );
  //   }
  //   return menuItems;
  // }
}
