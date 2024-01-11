import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/cubit/forgetPassword/forget_pass_word_cubit.dart';
import 'package:joosecustomer/pages/resetpass_page.dart';
import 'package:joosecustomer/repository/forgotPassRepo.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dash_board.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  var email_Controller = TextEditingController();
  GlobalKey<ScaffoldState>? _key = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;

  late ForgetPassWordCubit loginCubit;

  void initState() {
    // TODO: implement initState
    loginCubit = ForgetPassWordCubit(ForgetPassRe());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body:BlocProvider(
          create: (context) => loginCubit,
          child: BlocListener<ForgetPassWordCubit, ForgetPassWordState>(
            bloc: loginCubit,
            listener: (context, state) {
              if (state is ForgetPassWordLoading) {}
              if (state is ForgetPassWordSuccessFull) {
                Fluttertoast.showToast(
                    msg: "A Password reset link sent to your mail",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);

                setState(() {
                  _isloading=false;
                });

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => ResetPass(email: email_Controller.text,),
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

              } else if (state is ForgetPassWordFailed) {

                Utils.showDialouge(
                    context, AlertType.error, "Oops!", state.msg);

                setState(() {
                  _isloading=false;
                });
              }
            },
            child: BlocBuilder<ForgetPassWordCubit, ForgetPassWordState>(
                builder: (context, state) {
                  return forgotform();
                }),
          )),
    );
  }

  Widget forgotform(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
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
                margin: EdgeInsets.only(left: 30,top: 10),
                child: Row(
                  children: [
                    Container(
                      child: const JooseText(
                        text: "Forgot Password",
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w900,
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
                padding: const EdgeInsets.only(left: 30, right: 30,top: 20),
                child: InkWell(
                  splashColor: Color.fromARGB(255,255,111,0),
                  highlightColor: Colors.white,
                  focusColor: Colors.white,
                  onTap: () {
                    setState(() {
                      _isloading = true;
                    });
                   if(_formKey.currentState!.validate()){
                     forgot(email_Controller.text);
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
                    child:  Center(
                      child:  _isloading ? const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),) : const JooseText(
                        text: "Continue",
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
    );
  }

  void forgot(String reset) {
    loginCubit.authenticateUser(reset);
  }

}
