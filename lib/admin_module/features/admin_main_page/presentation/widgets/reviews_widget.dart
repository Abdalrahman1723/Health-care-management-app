import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/admin_main_page_cubit.dart';

class ReviewsWidget extends StatefulWidget {
  const ReviewsWidget({super.key});

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  @override
  void initState() {
    super.initState();
    log('ReviewsWidget: Initializing and fetching feedback', name: 'REVIEWS');
    // Add a small delay to ensure the widget is properly mounted
    Future.microtask(() {
      if (mounted) {
        context.read<AdminMainPageCubit>().fetchAllFeedback();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your App Doctors Reviews & Feedbacks",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            BlocBuilder<AdminMainPageCubit, AdminMainPageState>(
              buildWhen: (previous, current) =>
                  current is FeedbackLoading ||
                  current is FeedbackError ||
                  current is FeedbackLoaded,
              builder: (context, state) {
                log('ReviewsWidget: Current state is ${state.runtimeType}',
                    name: 'REVIEWS');

                if (state is FeedbackLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                if (state is FeedbackError) {
                  log('ReviewsWidget: Error state - ${state.message}',
                      name: 'REVIEWS');
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            log('ReviewsWidget: Retrying feedback fetch',
                                name: 'REVIEWS');
                            context
                                .read<AdminMainPageCubit>()
                                .fetchAllFeedback();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is FeedbackLoaded) {
                  log('ReviewsWidget: Loaded ${state.feedbackList.length} feedback items',
                      name: 'REVIEWS');
                  if (state.feedbackList.isEmpty) {
                    return const Center(
                      child: Text(
                        "No feedback available yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = state.feedbackList[index];
                      return Card(
                        color: Colors.white.withOpacity(0.1),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //----------- doctors name --------------//
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.health_and_safety,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "Dr. ${feedback['doctorName'] ?? 'Anonymous'}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    feedback['patientName'] ?? 'Anonymous',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  //---------show date-----------//
                                  Text(
                                    feedback['date'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${feedback['rating'] ?? 0}/5',
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                feedback['comment'] ?? 'No comment provided',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
