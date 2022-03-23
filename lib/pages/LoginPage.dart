import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/pages/HomePage.dart';
import 'package:powerup/controllers/LoginRegisterController.dart';
import 'package:powerup/pages/RegisterPage.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/pages/VendorProfile.dart';
import '../controllers/LoginRegisterController.dart';

class LoginPage extends StatefulWidget {
  @override
  /// This function displays the Login Page
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  LoginRegisterController loginRegController = LoginRegisterController.getInstance();

  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover,
                    )
                )
            ),
            Builder(builder: (context){
              return SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Column(
                        children: [
                          Image.asset(
                              'assets/powerup.png',
                              scale: 2
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: email,
                              obscureText: false,
                              style: style,
                              validator: (String email){
                                if(email.isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey[450]
                                ),
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Email address",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                              )
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: password,
                              obscureText: true,
                              style: style,
                              validator: (String password){
                                if(password.isEmpty){
                                  return 'Password cannot be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey[450]
                                ),
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Password",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              )
                          ),
                          SizedBox(height: 20),

                          Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  onPressed: (){
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    if(_formKey.currentState.validate()){
                                      loginRegController.login(email.text, password.text).then((loginCheck){
                                        if(loginCheck == "user"){
                                          loginRegController.getUserObj(email.text).then((user){
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                    user
                                                  ))
                                            );
                                          });
                                          
                                        }
                                        else if (loginCheck == "vendor"){
                                          loginRegController.getVendorObj(email.text).then((vendor){
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => VendorProfile(
                                                    vendor
                                                  ))
                                            );
                                          });
                                          
                                        }
                                        else{
                                          SnackBar sb = SnackBar(
                                            content: Text(
                                                'The email or password is invalid or the account does not exist',
                                                style: TextStyle(
                                                fontSize: 16,
                                            ),
                                            ),
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 5),
                                          );
                                          Scaffold.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(sb);
                                        } /// else
                                      } /// inside then
                                      ); /// then
                                    } /// if (_formkey)
                                  }, /// on pressed
                                  child: Text(
                                      "Login",
                                      textAlign: TextAlign.center,
                                      style: style.copyWith(
                                        color: Colors.black, fontWeight: FontWeight.bold,
                                      )
                                  )
                              )
                          ),
                          SizedBox(height: 10),
                          Text(
                              "Don't have an account?",
                              style: style.copyWith(
                                color: Colors.black,
                              )
                          ),
                          FlatButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage())
                              );
                            },
                            child: Text(
                                "Create a new one",
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                )),
                          )
                        ],
                      )
                  ),
                ),
              );
            })
          ],
        )
    );
  }
}
