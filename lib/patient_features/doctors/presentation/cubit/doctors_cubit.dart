import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repo.dart';

// --- States ---
abstract class DoctorsState extends Equatable {
  const DoctorsState();
  @override
  List<Object?> get props => [];
}

class DoctorsInitial extends DoctorsState {}
class DoctorsLoading extends DoctorsState {}
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

// --- Cubit ---
class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this.repo) : super(DoctorsInitial());
  final Repo repo;

  void fetchDoctorsData() async {
    emit(DoctorsLoading());
    final response = await repo.fetchDoctorsData();
    response.fold(
      (failure) => emit(DoctorsFailure(errMessage: failure.errMessage)),
      (entities) => emit(DoctorsSuccess(entities: entities)),
    );
  }
} 