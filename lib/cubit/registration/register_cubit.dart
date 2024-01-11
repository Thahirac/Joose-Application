import 'package:bloc/bloc.dart';
import 'package:joosecustomer/models/userdata_class.dart';
import 'package:joosecustomer/repository/RegistrationRepository.dart';
import 'package:joosecustomer/utils/user_manager.dart';
import 'package:result_type/result_type.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {

  final RegistrationRepository registrationRepository;
  RegisterCubit(this.registrationRepository) : super(RegisterInitial());



  Future<void> authenticateUser(String? username, String? email,String? password, String password_confirmation) async {
    emit(RegistrationLoading());
    Result? result = await registrationRepository.registerUser(
        username, email,password, password_confirmation);

    if (result.isSuccess) {
      emit(RegistrationLoginSuccessFull());
    } else {
      emit(RegistrationFailed(result.failure));
    }
  }


  Future<void> socialauthenticateUser(String? token, String? provider) async {
    emit(RegistrationLoading());
    Result? result = await registrationRepository.socialauthenticateUser(token, provider);

    if (result.isSuccess) {
      UserSession userSession = UserSession.fromJson(result.success);
      UserManager.instance.setUserSession(userSession);
      emit(RegistrationSuccessFull(userSession));
    }
    else {
      emit(RegistrationFailed(result.failure));
    }
  }


}

