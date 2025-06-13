import 'package:equatable/equatable.dart';

abstract class AddReviewState extends Equatable {
  const AddReviewState();

  @override
  List<Object> get props => [];
}

class AddReviewInitial extends AddReviewState {}

class AddReviewLoading extends AddReviewState {}

class AddReviewSuccess extends AddReviewState {
  final String message;

  const AddReviewSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddReviewError extends AddReviewState {
  final String message;

  const AddReviewError(this.message);

  @override
  List<Object> get props => [message];
}
