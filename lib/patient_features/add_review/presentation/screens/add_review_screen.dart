import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/utils/app_bar.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/patient_features/add_review/presentation/cubit/add_review_cubit.dart';
import 'package:health_care_app/patient_features/add_review/presentation/cubit/add_review_state.dart';

class AddReviewScreen extends StatefulWidget {
  final int doctorId;
  final String doctorName;
  final int patientId;
  final String patientName;

  const AddReviewScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double _rating = 0;
  bool _isFavorite = false;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddReviewCubit, AddReviewState>(
      listener: (context, state) {
        if (state is AddReviewSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pop(context);
        } else if (state is AddReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
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
                      //---------doctor picture
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          'lib/core/assets/images/download.jpg', //!should be doctors picture
                        ),
                        radius: 80,
                      ),
                      const SizedBox(height: 12),
                      GradientBackground.gradientText(widget.doctorName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      //should be doctor specialty
                      const Text(
                        "General doctor", //! should be fetched
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      starReview(),
                      const SizedBox(height: 16),
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
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.containerBackground,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (_reviewController.text.isNotEmpty &&
                                _rating > 0) {
                              context.read<AddReviewCubit>().addReview(
                                    doctorId: widget.doctorId,
                                    doctorName: widget.doctorName,
                                    patientId: widget.patientId,
                                    patientName: widget.patientName,
                                    comment: _reviewController.text,
                                    rating: _rating,
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please add a rating and review")),
                              );
                            }
                          },
                          child: state is AddReviewLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  "Add review",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
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
      },
    );
  }

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
