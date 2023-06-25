import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ReviewRow extends StatefulWidget {
  final String username;
  final String reviewText;
  final String rating;

  const ReviewRow({
    Key? key,
    required this.username,
    required this.reviewText,
    required this.rating,
  }) : super(key: key);

  @override
  State<ReviewRow> createState() => _ReviewRowState();
}

class _ReviewRowState extends State<ReviewRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  widget.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.star, color: Colors.yellow),
                  const SizedBox(width: 2.0),
                  Text(
                    widget.rating,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReadMoreText(
              '${widget.reviewText} ',
              trimLines: 2,
              textScaleFactor: 1,
              colorClickableText: Colors.red,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              style: const TextStyle(color: Colors.black, fontSize: 18),
              moreStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
