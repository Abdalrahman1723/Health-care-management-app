part of 'patient_cubit.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientDoctorLoaded extends PatientState {
  final DoctorEntity doctor;

  const PatientDoctorLoaded(this.doctor);

  @override
  List<Object> get props => [doctor];
}

class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object> get props => [message];
}