import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joosecustomer/models/userdata_class.dart';
import 'package:joosecustomer/repository/userprofileRepo.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {


  ProfileCubit(this.profileRepository) : super(DashbordInitial());
  final UserprofileRepository profileRepository;

  Future<void> UserProfileloading() async {
    emit(DashbordMyProfileLoading());
    Result? result = await profileRepository.UserProfile();
    if (result.isSuccess) {
      User user = User(
        id: result.success["id"],
        name: result.success["name"],
        email: result.success["email"],
        phone: result.success["phone"],
        dob: DateTime.parse(result.success["dob"]??"0000-00-00 00:00:00"),
        profilePicture: result.success["profile_picture"],
        profilepictureurl: result.success["profile_picture_url"],
      );

      emit(DashbordMyProfileSuccessFull(user));
    } else {
      emit(DashbordMyProfileFail(result.failure));
    }
  }


  Future<void> UserProfileupdate(String name, String address, String phone,
      String zip, String city, String country,String dob,String contact_person,String coc,String vat_number) async {
    emit(ProfileupdateLoading());
    Result? result = await profileRepository.UserProfileUpdate(
        name, address, phone, zip, city, country,dob,contact_person,coc,vat_number);
    if (result.isSuccess) {
      User user = User(
        id: result.success["id"],
        name: result.success["name"],
        email: result.success["email"],
        phone: result.success["phone"],
        dob: DateTime.parse(result.success["dob"]??"0000-00-00 00:00:00"),
        profilePicture: result.success["profile_picture"],
      );

      emit(ProfileupdateSuccessFull(user));
    } else {
      emit(ProfileupdateFail(result.failure));
    }
  }


  Future<void> PasswordChange(String old_password, String password,
      String password_confirmation) async {
    emit(DashbordchangePasswordLoading());
    Result? result = await profileRepository.ChangePassWord(
        old_password, password, password_confirmation);
    if (result.isSuccess) {
      emit(DashbordchangePasswordSuccessFull(result.success));
    } else {
      emit(DashbordchangePasswordFail(result.failure));
    }
  }





}
