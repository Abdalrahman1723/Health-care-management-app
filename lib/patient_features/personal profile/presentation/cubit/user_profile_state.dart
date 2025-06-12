import 'package:equatable/equatable.dart';
import 'package:health_care_app/global/entities/patient.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends UserProfileState {}

class ProfileLoading extends UserProfileState {}

class ProfileLoaded extends UserProfileState {
  final PatientEntity userData;

  const ProfileLoaded(this.userData);

  @override
  List<Object> get props => [userData];
}

class ProfileError extends UserProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
