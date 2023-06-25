import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/fetch_stall_model.dart';
import 'package:hawkerbro/screens/consmer_leave_review.dart';
import 'package:hawkerbro/screens/edit_stall_screen.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:hawkerbro/widgets/loading_screen.dart';
import 'package:hawkerbro/widgets/review_row.dart';

class HawkerStallScreen extends StatefulWidget {
  final String? unitNumber;
  final String? postalCode;
  final String? stallAddress;
  final String? stallName;
  final String? stallDescription;

  const HawkerStallScreen({
    Key? key,
    this.unitNumber,
    this.postalCode,
    this.stallAddress,
    this.stallName,
    this.stallDescription,
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
    if (widget.unitNumber == null ||
        widget.postalCode == null ||
        widget.stallAddress == null ||
        widget.stallName == null ||
        widget.stallDescription == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Incomplete stall data'),
        ),
      );
    }

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

          if (!stallSnapshot.hasData || stallSnapshot.data == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('No stall data available'),
              ),
            );
          }

          stall = stallSnapshot.data!;

          var reviewText;
          var username;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Hawker Stall Details'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStallScreen(
                          unitNumber: widget.unitNumber ?? '',
                          postalCode: widget.postalCode ?? '',
                          stallAddress: widget.stallAddress,
                          stallName: widget.stallName,
                          stallDescription: widget.stallDescription,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Text(
                  widget.stallName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.stallAddress!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.stallDescription!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    const Text(
                      'Average Rating:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      calculateAverageRating(stall!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reviews:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 8),
                // ...stall!.reviews.map((review) => ReviewRow(
                //       username: review.username,
                //       reviewText: review.reviewText,
                //       rating: review.rating,
                //     )),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Leave Review',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveReviewScreen(
                          unitNumber: widget.unitNumber ?? '',
                          postalCode: widget.postalCode ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
