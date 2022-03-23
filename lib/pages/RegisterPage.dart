import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/controllers/LoginRegisterController.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:intl/intl.dart';
import 'package:powerup/pages/VerificationPage.dart';


class RegisterPage extends StatefulWidget {
  @override
  /// This function displays the Registration Page
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  String emailValidator;
  String companyValidator;
  TextEditingController lastName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController nokName = TextEditingController();
  TextEditingController nokContact = TextEditingController();
  TextEditingController nameOfPOC = TextEditingController();
  TextEditingController contactNumOfPOC = TextEditingController();
  TextEditingController brn = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController companyEmail = TextEditingController();
  TextEditingController companyPassword = TextEditingController();
  TextEditingController companyConfirmPassword = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();
  DateTime dobDT;
  int yearOfUser;
  bool dobFormat;
  int yearNow = int.parse(DateFormat('yyyy').format(DateTime.now()));
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  LoginRegisterController registerControl = LoginRegisterController.single_instance;
  Vendor vendor;


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.grey[300],
              appBar: AppBar(
                  centerTitle: true,
                  title: Text('Register As', style: TextStyle(fontSize: 24, color: Colors.black)),
                  backgroundColor: Colors.lightBlueAccent,
                  elevation: 0,
                  bottom: TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: Colors.grey[300],
                      ),
                      tabs: [
                        Tab(child: Align(
                          child: Text('User', style: TextStyle(fontSize: 16)),
                        )),
                        Tab(child: Align(
                          child: Text('Vendor', style: TextStyle(fontSize: 16)),
                        )),
                      ]
                  )
              ),
              body: TabBarView(
                children: [
                  Form(
                      key: _formKey1,
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('*Last name'),
                                fieldBox(lastName, null, false),
                                SizedBox(height: 10),
                                Text('*First name'),
                                fieldBox(firstName, null, false),
                                SizedBox(height: 10),
                                Text('*Date of birth'),
                                Container(
                                    child: TextFormField(
                                      controller: dob,
                                      validator: (string){
                                        dobFormat = false;
                                        if(string.isEmpty){
                                          return 'Compulsory field cannot be empty';
                                        }
                                        try{
                                          dobDT = DateFormat('dd/MM/yyyy').parseStrict(string);
                                          yearOfUser = int.parse(DateFormat('yyyy').format(dobDT));
                                          if(yearOfUser >= 1900 && yearOfUser < yearNow){
                                            dobFormat = true;
                                            return null;
                                          }
                                          return 'Wrong date format';
                                        } catch(e){
                                          return 'Wrong date format';
                                        }
                                      },
                                      decoration: InputDecoration(
                                          hintText: "DD/MM/YYYY",
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                    )
                                ),
                                SizedBox(height: 10),
                                Text('*Contact number'),
                                Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      maxLength: 8,
                                      controller: contactNumber,
                                      validator: (string){
                                        if(string.isEmpty){
                                          /// error message
                                          return 'Compulsory field cannot be empty';
                                        }
                                        if(!registerControl.isValidContactNum(int.parse(contactNumber.text))) {
                                          /// error message
                                          return "Contact number is invalid. Please try again.";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                    )
                                ),
                                SizedBox(height: 10),
                                Text('*Email address'),
                                Container(
                                    child: TextFormField(
                                      controller: email,
                                      validator: (string){
                                        if(string.isEmpty){
                                          /// error message
                                          return 'Compulsory field cannot be empty';
                                        }
                                        return emailValidator;

                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                    )
                                ),
                                SizedBox(height: 10),
                                Text('*Password'),
                                Container(
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: password,
                                      validator: (string){
                                        if(string.isEmpty){
                                          /// error message
                                          return 'Compulsory field cannot be empty';
                                        }
                                        if(!registerControl.isValidPassword(password.text)) {
                                          /// error message
                                          return "Password should contain at least 8 characters with: \n\tAt least 1 Uppercase\n\tAt least 1 Lowercase\n\tAt least 1 digit";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                    )
                                ),                        SizedBox(height: 10),
                                Text('*Confirm password'),
                                Container(
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: confirmPassword,
                                      validator: (string){
                                        if(string.isEmpty){
                                          /// error message
                                          return 'Compulsory field cannot be empty';
                                        }
                                        if(password.text != string){
                                          /// error message
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                    )
                                ),
                                SizedBox(height: 10),
                                Text('Name of next-of-kin'),
                                Container(
                                    child: TextFormField(
                                      controller: nokName,
                                      validator: (string){
                                        if(dobFormat && yearNow - yearOfUser <= 12){
                                          /// error message
                                          return 'Compulsory field cannot be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'For children <12 years old',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                    )
                                ),
                                SizedBox(height: 10),
                                Text('Contact number of next-of-kin'),
                                Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      maxLength: 8,
                                      controller: nokContact,
                                      validator: (string){
                                        if (yearOfUser != null) {
                                          if(yearNow - yearOfUser <= 12){
                                            if(nokContact.text == "")
                                              /// error message
                                              return 'Compulsory field cannot be empty';
                                            if(!registerControl.isValidContactNum(int.parse(nokContact.text)))
                                              /// error message
                                              return "NOK contact number is invalid. Please try again.";
                                          }
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'For children <12 years old',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                    )
                                ),
                                SizedBox(height: 10),
                                Text(
                                    'By signing up, you agree to PowerUp\'s Terms of Service and Privacy Policy',
                                    style: TextStyle(fontSize: 10)
                                ),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: RaisedButton(
                                      color: Colors.red,
                                      child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                          )
                                      ),
                                      onPressed:() async {
                                        bool valid = await registerControl.isValidEmail(email.text);
                                        setState(() {
                                          if(valid){
                                            emailValidator = null;
                                          }
                                          else{
                                            /// error message
                                            emailValidator = "Email Address is invalid or used. Please try again.";
                                          }
                                        });

                                        if(_formKey1.currentState.validate()){
                                          registerControl.sendOtp(email.value.text) ;
                                          setState(() {
                                          });
                                          //if email not in db
                                          String name = firstName.text + " " + lastName.text;
                                          if((yearNow - yearOfUser <= 12) || ((yearNow - yearOfUser > 12) && (nokContact.text != "") && (nokName.text != ""))){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  /// user details, age <=12
                                                    builder: (context) => VerificationPage.fromUser(
                                                        _otpcontroller, name, dob.text, email.text, int.parse(contactNumber.text), password.text, nokName.text, int.parse(nokContact.text)
                                                    ))
                                            );
                                          }
                                          if (yearNow - yearOfUser > 12) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  /// user details, age <=12
                                                    builder: (context) => VerificationPage.fromUser(
                                                        _otpcontroller, name, dob.text, email.text, int.parse(contactNumber.text), password.text, nokName.text, int.parse("-1")
                                                    ))
                                            );
                                          }
                                        }
                                      }),
                                )
                              ],
                            ),
                          )
                      )
                  ),
                  Form(
                      key: _formKey2,
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('*Name of Point of Contact'),
                                    fieldBox(nameOfPOC, null, false),
                                    SizedBox(height: 10),
                                    Text('*Contact Number of Point of Contact'),
                                    Container(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 8,
                                          controller: contactNumOfPOC,
                                          validator: (string){
                                            if(string.isEmpty) {
                                              /// error message
                                              return 'Compulsory field cannot be empty';
                                            }
                                            if(!registerControl.isValidContactNum(int.parse(contactNumOfPOC.text))) {
                                              /// error message
                                              return "Contact number is invalid. Please try again.";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    Text('Business Registration Number'),
                                    Container(
                                        child: TextFormField(
                                          controller: brn,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    Text('Company Name'),
                                    Container(
                                        child: TextFormField(
                                          controller: companyName,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    Text('*Company Email'),
                                    Container(
                                        child: TextFormField(
                                          controller: companyEmail,
                                          validator: (string){
                                            if(string.isEmpty){
                                              /// error message
                                              return 'Compulsory field cannot be empty';
                                            }
                                            return companyValidator;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    Text('*Password'),
                                    Container(
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: companyPassword,
                                          validator: (string){
                                            if(string.isEmpty){
                                              /// error message
                                              return 'Compulsory field cannot be empty';
                                            }
                                            if(!registerControl.isValidPassword(companyPassword.text)) {
                                              /// error message
                                              return "Password should contain at least 8 characters with: \n\tAt least 1 Uppercase\n\tAt least 1 Lowercase\n\tAt least 1 digit";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    Text('*Confirm password'),
                                    Container(
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: companyConfirmPassword,
                                          validator: (string){
                                            if(string.isEmpty){
                                              /// error message
                                              return 'Compulsory field cannot be empty';
                                            }
                                            if(companyPassword.text != string){
                                              /// error message
                                              return 'Passwords do not match';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        'By signing up, you agree to PowerUp\'s Terms of Service and Privacy Policy',
                                        style: TextStyle(fontSize: 10)
                                    ),
                                    SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.center,
                                      child: RaisedButton(
                                          color: Colors.red,
                                          child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                              )
                                          ),
                                          onPressed:() async {
                                            bool valid = await registerControl.isValidEmail(companyEmail.text);
                                            setState(() {
                                              if(valid){
                                                companyValidator = null;
                                              }
                                              else{
                                                /// error message
                                                companyValidator = "Email Address is invalid or used. Please try again.";
                                              }
                                            });
                                            if(_formKey2.currentState.validate()){
                                              registerControl.sendOtp(companyEmail.value.text) ;
                                              setState(() {
                                              });
                                              //if email not in db
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    /// vendor details
                                                      builder: (context) => VerificationPage.fromVendor(
                                                          _otpcontroller, nameOfPOC.text, int.parse(contactNumOfPOC.text), brn.text, companyName.text, companyEmail.text, companyPassword.text
                                                      ))
                                              );
                                            }
                                            return;
                                          }),
                                    )
                                  ]
                              )
                          )
                      )
                  )
                ],
              )
          )
      ),
    );

  }

  /// This is a widget that creates a field box for the user/vendor to input their information
  /// and informs the user/vendor that the field is to be filled should it be left blank
  Widget fieldBox(TextEditingController controller, String hintText, bool obscureText) {
    return Container(
        child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: (string){
            if(string.isEmpty){
              return 'Compulsory field cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
        )
    );
  }
}
