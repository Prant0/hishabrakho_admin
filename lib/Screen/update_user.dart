import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hishabrakho_admin/Http/custom_httpRequest.dart';
import 'package:hishabrakho_admin/model/user_Model.dart';
import 'package:hishabrakho_admin/widget/Circular_progress.dart';
import 'package:hishabrakho_admin/widget/brand_colors.dart';
import 'package:hishabrakho_admin/widget/extra.dart';
import 'package:hishabrakho_admin/widget/globals.dart';
import 'package:hishabrakho_admin/widget/textField.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUser extends StatefulWidget {
  final UserModel model;

  UpdateUser({this.model});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Map<String, dynamic> _data = Map<String, dynamic>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  int isAdmin;

  bool customButton = false;

  File _image;

  final picker = ImagePicker();

  void getAdminValue() {
    if (widget.model.isAdmin == 0) {
      isAdmin = 0;
    } else {
      isAdmin = 1;
    }
    print("${widget.model.name} is a $isAdmin");
  }


  @override
  void initState() {
    nameController.text = "${widget.model.name}";
    emailController.text = "${widget.model.email}";
    getAdminValue();
    super.initState();
  }

  _cropImage(File pickedImage) async {
    File cropped = await ImageCropper.cropImage(
        androidUiSettings: AndroidUiSettings(
            lockAspectRatio: false,
            statusBarColor: Colors.purpleAccent,
            toolbarColor: Colors.purple,
            toolbarTitle: "Crop Image",
            toolbarWidgetColor: Colors.white
        ),
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ]
    );
    if (cropped != null) {
      setState(() {
        _image = cropped;
      });
    }
  }

  Future chooseGallery() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _cropImage(pickedImage);
    }
    Navigator.pop(context);
  }

  Future chooseCamera() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      _cropImage(pickedImage);
      Navigator.pop(context);
    }
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Upload Image",
              style: TextStyle(),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () {
                  print("Gallery");
                  chooseGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Image from Camera"),
                onPressed: () {
                  print("open camera");
                  chooseCamera();
                },
              ),
              SimpleDialogOption(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text(
          "Edit Entries",
        ),
        centerTitle: true,
      ),

      body: ModalProgressHUD(
          progressIndicator: Spin(),
          inAsyncCall: onProgress,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: BrandColors.colorPrimaryDark,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),

                      Center(
                        child: Column(
                          children: [
                            Stack(children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: BrandColors.colorPrimary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: _image == null
                                          ? GestureDetector(
                                        onTap: () {
                                          selectImage(context);
                                        },
                                        child: CircleAvatar(
                                          //clipBehavior: BorderRadius.circular(20.0),
                                          backgroundImage: NetworkImage(  "http://hishabrakho.com/admin/user/${widget
                                              .model.image}",),
                                          radius: 60,
                                        ),
                                      )
                                          : CircleAvatar(
                                        backgroundImage: FileImage(_image),
                                      )
                                    // : Image.file(
                                    //     image,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -15,
                                top: -15,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  icon: _image != null
                                      ? Icon(
                                    Icons.clear, color: Colors.white,)
                                      : Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Add your profile photo',
                              style: myStyle(14, BrandColors.colorText),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25,),
                            child: Text("User Name", style: myStyle(
                                16, BrandColors.colorWhite,
                                FontWeight.w500),),
                          ),
                          SenderTextEdit(
                            keyy: "Payable",
                            data: _data,
                            name: nameController,
                            lebelText: "${widget.model.name} ?? ",
                            //hintText: " Payable to",
                            icon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SvgPicture.asset("assets/user1.svg",
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                color: BrandColors.colorText,
                              ),
                            ),
                            function: (String value) {
                              if (value.isEmpty) {
                                return "Name required";
                              }
                              if (value.length < 3) {
                                return "Name Too Short ( Min 3 character )";
                              }
                              if (value.length > 30) {
                                return "Name Too long (Max 30 character)";
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25,),
                            child: Text("User Email", style: myStyle(
                                16, BrandColors.colorWhite,
                                FontWeight.w500),),
                          ),
                          SenderTextEdit(
                            keyy: "Payable",
                            data: _data,
                            name: emailController,
                            lebelText: "${widget.model.email} ?? ",
                            //hintText: " Payable to",
                            icon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SvgPicture.asset("assets/email.svg",
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                color: BrandColors.colorText,
                              ),
                            ),
                            function: (String value) {
                              if (value.isEmpty) {
                                return "Email required";
                              }
                              if (!value.contains('@')) {
                                return "Invalid Email";
                              }
                              if (!value.contains('.')) {
                                return "Invalid Email";
                              }
                            },
                          ),
                        ],
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Row(
                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Is Admin ?", style: myStyle(
                                18, BrandColors.colorText, FontWeight.w500),),

                           /* Row(
                              children: [
                                LiteRollingSwitch(
                                  value: widget.model.isAdmin == 0
                                      ? true
                                      : false,
                                  textOn: "Yes",
                                  textOff: "Off",

                                  colorOn: BrandColors.colorPrimary,
                                  colorOff: BrandColors.colorPrimaryDark,
                                  onChanged: (bool val) {
                                    val = !val;
                                    val == true ? isAdmin = 1 : isAdmin = 0;
                                    print("button is $val");
                                    print("button isss ${isAdmin.toInt()}");
                                  },
                                  iconOn: Icons.lightbulb_outline,
                                  iconOff: Icons.power_settings_new,
                                ),
                                SizedBox(width: 25,)
                              ],
                            ),*/


                            SizedBox(width: 30,),

                            MCustomSwitch(
                              value:  widget.model.isAdmin==0? true :false,
                              activeColor: Colors.white,
                              activeTogolColor: BrandColors.colorPrimary,
                              onChanged: (bool val) {
                                val = !val;
                                val == true ? isAdmin = 1 : isAdmin = 0;
                                print("button is $val");
                                print("button isss ${isAdmin.toInt()}");
                              },
                            )
                          ],
                        ),
                      ),


                      SizedBox(
                        height: 10,
                      ),
                      // ignore: deprecated_member_use

                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Container(
                  color: BrandColors.colorPrimaryDark,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.deepPurpleAccent, width: 1.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white70,
                                  size: 15,
                                ),
                                Text(
                                  "Go Back",
                                  style: myStyle(16, Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 10,
                        child: InkWell(
                          onTap: () {
                            if (!_formKey.currentState.validate()) return;
                            _formKey.currentState.save();
                            print("tap");
                            /*final note = UserModel(
                              name: nameController.text.toString(),
                              email: emailController.text.toString(),
                              id: widget.model.id.toInt(),
                              isAdmin: isAdmin.toInt(),
                              image: _image.path,
                            );*/
                            updateUser(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.deepPurpleAccent,
                              border: Border.all(
                                  color: Colors.deepPurpleAccent,
                                  width: 1.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Proceed",
                                  style: myStyle(16, Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white70,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }


  static SharedPreferences sharedPreferences;

  Future updateUser(BuildContext context) async {
    // sharedPreferences = await SharedPreferences.getInstance();
    try {
      check().then((intenet) async {
        if (intenet != null && intenet) {
          if (mounted) {
            setState(() {
              onProgress = true;
            });
            final uri = Uri.parse("http://api.hishabrakho.com/api/admin/update/user");
            var request = http.MultipartRequest("POST", uri);
            request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
           if(_image ==null){
             request.fields['email'] =  emailController.text.toString();
             request.fields['name'] = nameController.text.toString();
             request.fields['user_id'] =widget.model.id.toString();
             request.fields['is_admin'] = isAdmin.toString();
             // var photo = await http.MultipartFile.fromPath("image", _image.path );
             // request.files.add(photo);
             print("processing");
            // var response = await request.send();
           }else{
             request.fields['email'] =  emailController.text.toString();
             request.fields['name'] = nameController.text.toString();
             request.fields['user_id'] =widget.model.id.toString();
             request.fields['is_admin'] = isAdmin.toString();
              var photo = await http.MultipartFile.fromPath("image", _image.path );
              request.files.add(photo);
             print("processing");

           }
            var response = await request.send();
            var responseData = await response.stream.toBytes();
            var responseString = String.fromCharCodes(responseData);
            print("responseBody " + responseString);
            if (response.statusCode == 201) {
              print("responseBody1 " + responseString);
              showInSnackBar("Account Created Successful ");
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  onProgress = false;
                  Navigator.of(context).pop();
                });
              });
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
        } else
          showInSnackBar("No Internet Connection");
      });
    } catch (e) {
      print("something went wrong $e");
    }
  }


  updateUserr(UserModel item) async {
    setState(() {
      onProgress = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    return http
        .put("http://api.hishabrakho.com/api/admin/update/user",
        headers: <String, String>{
          'Content-type': 'application/json',
          "Authorization": "bearer ${sharedPreferences.getString("token")}",
        },
        body: json.encode(item.toJson()))
        .then((data) {
      try {
        print("one");
        if (data.statusCode == 201) {
          return {print("Earaning Data updated succesfully"),
            showInSnackBar("Updated successfully"),
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                onProgress = false;
                Navigator.of(context).pop();
              });
            }),
          };
        } else
          setState(() {
            print("oneeee");
            onProgress = false;
            showInSnackBar("Updated failed");
          });
        throw Exception('Failed to update');
      } catch (e) {
        print("Failedddd $e");
      }
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.purple,
    ),);
  }

  bool onProgress = false;



}
