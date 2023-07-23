// ignore_for_file: use_build_context_synchronously

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/fetch_stall_model.dart';
import 'package:hawkerbro/provider/auth_provider.dart';
import 'package:hawkerbro/screens/consmer_leave_review.dart';
import 'package:hawkerbro/screens/edit_stall_screen.dart';
import 'package:hawkerbro/utils/utils.dart';
import 'package:hawkerbro/widgets/loading_screen.dart';
import 'package:hawkerbro/widgets/review_row.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

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
  bool isLiked = false;

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
    _fetchStallData();
    getLikeStatus();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<void> getLikeStatus() async {
    // Get the currently logged-in user
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final user = ap.userModel;

    // Retrieve the like status for the current stall and set the local state
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('favourites')
        .doc(widget.unitNumber)
        .get();

    setState(() {
      isLiked = snapshot.exists;
    });
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

  String calculateAverageRating(FetchStallModel stall) {
    final List<int> ratings = stall.ratings;

    if (ratings.isEmpty) {
      return '0.0'; // default 0 stars if none is clicked
    } else {
      double sum = 0;
      for (int rating in ratings) {
        sum += rating;
      }
      double average = sum / ratings.length;
      return average.toStringAsFixed(1);
    }
  }

  Future<void> onLikeButtonTapped() async {
    // Get the currently logged-in user
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final user = ap.userModel;
    final stall = await _fetchStallData();

    // Add or remove the stall from the user's favorites subcollection
    final favorites = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('favourites')
        .doc(widget.unitNumber);

    setState(() {
      isLiked = !isLiked; // Toggle the like status locally
    });

    debugPrint(user.name);

    if (isLiked) {
      // Add the stall to favorites
      await favorites.set({
        'unitNumber': widget.unitNumber,
        'postalCode': widget.postalCode,
        'stallName': stall?.name,
        'address': stall?.address,
        'imageUrl': stall!.stallImages.isNotEmpty ? stall.stallImages[0] : null,
      });
      showSnackBarFavourites(context, 'Stall added to Favourites.');
    } else {
      // Remove the stall from favorites
      await favorites.delete();
      showSnackBarFavourites(context, 'Stall removed from Favourites.');
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
          final websiteUri = Uri.parse(
            "https://www.google.com/maps/search/?api=1&query=Singapore ${stall.postalCode}",
          );

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
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.bookmark : Icons.bookmark_outline,
                    color: isLiked ? Colors.black : null,
                  ),
                  onPressed: onLikeButtonTapped,
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (stall.stallImages.isEmpty)
                  const SizedBox(
                    height: 100.0,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.black12,
                        size: 50,
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
                  'Address: ${stall.address},  Singapore ${stall.postalCode}',
                ),
                const SizedBox(height: 4.0),
                Text('Unit: #${stall.unitNumber}'),
                const SizedBox(height: 4.0),
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
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 255, 217, 0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.reviews_outlined),
                          label: const Text(
                            "Leave A Review",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
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
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Link(
                          uri: websiteUri,
                          builder: (context, openLink) => ElevatedButton.icon(
                            icon: const Icon(Icons.map_outlined),
                            onPressed: openLink,
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.black,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 217, 0),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            label: const Text(
                              'Directions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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
