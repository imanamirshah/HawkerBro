import 'package:flutter/material.dart';
import 'package:hawkerbro/screens/hawker_screen.dart';

class LeaveReviewScreen extends StatelessWidget {
  const LeaveReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 32.0,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (contex) => const HawkerStallScreen(
                        stallName: 'Stall name',
                        stallAddress: 'Stall address',
                        stallDescription: 'Stall description',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Old Nonya',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const RatingBar(),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const TextField(
                decoration: InputDecoration.collapsed(
                  hintText: 'Leave your review!',
                ),
                maxLines: 6,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                onPressed: () {
                  // Handle the action of posting the review
                },
                child: const Text(
                  'Post Review',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBar extends StatefulWidget {
  const RatingBar({Key? key}) : super(key: key);

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
      },
    );
  }
}
