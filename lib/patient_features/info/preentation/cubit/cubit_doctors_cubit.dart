// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../domain/entity.dart';
// import '../../domain/repo.dart';
//
//
// part 'cubit_doctor_state.dart';
//
// class DoctorsCubit extends Cubit<DoctorsState> {
//   DoctorsCubit(this.repo) : super(DoctorsInitial());
//   final Repo repo;
//
//   void fetchDoctorsData() async {
//     emit(DoctorsLoading());
//     final response = await repo.fetchDoctorsData();
//     response.fold(
//           (failure) => emit(DoctorsFailure(errMessage: failure.errMessage)),
//           (entities) => emit(DoctorsSuccess(entities: entities)),
//     );
//   }
//
//
// }
