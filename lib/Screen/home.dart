import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hishabrakho_admin/Http/custom_httpRequest.dart';
import 'package:hishabrakho_admin/Screen/add_user.dart';
import 'file:///H:/antipoints/Admin%20App/hishabrakho_admin/lib/Screen/Profile/profile.dart';
import 'package:hishabrakho_admin/Screen/update_user.dart';
import 'package:hishabrakho_admin/model/user_Model.dart';
import 'package:hishabrakho_admin/widget/Circular_progress.dart';
import 'package:hishabrakho_admin/widget/brand_colors.dart';
import 'package:hishabrakho_admin/widget/extra.dart';
import 'package:hishabrakho_admin/widget/globals.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool available;

  bool isAll = true;

  bool isAdmin;

  bool isUser;

  bool onProgress = false;

  String userEmail;
  SharedPreferences sharedPreferences;

  UserModel userModel;
  List<UserModel> allData = [];
  List<UserModel> userData = [];
  List<UserModel> adminData = [];

  //userEmail = sharedPreferences.getString("userName");

  getUserName()async{
    sharedPreferences = await SharedPreferences.getInstance();
    userEmail = sharedPreferences.getString("email");
    print("username is $userEmail");  }


  @override
  void initState() {
    fetchAllUser();
    fetchAll();
    fetchAllAdmin();
    getUserName();
    super.initState();
  }

  void fetchAll() async {
    allData.clear();
    final data = await CustomHttpRequests.viewAll();

    for (var user in data) {
      userModel = UserModel(
        id: user["id"],
        name: user["name"],
        email: user["email"],
        isAdmin: user["is_admin"],
        image: user["image"],
      );
      try {
        allData.firstWhere((element) => element.id == userModel.id);
      } catch (e) {
        setState(() {
          onProgress = false;
          allData.add(userModel);
          allData.removeWhere((element) => element.email==userEmail);
        });

      }
    }
  }


  void fetchAllAdmin() async {
    adminData.clear();
    final data = await CustomHttpRequests.viewAllAdmin();
    for (var user in data) {
      userModel = UserModel(
        id: user["id"],
        name: user["name"],
        email: user["email"],
        isAdmin: user["is_admin"],
        image: user["image"],
      );
      try {
        adminData.firstWhere((element) => element.id == userModel.id);
      } catch (e) {
        setState(() {
          adminData.add(userModel);
          adminData.removeWhere((element) => element.email==userEmail);
          onProgress = false;
        });
      }
    }
  }

  void fetchAllUser() async {
    userData.clear();
    final data = await CustomHttpRequests.viewAllUser();
    for (var user in data) {
      userModel = UserModel(
        id: user["id"],
        name: user["name"],
        email: user["email"],
        isAdmin: user["is_admin"],
        image: user["image"],
      );
      try {
        userData.firstWhere((element) => element.id == userModel.id);
      } catch (e) {
        setState(() {
          onProgress = false;
          userData.add(userModel);
          userData.removeWhere((element) => element.email==userEmail);
        });
      }
    }
  }


  _searchBarAll() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0)),
      child: TextField(
        style: myStyle(16, Colors.white, FontWeight.w600),

        decoration: InputDecoration(

          hintStyle: myStyle(16, Colors.white, FontWeight.w600),
          hintText: "Search",
          filled: true,
          focusedBorder: InputBorder.none,
          suffixIcon: Icon(Icons.search, color: BrandColors.colorDimText,),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          fillColor: BrandColors.colorPrimaryDark,
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            allData = allData.where((post) {
              var postTitle = post.name.toLowerCase();
              return postTitle.contains(text);
            }).toList();
          });
        },
      ),

    );
  }


  _searchBarAdmin() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0)),
      child: TextField(
        style: myStyle(16, Colors.white, FontWeight.w600),
        decoration: InputDecoration(
          hintStyle: myStyle(16, Colors.white, FontWeight.w600),
          hintText: "Search",
          filled: true,
          focusedBorder: InputBorder.none,
          suffixIcon: Icon(Icons.search, color: BrandColors.colorDimText,),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          fillColor: BrandColors.colorPrimaryDark,
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            adminData = adminData.where((post) {
              var postTitle = post.name.toLowerCase();
              return postTitle.contains(text);
            }).toList();
          });
        },
      ),

    );
  }


  _searchBarUser() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0)),
      child: TextField(
        style: myStyle(16, Colors.white, FontWeight.w600),
        decoration: InputDecoration(
          hintStyle: myStyle(16, Colors.white, FontWeight.w600),
          hintText: "Search",
          filled: true,
          focusedBorder: InputBorder.none,
          suffixIcon: Icon(Icons.search, color: BrandColors.colorDimText,),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          fillColor: BrandColors.colorPrimaryDark,
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            userData = userData.where((post) {
              var postTitle = post.name.toLowerCase();
              return postTitle.contains(text);
            }).toList();
          });
        },
      ),

    );
  }

  RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  void _onRefresh() async {
    fetchAllUser();
    fetchAll();
    fetchAllAdmin();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }


  String filterType;
  List<String> _getFilterType = [
    "All",
    "Admin",
    "User",

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomInset: true,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimaryDark,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/drawer.svg",
            fit: BoxFit.contain,
            height: 21,
            width: 21,
          ),
          onPressed: () {
            //  _scaffoldKey.currentState.openDrawer();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          },
        ),
        // backgroundColor: BrandColors.colorPrimaryDark,
        elevation: 0,

        actions: [


          Container(
            width: 150,
            //  child: _searchBar(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: DropdownButtonFormField<String>(
                icon: Icon(
                  Icons.filter_list, color: Colors.white,
                  size: 25,
                ),
                decoration: InputDecoration.collapsed(hintText: ''),
                value: filterType,
                onChanged: (String newValue) {
                  setState(() {
                    filterType = newValue;
                  });
                },
                validator: (value) => value == null ? 'field required' : null,

                items: _getFilterType.map((String storageValue) {
                  return DropdownMenuItem(
                    value: storageValue,
                    child: Text(
                      "$storageValue ",
                      style: myStyle(16, Colors.white),
                    ),
                    onTap: () async {
                      if (storageValue == "Admin") {
                        adminData.clear();
                        final data = await CustomHttpRequests.viewAllAdmin();
                        print("Admin");
                        for (var user in data) {
                          userModel = UserModel(
                            id: user["id"],
                            name: user["name"],
                            email: user["email"],
                            isAdmin: user["is_admin"],
                            image: user["image"],
                          );
                          try {
                            adminData.firstWhere((element) =>
                            element.id == userModel.id);
                          } catch (e) {
                            setState(() {
                              adminData.add(userModel);
                              onProgress = false;
                            });
                            print("admin length is ${adminData.length}");
                          }
                        }
                        setState(() async {
                          isAdmin = true;
                          isAll = false;
                          isUser = false;
                        });
                      }


                      if (storageValue == "User") {
                        setState(() {
                          isAll = false;
                          isAdmin = false;
                          isUser = true;
                          fetchAllUser();
                        });
                      } else {
                        setState(() {
                          isAdmin = false;
                          isUser = false;
                          isAll = true;
                          fetchAll();
                        });
                      }

                      print("value is ${storageValue}");
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddUser()))
                  .then((value) =>
                  setState(() {
                    fetchAllUser();
                  }));
            },
            child: Container(
              margin: EdgeInsets.only(top: 12, right: 8, left: 8, bottom: 5),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.0),
              ),
              child: Icon(Icons.add, size: 21, color: BrandColors.colorText,),
            ),
          ),


        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        progressIndicator: Spin(),
        opacity: 0.3,
        child: Container(
            child: Column(
              children: [
                Visibility(
                  visible: isAll == true,
                  child: Expanded(
                    flex: 1,
                    // child:_searchBar(),
                    child: Row(
                      children: [
                      Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                            children: [
                        Text("Total Member : ${allData.length.toString()} ",
                        style: myStyle(
                            16, BrandColors.colorText, FontWeight.w500),),

                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: _searchBarAll(),
                ),
              ],
            )
        ),
      ),


      Visibility(
          visible: isAdmin == true,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Total admin : ${adminData.length.toString()} ",
                    style: myStyle(
                        16, BrandColors.colorText, FontWeight.w500),),
                ),
              ),
              Expanded(
                flex: 6,
                child: _searchBarAdmin(),
              ),
            ],
          )
      ),

      Visibility(
          visible: isUser == true,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Total user : ${userData.length.toString()} ",
                    style: myStyle(
                        16, BrandColors.colorText, FontWeight.w500),),
                ),
              ),
              Expanded(
                flex: 6,
                child: _searchBarUser(),
              ),
            ],
          )
      ),
      Visibility(
        visible: isAll == true,
        child: Expanded( //allData[index].isAdmin==1?
          flex: 9,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: listTypes(allData),
          ),
        ),
      ),

      Visibility(
        visible: isAdmin == true,
        child: Expanded( //allData[index].isAdmin==1?
          flex: 9,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: listTypes(adminData),
          ),
        ),
      ),
      Visibility(
        visible: isUser == true,
        child: Expanded( //allData[index].isAdmin==1?
          flex: 9,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: listTypes(userData),
          ),
        ),
      ),

      ],
    ),)
    ,
    )
    );
  }



  ListView listTypes(List<UserModel> list) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            child: Container(

              height: 70,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                      //clipBehavior: BorderRadius.circular(20.0),
                      backgroundImage: NetworkImage(
                        "http://hishabrakho.com/admin/user/${list[index]
                            .image ?? ""}",),
                      radius: 20,
                    ),
                  ),

                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                    RichText(
                    text: TextSpan(children: [
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(1, -4),
                          child: Text("${list[index].name}",style: myStyle(14,Colors.white),),

                          ),
                        ),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: Offset(5, -10),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            decoration: BoxDecoration(
                              color: list[index].isAdmin==0? Colors.green:Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(list[index].isAdmin==0?"Admin":"User",style: myStyle(10,Colors.white,FontWeight.w500),),
                          )
                        ),
                      ),


                    ]),
            )


                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                       list[index].email!=userEmail? MCustomSwitch(
                          value: list[index].isAdmin == 0
                              ? available = true
                              : available = false,
                          activeColor: Colors.white,
                          activeTogolColor: BrandColors.colorPrimary,
                          onChanged: (val) async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(13.0)),
                                    title: Text(
                                      "Are You Sure ?",
                                      style: myStyle(
                                          16, Colors.white, FontWeight.w800),
                                    ),
                                    content: Text("You want to Change !"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              available = available;
                                              onProgress = false;
                                              fetchAllUser();
                                              fetchAllAdmin();
                                              fetchAll();
                                            });
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text("No")),
                                      FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              available = !available;
                                              onProgress = false;
                                            });
                                            int uid = list[index].id;
                                            int isAdmin = val == true
                                                ? list[index].isAdmin = 0
                                                : list[index].isAdmin = 1;
                                            print("bal is $isAdmin");
                                            updateUserStatus(
                                                context, isAdmin, uid).then((
                                                value) =>
                                                setState(() {
                                                  fetchAllUser();
                                                  fetchAllAdmin();
                                                  fetchAll();
                                                }));
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"))
                                    ],
                                  );
                                });
                          },
                        ) :SizedBox(width: 1,),
                        SizedBox(width: 12,),
                        Container(
                          //height: double.infinity,
                          height: 30,
                          width: 3,
                          color: BrandColors.colorText
                              .withOpacity(0.2),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Edit',
                color: BrandColors.colorPrimary,
                icon: Icons.more_horiz,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => UpdateUser(model: list[index],)))
                      .then((value) =>
                      setState(() {
                        fetchAllUser();
                        fetchAllAdmin();
                        fetchAll();
                      }));
                },
              ),
              new IconSlideAction(
                caption: 'Delete',
                color: BrandColors.colorPrimary,
                iconWidget: SvgPicture.asset(
                  "assets/delete.svg",
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(13.0)),
                          title: Text(
                            "Are You Sure ?",
                            style: myStyle(
                                16, Colors.white, FontWeight.w800),
                          ),
                          content: Text("You want to delete !"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("No")),
                            FlatButton(
                                onPressed: () {
                                  print("tap");
                                  CustomHttpRequests.deleteList(list[index].id)
                                      .then((value) => value);
                                  setState(() {
                                    list.removeAt(index);
                                  });
                                  showInSnackBar(
                                    "1 Item Delete",
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text("Yes"))
                          ],
                        );
                      });
                },
              ),
            ],
          );
        }
    );
  }



  ///api/admin/is/admin/
  Future<void> updateUserStatus(BuildContext context, int isAdmin,
      int id,) async {
    setState(() {
      onProgress = true;
    });

    final uri = Uri.parse("http://api.hishabrakho.com/api/admin/is/admin");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['user_id'] = id.toString();
    request.fields['value'] = isAdmin.toString();
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    if (response.statusCode == 200) {
      print("responseBody1 " + responseString);
      showInSnackBar("Account updated Successful ");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          onProgress = false;
          // Navigator.of(context).pop();
        });
      });
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddBankStapper()));
    } else {
      setState(() {
        onProgress = false;
      });
      var errorr = jsonDecode(responseString.trim().toString());
      showInSnackBar("Registered Failed, ${errorr}");
      print("Registered failed " + responseString);

      //return false;
    }
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.indigo,
    ));
  }
}
class moneyField extends StatelessWidget {
  final Offset offset;
  final dynamic amount;
  final TextStyle ts;
  final TextStyle tks;
  moneyField({this.amount,this.ts,this.offset,this.tks});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [

        WidgetSpan(
          child: Transform.translate(
            offset: offset,
            child: Text(
                '৳',
                textScaleFactor: 1.0,
                style: tks
            ),
          ),
        ),

        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(1, -4),
            child: Text(
                NumberFormat.currency(
                    decimalDigits: (amount)
                    is int
                        ? 0
                        : 2,
                    symbol: '',
                    locale: "en-in")
                    .format(amount??0),
                style: ts
            ),
          ),
        ),

      ]),
    );
  }
}