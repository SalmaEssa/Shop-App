
/////////////////////////////////////////////////////////
///
import 'dart:math';

import 'package:flutter/material.dart';
class AuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1])
            ),
            
          ),SingleChildScrollView(
            child: Container(
               height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.deepOrange.shade900,
                       boxShadow: [BoxShadow(
                         color: Colors.black26,
                         blurRadius: 10
                         ,offset: Offset(0, 2)
                       )
                       ]
                      ),
                    margin: EdgeInsets.only(bottom: 200),
                    transform: Matrix4.rotationZ(-8*pi/180)..translate(-10.0),
                    child: Center(child: Text("MyShop",style:TextStyle(
                      fontSize: 50,
                      fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                          color: Colors.white
                    )
                    )),
                  ),
                  AuthCard()


                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {

  @override
  _State createState() => _State();
}



class _State extends State<AuthCard> {
  var _passFocus=FocusNode();
    var _confirmPassFocus=FocusNode();
  final _form=GlobalKey<FormState>();
  var values={
    "E-Mail":"",
    "Password":"",
    "ConfirmPassword":""

  };

void _save(){
final isvalid=_form.currentState.validate();
    if(isvalid==false)
    return;
  _form.currentState.save();

}


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30),
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
child: SingleChildScrollView(
  child: Column(
    children: [
        TextFormField(
          decoration: InputDecoration(labelText: "E-Mail"),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          onFieldSubmitted: (_){
            FocusScope.of(context).requestFocus(_passFocus);
            
          },
          validator:(value){
               if (value.isEmpty || !value.contains('@')) 
                        return 'Invalid email!';
                        return null;
            },
          onSaved: (data){
            values["E-Mail"]=data;
          },
        
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Password"),
          textInputAction: TextInputAction.none,
          onFieldSubmitted:(_)=> _save,
          onSaved: (data){
            values["Password"]=data;

          },
        
        ),
        SizedBox(
          height: 20,
        ),
        Container(
        
          decoration: BoxDecoration(
  color: Colors.purple,
  borderRadius: BorderRadius.circular(30)
          ),
           padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
          child: FlatButton(onPressed: null, child: Text("LogIn", style: TextStyle(color: Colors.white,
            
          ),)))
        
    ],
  ),
),
        ),
      ),
      
    );
  }
}