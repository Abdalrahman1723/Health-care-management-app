part of 'patient_cubit.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final PatientEntity patient;

  const PatientLoaded(this.patient);

  @override
  List<Object> get props => [patient];
}

class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object> get props => [message];
}

// Appointment States
class AppointmentsLoading extends PatientState {}

class AppointmentsLoaded extends PatientState {
  final List<AppointmentEntity> appointments;

  const AppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

class AppointmentsError extends PatientState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object> get props => [message];
}
