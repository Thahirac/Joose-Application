import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joosecustomer/cubit/orderhistory/order_cubit.dart';
import 'package:joosecustomer/localization/app_localization.dart';
import 'package:joosecustomer/models/purchasehistory_class.dart';
import 'package:joosecustomer/repository/purchaseRepo.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:joosecustomer/widgets/notification_icon.dart';
import 'notification_list_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  GlobalKey<ScaffoldState>? _key = GlobalKey();

  List<Purchase>? purchase=[];

  late OrderCubit orderCubit;


  @override
  void initState() {
    orderCubit = OrderCubit(DashBordRepository());
    Notification_Icon();
    super.initState();
    orderCubit.getOrderList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drowerAfterlogin(),
      key: _key,
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(
        leading: IconButton(
            onPressed: (){
              _key!.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu_rounded,size: 30,color: Colors.white,)),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: 0.01,
        flexibleSpace: Container(
          decoration:
          BoxDecoration(
            image: DecorationImage(
              image: AssetImage( "assets/images/appbarimg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: JooseText(
          text: AppLocalizations.of(context).translate("PURCHASE HISTORY"),
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15,top: 25),
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

      body: SafeArea(
        child: BlocProvider(
            create: (context) => orderCubit,
            child: BlocListener<OrderCubit, OrderState>(
              bloc: orderCubit,
              listener: (context, state) {
                if (state is OrderInitial) {}
                if (state is OrderLoading) {
                } else if (state is OrderSuccessfull) {
                  purchase = state.purchase;
                } else if (state is PurchaseFaild) {
                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.msg);
                }

              },
              child: BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    // print("gjgfjhfjf" + cart_count.toString());
                    if (state is OrderInitial) {}
                    if (state is OrderLoading) {
                      return Column(
                        children:  [
                          SizedBox(
                            height: MediaQuery.of(context).size.height* 0.45,
                          ),
                          const Center(
                            child: CupertinoActivityIndicator(
                              radius: 10,
                            ),
                          ),
                        ],
                      );
                    } else if (state is OrderSuccessfull) {
                      return orderlistform();
                    } else if (state is PurchaseFaild) {
                      return orderlistform();
                    }
                    else {
                      return Container();
                    }
                  }),
            )),
      ),
    );
  }

  Widget orderlistform(){
    if(purchase!.isEmpty){
      return orderEmpty();
    }
    else{
      return  Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Canvas.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [

                //Back Button
                Container(
                    margin: EdgeInsets.only(left: 20, top: 30),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),

                      ],
                    )),

                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: purchase?.length,
                      itemBuilder: (context, index) {
                        var tempDate = purchase?[index].purchaseDate==null? "0000-00-00 00:00:00" :purchase?[index].purchaseDate;
                        var correct = DateUtil().formattedDate(DateTime.parse(tempDate.toString()));
                        return Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 13),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: purchase?[index].purchaseType == 0 ? Colors.white : const Color.fromARGB(255, 255, 202, 96),
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
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  SizedBox(height: 10,),
                                  JooseText(
                                    text: "${purchase?[index].quantity??"Redeem"}" + " Bottle from Store " + "${purchase?[index].storeId??""}",
                                    fontColor: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                  JooseText(
                                    text: correct,
                                    fontColor: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                              trailing:  Container(
                                height: 30,
                                width: 30,
                                child: purchase?[index].purchaseType == 0 ? Container() : Image.asset(
                                  "assets/images/coins-solid.png",
                                  width: 30,
                                  height: 30,
                                  color:  Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
      );
    }
  }

  Widget orderEmpty(){
    return  Column(
      children:  [
        SizedBox(
          height: MediaQuery.of(context).size.height* 0.23,
        ),
         Center(
          child: JooseText(text:  AppLocalizations.of(context).translate("No Purchases found here"),fontColor: Colors.black, fontWeight: FontWeight.w600, fontSize: 20,),
        ),
      ],
    );
  }

}

class DateUtil {
  String formattedDate(DateTime dateTime) {
    return DateFormat.yMMMEd ().format (dateTime);
  }
}
