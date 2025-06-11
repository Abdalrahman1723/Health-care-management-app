part of 'admin_main_page_cubit.dart';

abstract class AdminMainPageState extends Equatable {
  const AdminMainPageState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminMainPageState {}

class AdminLoading extends AdminMainPageState {}

class AdminLoaded extends AdminMainPageState {
  final List<dynamic> doctors;

  const AdminLoaded({
    required this.doctors,
  });

  @override
  List<Object?> get props => [doctors];
}

class AdminError extends AdminMainPageState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}

class DoctorsLoading extends AdminMainPageState {}

class DoctorsLoaded extends AdminMainPageState {
  final List<DoctorEntity> doctors;

  const DoctorsLoaded(this.doctors);

  @override
  List<Object?> get props => [doctors];
}

class DoctorsError extends AdminMainPageState {
  final String message;

  const DoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}
