import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/cubit/Profile/profile_cubit.dart';
import 'package:joosecustomer/localization/app_localization.dart';
import 'package:joosecustomer/models/userdata_class.dart';
import 'package:joosecustomer/networking/app_exception.dart';
import 'package:joosecustomer/pages/profile_page.dart';
import 'package:joosecustomer/repository/userprofileRepo.dart';
import 'package:joosecustomer/utils/user_manager.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:joosecustomer/widgets/notification_icon.dart';
import 'notification_list_page.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  GlobalKey<ScaffoldState>? _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _mobnum;
  String? _dob;
  var tempDate;
  bool isLoading = false;
  XFile? _image;
  late ProfileCubit profileCubit;
  User? user;

  String? birthDateInString;
  DateTime? birthDate;
  bool isDateSelected = false;

  set imageFile(XFile? value) {
    _image = value == null ? null : value;
  }

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _image = XFile(image.path);
        print(" this is path $_image");
        print(_image?.path);
      });
    } on PlatformException catch (e) {
      print('failed : $e');
    }
  }


  Future<void> updateprofile() async {
    try {
      var token = await UserManager.instance.getToken();
      var request = http.MultipartRequest('POST',
          Uri.parse('https://jooserewards.com/joose/public/api/updateprofile'));
      request.fields.addAll({
        "name":
            _username == null ? user!.name.toString() : _username.toString(),
        "phone": _mobnum == null ? user!.phone.toString() : _mobnum.toString(),
        "dob": birthDateInString == null ? user!.dob.toString() : "${birthDate!.year}-${birthDate!.month}-${birthDate!.day} 00:00:00",
      });
      _image?.path == null
          ? null
          : request.files.add(await http.MultipartFile.fromPath(
              'profile_picture', _image!.path));
      request.headers.addAll({'Authorization': 'Bearer $token'});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        String responsee = res.body.toString();
        var source = jsonDecode(res.body);
        // url = source['data']['url'];
        // print("******************web****url*******"+url.toString());
        print("edit prof res......888888.....*...$responsee");

        setState(() {
          isLoading = true;
        });

        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("Profile update Successfully!"),
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 2,
            fontSize: 16.0);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => ProfilePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
      } else {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("please fill date of birth field"),
            backgroundColor: Colors.amber,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 2,
            fontSize: 16.0);
        print(response.reasonPhrase);

        setState(() {
          isLoading = false;
        });
      }
    } on SocketException {
      Fluttertoast.showToast(
          msg: "No internet connection",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
    throw FetchDataException('No Internet connection');
  }

  @override
  void initState() {
    profileCubit = ProfileCubit(UserprofileRepository());
    Notification_Icon();
    super.initState();
    profileCubit.UserProfileloading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const drowerAfterlogin(),
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
            } else if (state is DashbordMyProfileFail) {
              Utils.showDialouge(
                  context, AlertType.error, "No data", state.error);
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
            if (state is DashbordMyProfileLoading) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
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
              return editprofileform();
            } else if (state is DashbordMyProfileFail) {
              return Container();
            } else {
              return Container(
                  // color: Colors.white,
                  );
            }
          }),
        ),
      ),
    );
  }

  Widget editprofileform() {
    var tempDate = user?.dob == null ? "0000-00-00 00:00:00" : user?.dob;
    var correct = DateUtil().formattedDate(DateTime.parse(tempDate.toString()));
    return Column(
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
                    padding: const EdgeInsets.only(right: 15, top: 30),
                    child: IconButton(
                      onPressed: () {
                        _key!.currentState!.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 30),
                    child: GestureDetector(
                        onTap: () {
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
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 67, left: 40),
                    child: JooseText(
                      text: AppLocalizations.of(context).translate("Edit Profile"),
                      fontColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  // Stack(
                  //   children:  [
                  //     const Padding(
                  //       padding: EdgeInsets.only(right: 20),
                  //       child: CircleAvatar(
                  //         backgroundImage: AssetImage("assets/images/image.jpeg"),
                  //         radius: 30.0,
                  //       ),
                  //     ),
                  //     Positioned(
                  //       top: 37,left: 40,
                  //         child: Container(
                  //       height: 22,
                  //       width: 22,
                  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.white,),
                  //       child: Center(
                  //         child: Image.asset("assets/images/camera.png",
                  //           height: 20,
                  //           width: 20,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Stack(
                      children: [
                        _image == null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade400,
                                child: ClipOval(
                                  child: user?.profilepictureurl ==
                                          "https://jooserewards.com/joose/public/images"
                                      ? Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                          size: 55,
                                        )
                                      : Image.network(
                                          "${user?.profilepictureurl}",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              )

                            // Container(
                            //   height: 80,
                            //   width: 80,
                            //   decoration: BoxDecoration(
                            //       color: Colors.grey.shade500,
                            //       shape: BoxShape.circle),
                            //   child: data.userdatalist?['user']['profile_picture_url'] == null
                            //       ? Icon(
                            //     Icons.account_circle,
                            //     color: Colors.white,
                            //     size: 55,
                            //   )
                            //       : Image.network("${data.userdatalist?['user']['profile_picture_url']}",fit: BoxFit.cover,),
                            // )

                            : Container(
                                padding: EdgeInsets.all(20),
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(_image!.path)),
                                    ),
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => pickImage(),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              height: 23,
                              width: 23,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle),
                              child: FittedBox(
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/camera.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
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
                  fit: BoxFit.fill),
              boxShadow: const [
                BoxShadow(
                    color: Colors.yellow, spreadRadius: 0.5, blurRadius: 59)
              ]),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 30),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                color: Colors.white),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: Row(
                      children: [
                        Container(
                          child:  JooseText(
                            text: AppLocalizations.of(context).translate("Full Name"),
                            fontColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15), //border corner radius
                      boxShadow: [
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
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: TextFormField(
                      initialValue: user?.name ?? "",
                      onChanged: (val) {
                        _username = val;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                        filled: true,
                        hintText: AppLocalizations.of(context).translate("Enter your name"),
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
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: Row(
                      children: [
                        Container(
                          child:  JooseText(
                            text: AppLocalizations.of(context).translate("Mobile Number"),
                            fontColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15), //border corner radius
                      boxShadow: [
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
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: TextFormField(
                      initialValue: user?.phone ?? "",
                      onChanged: (val) {
                        _mobnum = val;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your mobile number";
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                        filled: true,
                        hintText: AppLocalizations.of(context).translate("Enter your mobile number"),
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

                  // Container(
                  //   margin: EdgeInsets.only(left: 30,top: 10),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         child: const JooseText(
                  //           text: "Date of Birth",
                  //           fontColor: Colors.black,
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(15), //border corner radius
                  //     boxShadow:[
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.5), //color of shadow
                  //         spreadRadius: 2, //spread radius
                  //         blurRadius: 3, // blur radius
                  //         offset: Offset(0, 2), // changes position of shadow
                  //         //first paramerter of offset is left-right
                  //         //second parameter is top to down
                  //       ),
                  //       //you can set more BoxShadow() here
                  //     ],
                  //   ),
                  //   margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                  //   child: TextFormField(
                  //     initialValue: correct,
                  //     onChanged: (val) {
                  //       _dob = val;
                  //     },
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return "Please enter your date of birth";
                  //       }
                  //     },
                  //     keyboardType: TextInputType.datetime,
                  //     style: TextStyle(color: Colors.black),
                  //     decoration: InputDecoration(
                  //       border: InputBorder.none,
                  //       hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  //       filled: true,
                  //       hintText: "yyyy-mm-dd",
                  //       fillColor: Colors.white,
                  //       contentPadding: const EdgeInsets.only(
                  //           left: 14.0, bottom: 6.0, top: 8.0),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: HexColor("28292C")),
                  //         borderRadius: BorderRadius.circular(15.0),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.white),
                  //         borderRadius: BorderRadius.circular(15.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Container(
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: Row(
                      children: [
                        Container(
                          child: JooseText(
                            text: AppLocalizations.of(context).translate("Date of Birth"),
                            fontColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate:  DateTime.now(),
                          firstDate:  DateTime(1900),
                          lastDate:  DateTime.now(),
                      );
                      if (datePick != null && datePick != birthDate) {
                        setState(() {
                          birthDate = datePick;
                          isDateSelected = true;

                          // put it here
                          birthDateInString = "${birthDate!.month}/${birthDate!.day}/${birthDate!.year}"; // 08/14/2019
                        });
                      }
                    },
                    child: Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 30, right: 30, top: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(15), //border corner radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), //color of shadow
                              spreadRadius: 2, //spread radius
                              blurRadius: 3, // blur radius
                              offset:
                                  Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            birthDateInString == null
                                ? JooseText(
                                    text: correct=="11/30/1"? "" : "${correct}",
                                    fontColor: Colors.black,
                                    fontSize: 16,
                                  )
                                : JooseText(
                                    text: "${birthDateInString}",
                                    fontColor: Colors.black,
                                    fontSize: 16,
                                  ),

                            Expanded(child: SizedBox()),
                            Icon(Icons.date_range_rounded,),
                            SizedBox(
                              width: 15,
                            ),

                          ],
                        )),
                  ),



                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: InkWell(
                      splashColor: Color.fromARGB(255, 255, 111, 0),
                      highlightColor: Colors.white,
                      focusColor: Colors.white,
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (_formKey.currentState!.validate() && user?.dob!=null) {
                          updateprofile();
                        } else {

                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context).translate("please fill date of birth field"),
                              backgroundColor: Colors.amber,
                              textColor: Colors.black,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 2,
                              fontSize: 16.0);


                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 111, 0),
                                Color.fromARGB(255, 247, 79, 15),
                                Color.fromARGB(255, 247, 79, 15),
                                Color.fromARGB(255, 232, 22, 43)
                                //add more colors for gradient
                              ],
                              begin: Alignment
                                  .topLeft, //begin of the gradient color
                              end: Alignment
                                  .bottomRight, //end of the gradient color
                              stops: [
                                0,
                                0.2,
                                0.5,
                                0.8
                              ] //stops for individual color
                              //set the stops number equal to numbers of color
                              ),
                        ),
                        child: Center(
                          child: isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: Colors.white,
                                      )),
                                )
                              :  JooseText(
                                  text: AppLocalizations.of(context).translate("Save Changes"),
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
        )
      ],
    );
  }
}

class DateUtil {
  String formattedDate(DateTime dateTime) {
    return DateFormat.yMd().format(dateTime);
  }
}
