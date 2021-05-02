import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hishabrakho_admin/Http/custom_httpRequest.dart';
import 'package:hishabrakho_admin/Screen/home.dart';
import 'package:hishabrakho_admin/model/user_Model.dart';
import 'package:hishabrakho_admin/widget/Circular_progress.dart';
import 'package:hishabrakho_admin/widget/brand_colors.dart';
import 'package:hishabrakho_admin/widget/globals.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  @override

  TabController tabController;

  void initState() {
    tabController = TabController(length: 1, vsync: this);


    super.initState();
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  Future<bool> onBackPressed() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0)),
            title: Text(
              "Are You Sure ?",
              style: myStyle(16, Colors.white, FontWeight.w500),
            ),
            content: Text("You are going to exit the app !"),
            titlePadding: EdgeInsets.only(top: 30,bottom: 12,right: 30,left: 30),
            contentPadding: EdgeInsets.only(left: 30,right: 30,),
            backgroundColor:  BrandColors.colorPrimaryDark,
            contentTextStyle: myStyle(14,BrandColors.colorText.withOpacity(0.7),FontWeight.w400),
            titleTextStyle: myStyle(18,Colors.white,FontWeight.w500),
            actionsPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),

            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No",style: myStyle(14,BrandColors.colorText),)),



              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,
                child: Text('Yes',style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userName;
  String image;
  loadUserImage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString("userName");
    print(
        "user anme issssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss ${userName}");
    image = sharedPreferences.getString("image");
    print("image is $image");
  }

  @override
  void didChangeDependencies() {
    loadUserImage();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BrandColors.colorPrimaryDark,
        key: _scaffoldKey,
       // drawer: Drawerr()
        body: WillPopScope(
          onWillPop: onBackPressed,
          child: TabBarView(
            controller: tabController,
            physics: ScrollPhysics(),
            children: [
              HomeScreen(),
              //ProfileScreen(),

            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: BrandColors.colorPrimary,
          ),
          child: TabBar(
            labelPadding: EdgeInsets.only(top:2),
            indicatorColor: Colors.transparent,
            physics: BouncingScrollPhysics(),
            //indicatorPadding: EdgeInsets.symmetric(horizontal: 2),
            labelColor: BrandColors.colorText,
            unselectedLabelColor: BrandColors.colorDimText,
            labelStyle: myStyle(14),
            onTap: _onItemTapped,
            tabs: <Widget>[
              Tab(
                text: "Home",
                icon:SvgPicture.asset("assets/home.svg",
                  fit: BoxFit.contain,
                  height: 21,width: 21,
                ),
              ),
              /*Tab(
                text: "Storage",
                icon:SvgPicture.asset("assets/storage.svg",
                  fit: BoxFit.contain,
                  height: 21,width: 21,

                ),
              ),
              Tab(
                text: "Budget",
                icon: SvgPicture.asset("assets/budget.svg",
                  fit: BoxFit.contain,
                  height: 21,width: 21,
                ),
              ),
              Tab(
                text: "Reports",
                icon:SvgPicture.asset("assets/report.svg",
                  fit: BoxFit.contain,
                  height: 21,width: 21,
                ),
              ),
              Tab(
                text: "Entries",
                icon:SvgPicture.asset("assets/entries.svg",
                  fit: BoxFit.contain,
                  height: 21,width: 21,
                ),
              ),*/
            ],
            controller: tabController,
          ),
        ));
  }



  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: myStyle(15, Colors.white),
      ),
      backgroundColor: Colors.purple,
    ));
  }

  int _currentSelected = 0;
  void _onItemTapped(int index) {
     setState(() {
      _currentSelected = index;
      print("index is $_currentSelected");
    });
  }
}
