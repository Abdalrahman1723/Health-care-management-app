import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/api_client.dart';
import 'prediction_state.dart';

class PredictionCubit extends Cubit<PredictionState> {
  final ApiClient apiClient;

  PredictionCubit({
    required this.apiClient,
  }) : super(PredictionInitial());

  String _formatSymptom(String symptom) {
    // Convert camelCase to snake_case
    return symptom
        .replaceAllMapped(
            RegExp(r'([A-Z])'), (Match m) => '_${m[1]!.toLowerCase()}')
        .toLowerCase();
  }

  List<String> _parseList(dynamic value) {
    if (value is List) {
      if (value.isNotEmpty && value[0] is String && value[0].startsWith('[')) {
        // Handle string representation of list
        final str = value[0].toString();
        return str
            .substring(1, str.length - 1)
            .split(',')
            .map((e) => e.trim().replaceAll("'", ""))
            .toList();
      }
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<void> getPrediction(List<String> symptoms) async {
    try {
      emit(PredictionLoading());

      // Format symptoms to snake_case
      final formattedSymptoms = symptoms.map(_formatSymptom).toList();

      log("Sending symptoms: $formattedSymptoms");

      final response = await apiClient.post(
        '',
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'symptoms': formattedSymptoms,
        },
      );

      log("Prediction response: $response");

      emit(PredictionLoaded(
        predictedDisease: response['predicted_disease'] as String,
        description: response['description'] as String,
        precautions: _parseList(response['precautions']),
        medications: _parseList(response['medications']),
        diets: _parseList(response['diets']),
        workouts: _parseList(response['workouts']),
      ));
    } catch (e) {
      log("Prediction error: $e");
      emit(PredictionError(e.toString()));
    }
  }
}
