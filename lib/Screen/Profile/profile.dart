import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hishabrakho_admin/Http/custom_httpRequest.dart';
import 'package:hishabrakho_admin/Screen/Profile/edit_profile_info.dart';
import 'package:hishabrakho_admin/Screen/Profile/reset_password.dart';
import 'package:hishabrakho_admin/Screen/login.dart';
import 'package:hishabrakho_admin/model/user_Model.dart';
import 'package:hishabrakho_admin/widget/brand_colors.dart';
import 'package:hishabrakho_admin/widget/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profileScreen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
  //fetchProfile();
    super.initState();
  }


  List<UserModel> allData=[];
  UserModel userModel;

  Future<dynamic> fetchProfile()async{
    final data =await CustomHttpRequests.viewProfile();
    print("User data are $data");
    userModel=UserModel.fromJson(data);
    try{
      allData.firstWhere((element) => element.id==userModel.id);
    }catch(e){
      allData.add(userModel);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text("My Profile",style: myStyle(18,BrandColors.colorText,FontWeight.w400),),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),


      child:  FutureBuilder(
            future: fetchProfile(),
            builder:
                (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return  ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          leading: ClipRRect(
                            child: Image.network(
                              "http://hishabrakho.com/admin/user/${allData[index].image}",
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),




                          trailing: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: allData[index].isAdmin==0? Colors.green:Colors.red,
                            ),
                            child: Text(allData[index].isAdmin==0?"Admin":"User",style: myStyle(12,Colors.white),),
                          ),
                          title: Text(
                            "${allData[index].name}",
                            style: myStyle(22, Colors.white, FontWeight.w500),
                          ),
                          subtitle: Text(
                            "${allData[index].email}",
                            style: myStyle(14, Colors.grey, FontWeight.w400),
                          ),
                        ),

                        SizedBox(height: 28,),

                        Divider(
                          color: Color(0xFF9fa8da),
                          height: 15,
                          thickness: .4,
                        ),

                        SizedBox(height: 28,),


                        ProfileButton(
                          title: "Edit Profile",
                          icon: Icons.person,
                          onPress: () {
                            print("poppppppppppp");
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditInfo(model: allData[index],))).then((value) => setState((){
                              fetchProfile();
                            }));
                          },
                        ),

                        ProfileButton(
                          title: "Change Password ",
                          icon: Icons.lock,
                          onPress: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword())).then((value) => setState((){
                              fetchProfile();
                            }));
                          },
                        ),


                        ProfileButton(
                          title: "Logout",
                          icon: Icons.logout,
                          onPress: () async {
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            await preferences.remove('token');
                            await preferences.remove('userName');
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                        ),




                      ],
                    );
                  },
                );
              else
                return Center(child: Text("Loading",style: myStyle(16,Colors.white),));
            }),

      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  Function onPress;
  String title;
  IconData icon;

  ProfileButton({this.title, this.icon, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: FlatButton(
        onPressed: onPress,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Color(0xFF9fa8da),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: myStyle(16, BrandColors.colorWhite),
            ),
          ],
        ),
      ),
    );
  }
}