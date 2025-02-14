part of 'app_settings_bloc.dart';

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();  

  @override
  List<Object> get props => [];
}
class AppSettingsInitial extends AppSettingsState {}
