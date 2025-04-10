import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_main_page_event.dart';
part 'admin_main_page_state.dart';

class AdminMainPageBloc extends Bloc<AdminMainPageEvent, AdminMainPageState> {
  AdminMainPageBloc() : super(AdminMainPageInitial()) {
    on<AdminMainPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
