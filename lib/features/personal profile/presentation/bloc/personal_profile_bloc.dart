import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'personal_profile_event.dart';
part 'personal_profile_state.dart';

class PersonalProfileBloc extends Bloc<PersonalProfileEvent, PersonalProfileState> {
  PersonalProfileBloc() : super(PersonalProfileInitial()) {
    on<PersonalProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
