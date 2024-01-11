import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/cubit/Profile/profile_cubit.dart';
import 'package:joosecustomer/localization/app_localization.dart';
import 'package:joosecustomer/models/userdata_class.dart';
import 'package:joosecustomer/repository/userprofileRepo.dart';
import 'package:joosecustomer/utils/user_manager.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:joosecustomer/widgets/notification_icon.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'notification_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  GlobalKey<ScaffoldState>? _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  var CurrentPassword_Controller = TextEditingController();
  var NewPassword_Controller = TextEditingController();
  var ConfirmPassword_Controller = TextEditingController();

    bool   isLoading=false;

  late ProfileCubit profileCubit;
  User? user;


  @override
  void initState() {
    profileCubit = ProfileCubit(UserprofileRepository());
    Notification_Icon();
    super.initState();
    profileCubit.UserProfileloading();
  }

  @override
  void dispose() {
    CurrentPassword_Controller.dispose();
    NewPassword_Controller.dispose();
    ConfirmPassword_Controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  const drowerAfterlogin(),
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.yellow.shade700,
      body: BlocProvider(
        create: (context) => profileCubit,
        child: BlocListener<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {
            if (state is DashbordMyProfileLoading) {
            } else if (state is DashbordMyProfileSuccessFull) {
              user = state.user;
              print("user loadded");
            }
            else if (state is DashbordMyProfileFail) {
              Utils.showDialouge(
                  context, AlertType.error, "No data", state.error);
            }
            else if (state is DashbordchangePasswordLoading) {
            } else if (state is DashbordchangePasswordSuccessFull) {

              Fluttertoast.showToast(
                  msg:   AppLocalizations.of(context).translate("Password change successfully!"),
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => Login(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );


            } else if (state is DashbordchangePasswordFail) {

              Utils.showDialouge(context,AlertType.error,
                 "Oop!",state.message);

              // state.message.contains("successfully")? Fluttertoast.showToast(
              //     msg: "Password Changing is Succesfull",
              //     toastLength: Toast.LENGTH_SHORT,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.green.shade600,
              //     textColor: Colors.white,
              //     fontSize: 16.0):null;
              //
              // state.message.contains("successfully")?  Navigator.pushReplacement(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (c, a1, a2) => Login(),
              //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
              //       var begin = Offset(1.0, 0.0);
              //       var end = Offset.zero;
              //       var tween = Tween(begin: begin, end: end);
              //       var offsetAnimation = animation.drive(tween);
              //       return SlideTransition(
              //         position: offsetAnimation,
              //         child: child,
              //       );
              //     },
              //     transitionDuration: Duration(milliseconds: 500),
              //   ),
              // ):null;

            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is DashbordMyProfileLoading) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children:  [
                        SizedBox(
                          height: MediaQuery.of(context).size.height *0.45,
                        ),
                        const Center(
                          child: CupertinoActivityIndicator(
                            radius: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is DashbordMyProfileSuccessFull) {
                  return profileform();
                }
                else if (state is DashbordMyProfileFail) {
                  return Container();
                }
                else if (state is DashbordchangePasswordLoading) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children:  [
                        SizedBox(
                          height: MediaQuery.of(context).size.height *0.45,
                        ),
                        const Center(
                          child: CupertinoActivityIndicator(
                            radius: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else if (state is DashbordchangePasswordSuccessFull) {
                  return profileform();
                } else if (state is DashbordchangePasswordFail) {
                  return  profileform();
                }
                else {
                  return Container(
                    // color: Colors.white,
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget profileform(){
    var tempDate = user?.dob==null? "0000-00-00 00:00:00" : user?.dob;
    var correct = DateUtil().formattedDate(DateTime.parse(tempDate.toString()));
    return  Column(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15,top: 30),
                    child: IconButton(onPressed: (){
                      _key!.currentState!.openDrawer();

                    },  icon: Icon(Icons.menu_rounded,size: 30,color: Colors.white,),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15,top: 30),
                    child: GestureDetector(
                        onTap: (){

                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder: (c, a1, a2) =>  Notification_page(),
                          //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          //       var begin = Offset(1.0, 0.0);
                          //       var end = Offset.zero;
                          //       var tween = Tween(begin: begin, end: end);
                          //       var offsetAnimation = animation.drive(tween);
                          //       return SlideTransition(
                          //         position: offsetAnimation,
                          //         child: child,
                          //       );
                          //     },
                          //     transitionDuration: Duration(milliseconds: 500),
                          //   ),
                          // );

                        },
                        child: Notification_Icon()),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 67,left: 40),
                    child: JooseText(
                      text: AppLocalizations.of(context).translate("Profile"),
                      fontColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),



                  Padding(
                    padding: EdgeInsets.only(right: 25),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipOval(
                        child: user?.profilepictureurl == "https://jooserewards.com/joose/public/images"
                            ? JooseText(
                          text: "${user?.name?[0]??""}".toUpperCase(),
                          fontColor: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        )
                            : Image.network(
                          "${user?.profilepictureurl??""}",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          height: 190.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.yellow.shade600,
              image: const DecorationImage(
                  image: AssetImage("assets/images/appBarimg.png"),
                  fit: BoxFit.fill
              ),
              boxShadow: const [
                BoxShadow(color: Colors.yellow,spreadRadius: 0.5,blurRadius: 59)
              ]
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top:30),
            decoration:  const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40),),color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0),),
                        image: const DecorationImage(
                            image: AssetImage("assets/images/profile_img.jpeg"),
                            fit: BoxFit.cover
                        ),
                        color: Colors.redAccent.shade700,boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), //color of shadow
                        spreadRadius: 2, //spread radius
                        blurRadius: 2, // blur radius
                        offset: const Offset(0, 1.0),
                      ) ]),


                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: JooseText(
                            text: "${user?.name??""}",
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: JooseText(
                            text: "${user?.email??""}",
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: JooseText(
                            text: "${user?.phone??""}",
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: JooseText(
                            text:correct=="11/30/1"?"":correct,
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ),



                Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration:
                    BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20.0), bottomLeft: Radius.circular(20.0),),
                        color: Colors.white,boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), //color of shadow
                        spreadRadius: 2, //spread radius
                        blurRadius: 2, // blur radius
                        offset: const Offset(0, 1.0),
                      ) ]),


                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:   [

                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                          child: ListTile(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => EditProfilePage(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var begin = Offset(1.0, 0.0);
                                      var end = Offset.zero;
                                      var tween = Tween(begin: begin, end: end);
                                      var offsetAnimation = animation.drive(tween);
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(milliseconds: 500),
                                  ),
                                );
                              },
                              leading: JooseText(
                                text: AppLocalizations.of(context).translate("Edit Profile"),
                                fontColor: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              trailing: Image.asset("assets/images/edit-solid.png",
                                height: 20,
                                width: 20,
                                color: Colors.black,
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: ListTile(
                              onTap: (){


                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                    backgroundColor: Colors.amber.shade700,
                                    content: Container(
                                      // decoration: BoxDecoration(
                                      //     image: DecorationImage(
                                      //         image: AssetImage("assets/images/profile2.jpeg"),
                                      //         fit: BoxFit.cover
                                      //     ),
                                      // ),
                                      height: 350,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(child: SizedBox()),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Icon(
                                                    Icons.clear_outlined,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15), //border corner radius
                                                boxShadow:[
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5), //color of shadow
                                                    spreadRadius: 2, //spread radius
                                                    blurRadius: 3, // blur radius
                                                    offset: Offset(0, 2), // changes position of shadow
                                                    //first paramerter of offset is left-right
                                                    //second parameter is top to down
                                                  ),
                                                  //you can set more BoxShadow() here
                                                ],
                                              ),
                                              margin: EdgeInsets.only(top: 10),
                                              child: TextFormField(
                                                controller: CurrentPassword_Controller,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Please enter your current password";
                                                  }
                                                },
                                                style: TextStyle(color: Colors.black),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: AppLocalizations.of(context).translate('Current Password'),
                                                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding: const EdgeInsets.only(
                                                      left: 14.0, bottom: 6.0, top: 8.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: HexColor("28292C")),
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15), //border corner radius
                                                boxShadow:[
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5), //color of shadow
                                                    spreadRadius: 2, //spread radius
                                                    blurRadius: 3, // blur radius
                                                    offset: Offset(0, 2), // changes position of shadow
                                                    //first paramerter of offset is left-right
                                                    //second parameter is top to down
                                                  ),
                                                  //you can set more BoxShadow() here
                                                ],
                                              ),
                                              margin: EdgeInsets.only(top: 8),
                                              child: TextFormField(
                                                controller: NewPassword_Controller,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Please enter your new password";
                                                  }
                                                },
                                                style: TextStyle(color: Colors.black),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: AppLocalizations.of(context).translate("New Password"),
                                                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding: const EdgeInsets.only(
                                                      left: 14.0, bottom: 6.0, top: 8.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: HexColor("28292C")),
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15), //border corner radius
                                                boxShadow:[
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5), //color of shadow
                                                    spreadRadius: 2, //spread radius
                                                    blurRadius: 3, // blur radius
                                                    offset: Offset(0, 2), // changes position of shadow
                                                    //first paramerter of offset is left-right
                                                    //second parameter is top to down
                                                  ),
                                                  //you can set more BoxShadow() here
                                                ],
                                              ),
                                              margin: EdgeInsets.only(top: 8),
                                              child: TextFormField(
                                                controller: ConfirmPassword_Controller,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Please enter confirm password";
                                                  }
                                                },
                                                style: TextStyle(color: Colors.black),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: AppLocalizations.of(context).translate( "Confirm Password"),
                                                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding: const EdgeInsets.only(
                                                      left: 14.0, bottom: 6.0, top: 8.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: HexColor("28292C")),
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                ),
                                              ),
                                            ),



                                            Padding(
                                              padding: const EdgeInsets.only(top: 30),
                                              child: InkWell(
                                                splashColor: Color.fromARGB(255,255,111,0),
                                                highlightColor: Colors.white,
                                                focusColor: Colors.white,
                                                onTap: ()async{
                                                  if (_formKey.currentState!.validate()) {

                                                    profileCubit.PasswordChange(
                                                        CurrentPassword_Controller.text,
                                                        NewPassword_Controller.text,
                                                        ConfirmPassword_Controller.text);

                                                    Navigator.pop(context);
                                                  }

                                                },
                                                child: Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    gradient: const LinearGradient(
                                                        colors: [

                                                          Color.fromARGB(255,255,111,0),
                                                          Color.fromARGB(255,247,79,15),
                                                          Color.fromARGB(255,247,79,15),
                                                          Color.fromARGB(255,232,22,43)
                                                          //add more colors for gradient
                                                        ],
                                                        begin: Alignment.topLeft, //begin of the gradient color
                                                        end: Alignment.bottomRight, //end of the gradient color
                                                        stops: [0, 0.2, 0.5, 0.8] //stops for individual color
                                                      //set the stops number equal to numbers of color
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: isLoading ? const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),) :  JooseText(
                                                      text: AppLocalizations.of(context).translate("Change Password"),
                                                      fontColor: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );



                              },
                              leading: JooseText(
                                text: AppLocalizations.of(context).translate("Change Password"),
                                fontColor: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              trailing: Image.asset("assets/images/key-solid.png",
                                height: 20,
                                width: 20,
                                color: Colors.black,
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: ListTile(
                              onTap: ()async{

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.white70, width: 1),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    title: JooseText(text: AppLocalizations.of(context).translate("Logout"),fontColor: Colors.black,fontWeight: FontWeight.w600,fontSize: 18,),
                                    titlePadding: EdgeInsets.only(right: 150,top: 20),
                                    content: JooseText(text: AppLocalizations.of(context).translate("Are you sure want to logout?"),fontSize: 14, ),
                                    actions: [
                                      TextButton(onPressed: ()async{
                                        UserManager.instance.logOutUser();
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) => Login(),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              var begin = Offset(1.0, 0.0);
                                              var end = Offset.zero;
                                              var tween = Tween(begin: begin, end: end);
                                              var offsetAnimation = animation.drive(tween);
                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                            transitionDuration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }, child: JooseText(text: AppLocalizations.of(context).translate("Logout"),fontColor: Colors.redAccent.shade400,fontWeight: FontWeight.w600,)),
                                      TextButton(onPressed: (){Navigator.pop(context);}, child: JooseText(text: AppLocalizations.of(context).translate("cl"),fontColor: Colors.black,fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                );
                              },
                              leading: JooseText(
                                text: AppLocalizations.of(context).translate("Logout"),
                                fontColor: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              trailing: Image.asset("assets/images/sign-out-solid.png",
                                height: 20,
                                width: 20,
                                color: Colors.black,
                              )
                          ),
                        ),
                      ],
                    )
                ),

              ],
            ),
          ),
        )
      ],
    );
  }

}

class DateUtil {
  String formattedDate(DateTime dateTime) {
    return DateFormat.yMd ().format (dateTime);
  }
}
























