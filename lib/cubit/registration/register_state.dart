part of 'register_cubit.dart';

abstract class RegisterState {}

//Registration login
class RegisterInitial extends RegisterState {}

class RegistrationLoading extends RegisterState {}

class RegistrationLoginSuccessFull extends RegisterState {
  //save user data
  RegistrationLoginSuccessFull();
}


//Registration
class RegistrationSuccessFull extends RegisterState {
  //save user data
  final UserSession userSession;
  RegistrationSuccessFull(this.userSession);
}

class RegistrationFailed extends RegisterState {
  //show error
  final String msg;
  RegistrationFailed(this.msg);
}
