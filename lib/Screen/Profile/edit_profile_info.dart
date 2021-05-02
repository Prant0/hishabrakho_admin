import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hishabrakho_admin/Http/custom_httpRequest.dart';
import 'package:hishabrakho_admin/model/user_Model.dart';
import 'package:hishabrakho_admin/widget/Circular_progress.dart';
import 'package:hishabrakho_admin/widget/brand_colors.dart';
import 'package:hishabrakho_admin/widget/textField.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfo extends StatefulWidget {
  final UserModel model;
  EditInfo({this.model});
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic> _data = Map<String, dynamic>();
  File _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool onProgress = false;


  _cropImage(File pickedImage)async{
    File cropped = await ImageCropper.cropImage(
        androidUiSettings:AndroidUiSettings(
            lockAspectRatio: false,
            statusBarColor: Colors.purpleAccent,
            toolbarColor: BrandColors.colorPrimaryDark,
            toolbarTitle: "Crop Image",
            toolbarWidgetColor: Colors.white
        ) ,
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ]
    );
    if(cropped != null){
      setState(() {
        _image = cropped;
      });
    }
  }



  Future chooseGallery() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage !=null){
      _cropImage(pickedImage);
    }
    Navigator.pop(context);

  }

  Future chooseCamera() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if(pickedImage !=null){
      _cropImage(pickedImage);
    }
    Navigator.pop(context);
  }


  @override
  void initState() {
    nameController.text="${widget.model.name}";
    emailController.text="${widget.model.email}";
    super.initState();
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
                child: Text("Image with Gallery"),
                onPressed: () {
                  print("Gallery");
                  chooseGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Image with Camera"),
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
      key:_scaffoldKey ,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        title: Text("Edit Info"),
        backgroundColor: BrandColors.colorPrimaryDark,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ModalProgressHUD(
          progressIndicator: Spin(),
          inAsyncCall: onProgress,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      selectImage(context);
                    },
                    child: _image != null ? Image.file(_image): Image(image: AssetImage('assets/ph.png'),fit: BoxFit.cover,width: double.infinity,),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Click on image to update your photo",style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(
                    height: 16.0,
                  ),

                  Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(18),

                    ),
                    margin: EdgeInsets.only(left: 20,right: 25),
                    child:  SenderTextEdit(
                      keyy: "Name",
                      data: _data,
                      name: nameController,
                      lebelText: "User Name",
                      //hintText: " ${widget.model.username}",
                      icon: Padding(
                        padding: const EdgeInsets.all(14.0),
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
                          return "Name Too Short ( Min 3 character)";
                        }if (value.length > 30) {
                          return "Name Too long (Max 30 character)";
                        }
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(18),

                    ),
                    margin: EdgeInsets.only(left: 20,right: 25),
                    child:  SenderTextEdit(
                      keyy: "email",
                      data: _data,
                      name: emailController,
                      lebelText: "User Email",
                      //hintText: " ${widget.model.username}",
                      icon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: SvgPicture.asset("assets/user1.svg",
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
                  ),

                  SizedBox(height: 30.0,),
                  RaisedButton(
                    onPressed: (){
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      updateProfile(context);
                      print("tap");
                    },
                    child: Text("Update Info"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  SharedPreferences sharedPreferences;
  String img;
  Future updateProfile(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      check().then((intenet)async {
        if (intenet != null && intenet) {
          if (mounted) {
            setState(() {
              onProgress = true;
            });
            final uri = Uri.parse("http://api.hishabrakho.com/api/admin/profile/update");
            var request = http.MultipartRequest("POST", uri);
            request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
        if(_image==null){
          request.fields['name'] = nameController.text.toString();
          request.fields['email'] = emailController.text.toString();
          request.fields['email'] = widget.model.email.toString();
        }
        else{
          request.fields['name'] = nameController.text.toString();
          request.fields['email'] = emailController.text.toString();
          request.fields['email'] = widget.model.email.toString();
          var photo = await http.MultipartFile.fromPath("image", _image.path);
          request.files.add(photo);
        }
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print("responseBody " + responseString);
        if (response.statusCode == 201) {
          await sharedPreferences.remove('image');
          await sharedPreferences.remove('userName');
        print("responseBody1 " + responseString);
        var data = jsonDecode(responseString);
          setState(() {
            sharedPreferences.setString("image", data['image']);
            sharedPreferences.setString("userName", data['name']);

          });
          print("save image");
          img = sharedPreferences.getString("image");
          print('img is $img');
          print('name is${sharedPreferences.getString("userName")}');
        showInSnackBar("update successful");
        Future.delayed(const Duration(seconds: 2), () {
        if(mounted){
        setState(() {
        onProgress = false;
        });
        }
        });

        Navigator.pop(context);
        Navigator.pop(context);
        } else {
        showInSnackBar("update Failed, Try again please");
        print("update failed " + responseString);
        setState(() {
        onProgress = false;
        });
        }
          }
        }
        else showInSnackBar("No Internet Connection");
      });
    } catch (e) {
      print("something went wrong $e");
    }
  }




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
