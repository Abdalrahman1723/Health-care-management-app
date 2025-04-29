import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_review_event.dart';
part 'add_review_state.dart';

class AddReviewBloc extends Bloc<AddReviewEvent, AddReviewState> {
  AddReviewBloc() : super(AddReviewInitial()) {
    on<AddReviewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
