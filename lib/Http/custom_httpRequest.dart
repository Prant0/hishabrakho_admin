import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CustomHttpRequests {
  static const String uri =
      "http://api.hishabrakho.com"; // common part of our api
  static SharedPreferences sharedPreferences;
  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
  };
  static Future<Map<String, String>> getHeaderWithToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "application/json",
      "Authorization": "bearer ${sharedPreferences.getString("token")}",
    };
    print("user token is :${sharedPreferences.getString('token')}");
    return header;
  }

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': '<Your token>'
  };

  static Future<String> login(String email, String password) async {
    try {
      String url = "$uri/api/admin/login";
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['password'] = password;
      final response = await http.post(url, body: map, headers: defaultHeader);
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      }
      print(response.body);
      return "Something Wrong";
    } catch (e) {
      return e.toString(); //01672301394
    }
  }

///api/admin/view/user


  static Future<dynamic> viewAll() async {
    try {
      var response = await http.get(
        "$uri/api/admin/view/user",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body) ;
      if (response.statusCode == 200) {
        print("all data are $data");
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> viewAllAdmin() async {
    try {
      var response = await http.get(
        "$uri/api/admin/all/admin",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body) ;
      if (response.statusCode == 200) {
        print("all admin data are $data");
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> viewAllUser() async {
    try {
      var response = await http.get(
        "$uri/api/admin/all/user",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body) ;
      if (response.statusCode == 200) {
        print("all user data are $data");
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }


  static Future<dynamic> viewProfile() async {
    try {
      var response = await http.get(
        "$uri/api/admin/profile",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body) ;
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }



  static Future<dynamic> deleteList(int eventId)async{
    try{
      var response = await http.delete(
        "$uri/api/admin/delete/user/$eventId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);

      if(response.statusCode==200){

        print(data);
        print("delete sucessfully");
        return response;
      }
      else{
        throw Exception("Cant delete bro");
      }
    }catch(e){
      print(e);
    }
  }


}

