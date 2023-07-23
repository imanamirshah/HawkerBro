// ignore_for_file: use_build_context_synchronously

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/fetch_stall_model.dart';
import 'package:hawkerbro/provider/auth_provider.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:hawkerbro/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

class LeaveReviewScreen extends StatefulWidget {
  final String unitNumber;
  final String postalCode;

  const LeaveReviewScreen({
    Key? key,
    required this.unitNumber,
    required this.postalCode,
  }) : super(key: key);

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  late Future<FetchStallModel?> _stallDataFuture;
  FetchStallModel? stall;
  final TextEditingController _reviewController = TextEditingController();
  int rating = 0;

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
    _stallDataFuture = fetchStallData();
  }

  Future<FetchStallModel?> fetchStallData() async {
    try {
      final DocumentSnapshot stallSnapshot = await FirebaseFirestore.instance
          .collection('hawkerCentres')
          .doc(widget.postalCode)
          .collection('stalls')
          .doc(widget.unitNumber)
          .get();

      final stallData = stallSnapshot.data() as Map<String, dynamic>;

      return FetchStallModel.fromJSON(stallData);
    } catch (e) {
      throw Exception('Error fetching stall data: $e');
    }
  }

  Future<void> postReview() async {
    final review = _reviewController.text.trim();
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final userModel = ap.userModel;
    final reviewer = userModel.name;
    if (review.isNotEmpty) {
      try {
        final stallRef = FirebaseFirestore.instance
            .collection('hawkerCentres')
            .doc(widget.postalCode)
            .collection('stalls')
            .doc(widget.unitNumber);

        final DocumentSnapshot stallSnapshot = await stallRef.get();
        final stallData = stallSnapshot.data() as Map<String, dynamic>;

        List<String> reviews = List<String>.from(stallData['reviews'] ?? []);
        reviews.add(review);

        List<int> ratings = List<int>.from(stallData['ratings'] ?? []);
        ratings.add(rating);

        List<String> reviewers =
            List<String>.from(stallData['reviewers'] ?? []);
        reviewers.add(reviewer);

        // Update the stall data in Firestore
        await stallRef.update({
          'reviews': reviews,
          'ratings': ratings,
          'reviewers': reviewers,
        });

        Navigator.pop(context, stall);

        _reviewController.clear();
        setState(() {
          rating = 0;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Thank you for your review!.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post review: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a review.'),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FetchStallModel?>(
      future: _stallDataFuture,
      builder: (context, stallSnapshot) {
        if (stallSnapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        stall = stallSnapshot.data!;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stall!.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  RatingBar(
                    onRatingChanged: (int inputRating) {
                      setState(() {
                        rating = inputRating;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _reviewController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Leave your review!',
                      ),
                      maxLines: 6,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      onPressed: postReview,
                      text: 'Post Review',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RatingBar extends StatefulWidget {
  final Function(int) onRatingChanged;

  const RatingBar({Key? key, required this.onRatingChanged}) : super(key: key);

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildStarIcon(1),
        buildStarIcon(2),
        buildStarIcon(3),
        buildStarIcon(4),
        buildStarIcon(5),
      ],
    );
  }

  Widget buildStarIcon(int starNumber) {
    return IconButton(
      icon: Icon(
        _rating >= starNumber ? Icons.star : Icons.star_border,
        color: _rating >= starNumber ? Colors.yellow : Colors.grey,
        size: 40.0,
      ),
      onPressed: () {
        setState(() {
          _rating = starNumber;
        });
        widget.onRatingChanged(
          _rating,
        ); // Notify parent widget of the selected rating
      },
    );
  }
}
