part of 'cubit_doctors_cubit.dart';



abstract class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object?> get props => [];
}

class DoctorsInitial extends DoctorsState {
  const DoctorsInitial();
}

class DoctorsLoading extends DoctorsState {
  const DoctorsLoading();
}

class DoctorsSuccess extends DoctorsState {
  final List<DoctorEntity> entities;

  const DoctorsSuccess({required this.entities});

  @override
  List<Object?> get props => [entities];
}

class DoctorsFailure extends DoctorsState {
  final String errMessage;

  const DoctorsFailure({required this.errMessage});

  @override
  List<Object?> get props => [errMessage];
}
