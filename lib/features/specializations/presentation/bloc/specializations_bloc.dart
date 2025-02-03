import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'specializations_event.dart';
part 'specializations_state.dart';

class SpecializationsBloc extends Bloc<SpecializationsEvent, SpecializationsState> {
  SpecializationsBloc() : super(SpecializationsInitial()) {
    on<SpecializationsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
