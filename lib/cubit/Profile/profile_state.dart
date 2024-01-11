part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class DashbordInitial extends ProfileState {}

class DashbordLoading extends ProfileState {}


//my Profile
class DashbordMyProfileLoading extends ProfileState {}

class DashbordMyProfileSuccessFull extends ProfileState {
  final User? user;
  DashbordMyProfileSuccessFull(this.user);
}

class DashbordMyProfileFail extends ProfileState {
  final String error;
  DashbordMyProfileFail(this.error);
}


//Change Password
class DashbordchangePasswordLoading extends ProfileState {}

class DashbordchangePasswordSuccessFull extends ProfileState {
  final String message;

  DashbordchangePasswordSuccessFull(this.message);
}

class DashbordchangePasswordFail extends ProfileState {
  final String message;

  DashbordchangePasswordFail(this.message);
}

//Profile update
class ProfileupdateLoading extends ProfileState {}

class ProfileupdateSuccessFull extends ProfileState {
  final User? user;
  ProfileupdateSuccessFull(this.user);
}

class ProfileupdateFail extends ProfileState {
  final String message;

  ProfileupdateFail(this.message);
}