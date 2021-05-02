import 'package:flutter/material.dart';
import 'package:hishabrakho_admin/Screen/home.dart';
import 'package:hishabrakho_admin/Screen/login.dart';
import 'file:///H:/antipoints/Admin%20App/hishabrakho_admin/lib/Screen/Profile/profile.dart';
import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hishab Rakho',
      theme: ThemeData(
          brightness: Brightness.dark,
          unselectedWidgetColor:Colors.white
      ),
      //initialRoute: LoginScreen.id,
      home: LoginScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        //RegistationScreen.id: (context) => RegistationScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        MainPage.id: (context) => MainPage(),


      },
    );
  }
}





