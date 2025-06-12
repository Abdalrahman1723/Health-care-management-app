abstract class PredictionState {}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionLoaded extends PredictionState {
  final String predictedDisease;
  final String description;
  final List<String> precautions;
  final List<String> medications;
  final List<String> diets;
  final List<String> workouts;

  PredictionLoaded({
    required this.predictedDisease,
    required this.description,
    required this.precautions,
    required this.medications,
    required this.diets,
    required this.workouts,
  });
}

class PredictionError extends PredictionState {
  final String message;

  PredictionError(this.message);
}
