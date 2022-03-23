import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/controllers/LoginRegisterController.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:powerup/pages/VendorProfile.dart';
import 'HomePage.dart';


class VerificationPage extends StatefulWidget {

  TextEditingController otpcontroller = TextEditingController();
  String name;
  String dob;
  String userEmail;
  int contactNumber;
  String password;
  String nokName;
  int nokContact;
  String nameOfPoc;
  int contactNumOfPOC;
  String brn;
  String companyName;
  String companyEmail;
  String companyPassword;

  VerificationPage.fromUser(this.otpcontroller, this.name, this.dob, this.userEmail, this.contactNumber, this.password, this.nokName, this.nokContact);
  VerificationPage.fromVendor(this.otpcontroller, this.nameOfPoc, this.contactNumOfPOC, this.brn, this.companyName, this.companyEmail, this.companyPassword);

  @override
  /// This function displays the Verification Page
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> with TickerProviderStateMixin {

  User user;
  Vendor vendor;
  bool countdownEnd = false;
  TextEditingController _otpcontroller = TextEditingController();
  LoginRegisterController loginRegController = LoginRegisterController.single_instance;
  String email;
  String name;
  String dob;
  String userEmail;
  int contactNumber;
  String password;
  String nokName;
  int nokContact;
  String nameOfPoc;
  String brn;
  String companyName;
  String companyEmail;
  String companyPassword;
  AnimationController _controller;
  int levelClock = 1800;
  int _counter;
  Timer _timer;


  @override
  void initState() {
    super.initState();

    if (widget.companyEmail == null) {
      assignEmail(widget.userEmail);
    }
    else if (widget.userEmail == null) {
      assignEmail(widget.companyEmail);
    }
    _startTimer(levelClock);
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock)

    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
          appBar: AppBar(
            title: const Text('Verification Page'),
          ),

          body: Builder(builder:(context){
            return Center(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text('Countdown until verification code expires'),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 50,
                        width: 200,
                        color: Colors.grey,
                        child: Center(

                          child : Countdown(
                            animation: StepTween(
                              begin: levelClock,
                              end: 0,

                            ).animate(_controller),
                          ),),
                      ),

                      //Verification Functions
                      SizedBox(height: 30),
                      Center(
                          child: Text(
                              'A verification code has been sent to ' + email,
                            textAlign: TextAlign.center,
                          )
                      ),

                      Text('Please enter the corresponding verification OTP'),
                      fieldBox(widget.otpcontroller, null, false),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 50,
                        width: 200,
                        color: Colors.green[400],

                        child: MaterialButton(
                          onPressed:() async {
                            print(email);
                            print(widget.otpcontroller.value.text);
                            if(loginRegController.verify(email, widget.otpcontroller.value.text)) {
                              _timer.cancel();
                              _controller.dispose();
                              if (widget.companyEmail == null) {
                                /// user creation
                                User user = await loginRegController.createUser(widget.name,
                                    widget.dob,
                                    widget.userEmail,
                                    widget.contactNumber,
                                    widget.password,
                                    widget.nokName,
                                    widget.nokContact);
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(
                                              /// user object
                                              user
                                            ))
                                );
                              }
                              else if (widget.userEmail == null) {
                                /// vendor creation
                                Vendor vendor = await loginRegController.createVendor(
                                    widget.companyEmail,
                                    widget.nameOfPoc,
                                    widget.contactNumOfPOC,
                                    widget.companyPassword,
                                    widget.brn,
                                    widget.companyName);
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VendorProfile(
                                                /// vendor object
                                                vendor
                                            ))
                                );
                              }
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'The input Verification Code is invalid',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    duration: const Duration(seconds: 5),
                                  ));
                            }
                          },
                          child: Center(
                            child: Text(
                              "Verify",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),


                      /// Resent OTP function
                      (_counter == 0)
                          ? Card(
                        margin: EdgeInsets.only(top: 20),
                        elevation: 6,
                        child: Container(
                          height: 50,
                          width: 200,
                          color: Colors.green[400],
                          child: ElevatedButton (
                            onPressed:() async {
                              ///resend OTP
                              loginRegController.sendOtp(email);
                              setState(() {
                              });
                              ///Snackbar to notify user that it has been resent
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'OTP code has been resent to ' + email,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: Colors.blue,
                                    duration: const Duration(seconds: 5),
                                  ));
                              ///restart timer
                              ///verification code update
                              if (widget.companyEmail == null) {
                                /// passing user object
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VerificationPage.fromUser(
                                                _otpcontroller, widget.name, widget.dob, widget.userEmail, widget.contactNumber, widget.password, widget.nokName, widget.nokContact
                                              ))
                                  );
                              }
                              else if (widget.userEmail == null) {
                                /// passing vendor object
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                            VerificationPage.fromVendor(
                                            _otpcontroller, widget.nameOfPoc, widget.contactNumOfPOC, widget.brn, widget.companyName, widget.companyEmail, widget.companyPassword
                                              ))
                                  );
                              }

                            },
                            child: Center(
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          :SizedBox(height: 1)
                    ],

                  ),
                ));
          })
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

  void assignEmail(String emailAss){
    email = emailAss;
  }

  void _startTimer(levelClock) {
    _counter = levelClock - 1;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }
}

/// Countdown animation for the countdown timer
class Countdown extends AnimatedWidget {

  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 40,
        color: Theme.of(context).bottomAppBarColor,
      ),
    );
  }

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