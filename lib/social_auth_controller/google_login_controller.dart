// ignore_for_file: camel_case_types

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joosecustomer/networking/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GoogleSignInController{

  var _googleSignIn =  GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  String? token;

  Future<void> signIn(BuildContext context) async{

    try{
      this.googleAccount = await _googleSignIn.signIn();
      final result = await this.googleAccount?.authentication;
      print(result?.idToken);
      print("*ACCESS**TOKEN**GOOGLE*"+result!.accessToken.toString());
      SharedPreferences preferences= await SharedPreferences.getInstance();
      preferences.setString('GoogleToken', result.accessToken.toString());

      print("*ACCESS**TOKEN**GOOGLE**2**"+ preferences.getString('GoogleToken').toString());

      token = preferences.getString('GoogleToken');
    } on SocketException {
      Fluttertoast.showToast(
          msg: "No internet connection",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);

      print('No net');
      throw FetchDataException('No Internet connection');
    }
  }
}
