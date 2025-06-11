// features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/endpoints.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiClient apiClient;
  String? _currentToken;

  AuthCubit({required this.apiClient}) : super(AuthInitial());

  // Existing login method
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await apiClient.post(
        PatientApiConstants.login,
        body: {'email': email, 'password': password},
      );

      _currentToken = response['token'];
      emit(AuthAuthenticated(_currentToken!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // NEW: Method to set token directly for testing
  void setTokenDirectly(String token) {
    _currentToken = token;
    emit(AuthAuthenticated(token));
  }

  String? get currentToken => _currentToken;

  void logout() {
    _currentToken = null;
    emit(AuthUnauthenticated());
  }
}
