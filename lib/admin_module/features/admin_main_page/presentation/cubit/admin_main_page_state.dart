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

//-----------------the admin stats-------------------//
class AdminStatsLoaded extends AdminMainPageState {
  final AdminStatus stats;

  const AdminStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class AdminStatsLoading extends AdminMainPageState {}

class AdminStatsError extends AdminMainPageState {
  final String message;

  const AdminStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

//-----------------the feedback states-------------------//
class FeedbackLoading extends AdminMainPageState {}

class FeedbackLoaded extends AdminMainPageState {
  final List<Map<String, dynamic>> feedbackList;

  const FeedbackLoaded(this.feedbackList);

  @override
  List<Object?> get props => [feedbackList];
}

class FeedbackError extends AdminMainPageState {
  final String message;

  const FeedbackError(this.message);

  @override
  List<Object?> get props => [message];
}
