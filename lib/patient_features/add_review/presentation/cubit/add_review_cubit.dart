import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/api/api_client.dart';
import 'package:health_care_app/core/api/endpoints.dart';
import 'package:health_care_app/patient_features/add_review/presentation/cubit/add_review_state.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  final ApiClient apiClient;
  final String authToken;

  AddReviewCubit({
    required this.apiClient,
    required this.authToken,
  }) : super(AddReviewInitial());

  Future<void> addReview({
    required int doctorId,
    required String doctorName,
    required int patientId,
    required String patientName,
    required String comment,
    required double rating,
  }) async {
    emit(AddReviewLoading());
    try {
      final response = await apiClient.post(
        PatientApiConstants.addReview,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {
          "doctorId": doctorId,
          "doctorName": doctorName,
          "patientId": patientId,
          "patientName": patientName,
          "comment": comment,
          "rating": rating,
          "createdAt": DateTime.now().toIso8601String(),
        },
      );

      if (response != null) {
        emit(const AddReviewSuccess("Review added successfully"));
      } else {
        emit(const AddReviewError("Failed to add review"));
      }
    } catch (error) {
      emit(AddReviewError(error.toString()));
    }
  }
}
