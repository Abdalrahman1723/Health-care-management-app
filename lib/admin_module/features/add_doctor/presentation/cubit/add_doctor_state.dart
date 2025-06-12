part of 'add_doctor_cubit.dart';

abstract class AddDoctorState extends Equatable {
  const AddDoctorState();

  @override
  List<Object?> get props => [];
}

class AddDoctorInitial extends AddDoctorState {}

class AddDoctorLoading extends AddDoctorState {}

class AddDoctorSuccess extends AddDoctorState {
  final DoctorEntity doctor;

  const AddDoctorSuccess(this.doctor);

  @override
  List<Object?> get props => [doctor];
}

class AddDoctorError extends AddDoctorState {
  final String message;

  const AddDoctorError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddDoctorValidationError extends AddDoctorState {
  final Map<String, String> errors;

  const AddDoctorValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}
