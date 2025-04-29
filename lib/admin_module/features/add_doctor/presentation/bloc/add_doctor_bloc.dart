import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_doctor_event.dart';
part 'add_doctor_state.dart';

class AddDoctorBloc extends Bloc<AddDoctorEvent, AddDoctorState> {
  AddDoctorBloc() : super(AddDoctorInitial()) {
    on<AddDoctorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
