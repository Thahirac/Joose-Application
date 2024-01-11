import 'package:bloc/bloc.dart';
import 'package:joosecustomer/repository/authenticationRepo.dart';
import 'package:joosecustomer/utils/user_manager.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

//after push
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(AuthenticationState state, this.authRepository)
      : super(AuthenticationIntial());
  final AuthenticationRepository authRepository;

  Future<void> getAuthenticationState() async {
    bool isUserLoggedIn = await UserManager.instance.isUserAlreadyLoggedIn();
    String token = await authRepository.getToken();
    if (isUserLoggedIn && token != null) {
      emit(Authenticated(token));
    } else {
      emit(UnAuthenticated());
    }
  }
}
