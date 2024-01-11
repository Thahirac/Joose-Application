import 'package:joosecustomer/cubit/login/login_cubit.dart';
import 'package:joosecustomer/pages/registration_screen.dart';
import 'package:joosecustomer/repository/LoginRepository.dart';
import 'package:joosecustomer/social_auth_controller/google_login_controller.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dash_board.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgotpass_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isloading = false;
  bool _isloading2 = false;
  bool _isloading3 = false;

  var email_Controller = TextEditingController();
  var Password_Controller = TextEditingController();
  bool _isObscure = true;
  bool value = false;
  GlobalKey<ScaffoldState>? _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  DateTime? pre_backpress = DateTime.now();
  late LoginCubit loginCubit;
  @override
  void initState() {
    // TODO: implement initState
    loginCubit = LoginCubit(UserLoginRepository());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email_Controller.dispose();
    Password_Controller.dispose();
  }

  // Future signin(String email,String password) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final provider = Provider.of<RoomProvider>(context, listen: false);
  //   var credentials = {
  //     "email": email,
  //     "password": password,
  //   };
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       var response = await provider.login(credentials);
  //       var jsondata = jsonDecode(response.body);
  //       if (jsondata['status']==200) {
  //         //FlutterSecureStorage storage = FlutterSecureStorage();
  //         //  var readData=storage.write(key: "token", value: jsondata["data"]["token"]);
  //         //print(readData.toString()+"&&&&&&&&&&&&&&&&&&&&");
  //
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //        preferences.setString("token", jsondata["data"]["token"].toString());
  //
  //        print("#"+jsondata["data"]["token"].toString());
  //
  //         Fluttertoast.showToast(
  //             msg:"Login Successfully!",
  //             backgroundColor: Colors.green,
  //             textColor: Colors.white,
  //             toastLength: Toast.LENGTH_LONG,
  //             gravity: ToastGravity.SNACKBAR,
  //             timeInSecForIosWeb: 2,
  //             fontSize: 16.0
  //         );
  //         Future.delayed(Duration(seconds: 1))
  //             .then((value) =>
  //             Navigator.pushReplacement(
  //               context,
  //               PageRouteBuilder(
  //                 pageBuilder: (c, a1, a2) => Dashboard(),
  //                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //                   var begin = Offset(1.0, 0.0);
  //                   var end = Offset.zero;
  //                   var tween = Tween(begin: begin, end: end);
  //                   var offsetAnimation = animation.drive(tween);
  //                   return SlideTransition(
  //                     position: offsetAnimation,
  //                     child: child,
  //                   );
  //                 },
  //                 transitionDuration: Duration(milliseconds: 500),
  //               ),
  //             ),
  //         );
  //       }
  //       else
  //       {
  //
  //         Flushbar(
  //           backgroundColor: Colors.black,
  //           icon: const Icon(
  //             Icons.error_outline_rounded,
  //             color: Colors.red,
  //           ),
  //           message:  "${jsondata['message']}",
  //           messageColor: Colors.white,
  //           messageSize: 11,
  //           duration:  Duration(seconds: 3),
  //         ).show(context);
  //
  //         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         //   content: Row(
  //         //     children: [
  //         //       const Icon(
  //         //         Icons.error_outline_rounded,
  //         //         color: Colors.red,
  //         //       ),
  //         //       const SizedBox(
  //         //         width: 10,
  //         //       ),
  //         //       Text(
  //         //         "${jsondata['message']}",
  //         //         style: TextStyle(color: Colors.white,fontSize: 11,overflow: TextOverflow.clip),
  //         //       ),
  //         //     ],
  //         //   ),
  //         //   backgroundColor: Colors.black,
  //         // ));
  //
  //
  //         setState(() {
  //           isLoading = false;
  //         });
  //
  //       }
  //     } catch (e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
            create: (context) => loginCubit,
            child: BlocListener<LoginCubit, LoginState>(
              bloc: loginCubit,
              listener: (context, state) {
                if (state is LoginLoading) {}
                if (state is LoginSuccessFull) {

                  Fluttertoast.showToast(
                      msg: "Login Successfully!",
                      backgroundColor: Colors.green,
                      textColor: Colors.white);

                  setState(() {
                    _isloading = false;
                    _isloading2=false;
                  });

                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => Dashboard(),
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

                  // Navigator.push(context,
                  //   PageTransition(
                  //       duration: Duration(milliseconds: 500),
                  //       type: PageTransitionType.rightToLeft,
                  //       child:  Scanpage(),
                  //       inheritTheme: true,
                  //       ctx: context),
                  // );

                } else if (state is LoginFailed) {
                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.msg);


                  setState(() {
                    _isloading = false;
                    _isloading2=false;
                  });
                }
              },
              child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                return loginform();
              }),
            )),
      ),
    );
  }

  Widget loginform() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Canvas.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/jooselogo.png",
                    width: 160,
                    height: 140,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Row(
                children: [
                  Container(
                    child: const JooseText(
                      text: "Login to your account",
                      fontColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15), //border corner radius
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
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: email_Controller,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter email address";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Please enter valid email address";
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'E-mail',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: Password_Controller,
                obscureText: _isObscure,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      }),
                  border: InputBorder.none,
                  hintText: 'Password',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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
              margin: EdgeInsets.only(left: 20, right: 30, top: 20),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Colors.black,
                    side: BorderSide(color: Colors.black),
                    checkColor: Colors.white,
                    value: this.value,
                    onChanged: (bool? value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 0),
                    child: const JooseText(
                      text: "Remember Login",
                      fontColor: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),

                  Expanded(child: SizedBox()),

                  /// Forgot password
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => ForgotPass(),
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

                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //       duration: Duration(milliseconds: 1000),
                      //       type: PageTransitionType.rightToLeft,
                      //       child: forgetPassword(),
                      //       inheritTheme: true,
                      //       ctx: context),
                      // );
                    },
                    child: Container(
                      child: const Center(
                        child: JooseText(
                          text: "Forgot Password?",
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20,bottom: 10),
              child: InkWell(
                splashColor: Color.fromARGB(255, 255, 111, 0),
                highlightColor: Colors.white,
                focusColor: Colors.white,
                onTap: () {
                  setState(() {
                    _isloading = true;
                  });
                  login();
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
                        begin: Alignment.topLeft, //begin of the gradient color
                        end: Alignment.bottomRight, //end of the gradient color
                        stops: [0, 0.2, 0.5, 0.8] //stops for individual color
                        //set the stops number equal to numbers of color
                        ),
                  ),
                  child: Center(
                    child: _isloading
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
                        : const JooseText(
                            text: "SIGN IN",
                            fontColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                  ),
                ),
              ),
            ),
            /*
           Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: const Text(
                  "-or-",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: const JooseText(
                  text: "Sign in with",
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // InkWell(
                //   onTap: () {
                //
                //   },
                //   child: Container(
                //     height: 60,
                //     width: 60,
                //     padding: const EdgeInsets.only(
                //       top: 10,
                //       bottom: 10,
                //     ),
                //     child: Image.asset(
                //       "assets/images/facebook.png",
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   width: 3,
                // ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      _isloading2 = true;
                    });

                    await GoogleSignInController()
                        .signIn(context)
                        .then((value) => googlelogin());
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: _isloading2? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),),
                      ],
                    ): Image.asset(
                      "assets/images/google.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
*/
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const JooseText(
                    text: "Don't have an account?",
                    fontWeight: FontWeight.w500,
                    fontColor: Colors.black,
                  ),
                  SizedBox(width: 3),
                  InkWell(
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    focusColor: Colors.white,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => Registration(),
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
                    },
                    child: const JooseText(
                      text: "Sign up",
                      fontWeight: FontWeight.bold,
                      fontColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() {
    loginCubit.authenticateUser(
        email_Controller.text, Password_Controller.text);
  }

  Future<void> googlelogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? googleaccessToken = preferences.getString('GoogleToken'.toString());
    loginCubit.socialauthenticateUser(googleaccessToken, "google");
  }
}
