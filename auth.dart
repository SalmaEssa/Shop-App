import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:shopApp/models/http_exception.dart';

class Auth with ChangeNotifier{
String _token;
DateTime _expireDate;
String _userId;
Timer _autotimer;
String get userId{
  return _userId;
}
bool get   isAuth 
{
return token!=null;
}

Future<bool> tryautologin() async {
final prefs= await SharedPreferences.getInstance();
if(!prefs.containsKey("UserData"))
return false; 
final data=json.decode(prefs.getString("UserData"));
print(data);
final date=DateTime.parse(data["expireDate"]);

if(date.isAfter(DateTime.now()))
{ //print("jjjjjkkkkkkkkkkkkkkkkkk");
//print(data["token"]);
  _token=data["Token"];
  _expireDate=date;
  _userId=data["userId"];
  autologout();
  notifyListeners();
  return true;
}
 return false;

}

String get token{
if(_token!=null&& _expireDate!=null&& _expireDate.isAfter(DateTime.now()))
return _token;
return null;
}
Future<void> _authentication(String email, String password, String url)async{

try{
  final response= await http.post(url, body: json.encode({
"email":email,
"password": password,
"returnSecureToken": true
}));
if(json.decode(response.body)["error"]!=null){
throw HttpExceptions(json.decode(response.body)["error"]['message']);
}
final data=json.decode(response.body);
_token=data["idToken"];
_expireDate=DateTime.now().add(Duration(seconds: int.parse(data["expiresIn"])))  ;
_userId=data["localId"];
autologout();
final  prefs = await SharedPreferences.getInstance();
final userdata=json.encode({
"Token":_token,
"expireDate":_expireDate.toIso8601String(),
"userId":_userId
});
prefs.setString("UserData", userdata);
 }
 catch(error)
 {
   throw error;
 }
 notifyListeners();

}

Future<void> signUp(String email, String password)async  {
const url="https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDEEuEHl8FbAV4ALAAU6Wtdb-E9YX5B73o";
 return _authentication(email, password, url);
}

Future<void> logIn(String email, String password)async  {
const url="https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDEEuEHl8FbAV4ALAAU6Wtdb-E9YX5B73o";
return _authentication(email, password, url);
}


Future<void> autologout(){
  if(_autotimer!=null){
    _autotimer.cancel();
  }
  final timeexpiry=_expireDate.difference(DateTime.now()).inSeconds;
_autotimer=Timer(Duration(seconds: timeexpiry),()=>logOut() );

}
void logOut()async {
if(_autotimer!=null){
  _autotimer.cancel();
  _autotimer=null;
}
_token=null;
_expireDate=null;
_userId=null;
final prefs= await SharedPreferences.getInstance();
prefs.clear();
notifyListeners();

}

}