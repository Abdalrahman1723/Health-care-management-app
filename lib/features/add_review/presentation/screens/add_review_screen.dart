import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_bar.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double _rating = 0; // Default rating
  bool _isFavorite = false;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      )),
      child: Scaffold(
        appBar: myAppBar(context: context, title: "Add Review"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Review your doctor based on your experience",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      'lib/core/assets/images/download.jpg',
                    ),
                    radius: 80,
                  ),
                  const SizedBox(height: 12),
                  GradientBackground.gradientText("Dr. Sara Ahmed",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  const Text(
                    "General doctor",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Star Rating Bar & Favorite Icon
                  starReview(),
                  const SizedBox(height: 16),

                  // Review Text Field
                  TextField(
                    controller: _reviewController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Write your review",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add Review Button
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.containerBackground,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Handle review submission
                        String reviewText = _reviewController.text;
                        if (reviewText.isNotEmpty && _rating > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Review added successfully")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please add a rating and review")),
                          );
                        }
                      },
                      child: Text(
                        "Add review",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//-----------------------star review
  Row starReview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.cyan,
              width: 2,
            ),
          ),
          child: Row(
            children: [
// Star Rating Bar with Gradient Background
              IconButton(
                icon: GradientBackground.gradientIcon(
                  _rating >= 1 ? Icons.star : Icons.star_border,
                ),
                onPressed: () => setState(() => _rating = 1),
              ),
              IconButton(
                icon: GradientBackground.gradientIcon(
                  _rating >= 2 ? Icons.star : Icons.star_border,
                ),
                onPressed: () => setState(() => _rating = 2),
              ),
              IconButton(
                icon: GradientBackground.gradientIcon(
                  _rating >= 3 ? Icons.star : Icons.star_border,
                ),
                onPressed: () => setState(() => _rating = 3),
              ),
              IconButton(
                icon: GradientBackground.gradientIcon(
                  _rating >= 4 ? Icons.star : Icons.star_border,
                ),
                onPressed: () => setState(() => _rating = 4),
              ),
              IconButton(
                icon: GradientBackground.gradientIcon(
                  _rating >= 5 ? Icons.star : Icons.star_border,
                ),
                onPressed: () => setState(() => _rating = 5),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),
        // Favorite Icon
        IconButton(
          icon: GradientBackground.gradientIcon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
          ),
          onPressed: () => setState(() {
            _isFavorite = !_isFavorite;
          }),
        ),
      ],
    );
  }
}
