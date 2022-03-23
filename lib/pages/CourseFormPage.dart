import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../entities/Session.dart';
import '../controllers/VendorController.dart';
import '../entities/Course.dart';
import '../pages/VendorProfile.dart';
import '../entities/Vendor.dart';

class CourseFormPage extends StatefulWidget {
  @override
  String companyName;
  String nameOfPoc;
  int contactNumberOfPoc;
  Vendor vendor;
  CourseFormPage(
      this.companyName, this.nameOfPoc, this.contactNumberOfPoc, this.vendor);
  /// This function displays the CourseForm Page
  _CourseFormPageState createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  VendorController vcontroller = VendorController.getInstance();
  String ageGroupDropDown = '7-12 Years';
  int dateOfDT;
  int dateNow = int.parse(DateFormat('yyyy').format(DateTime.now()));
  int sd;
  int j;
  int i;
  bool dobFormat;
  bool sdFormat;
  bool tFormat;
  DateTime dobDT;
  DateTime sdDT;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Widget> sessionWidget = [];
  List<Session> sessionEntryData = [];

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController urlImage = TextEditingController();
  TextEditingController pocName = TextEditingController();
  TextEditingController pocContact = TextEditingController();
  TextEditingController fees = TextEditingController();
  TextEditingController regDeadline = TextEditingController();
  TextEditingController courseStartDate = TextEditingController();
  TextEditingController sessionCount = TextEditingController();
  TextEditingController classSize = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController dateTime = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("New Course"),
      ),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: title,
                    validator: (title) {
                      if (title.isEmpty) {
                        return 'Compulsory field cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Course Title',
                    ),
                  ),
                  TextFormField(
                    controller: description,
                    validator: (description) {
                      if (description.isEmpty) {
                        /// error message
                        return 'Compulsory field cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  TextFormField(
                    controller: location,
                    validator: (location) {
                      if (location.isEmpty) {
                        /// error message
                        return 'Compulsory field cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Location',
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Select Age Group: ',
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        focusColor: Colors.blue,
                        value: ageGroupDropDown,
                        onChanged: (newValue) {
                          setState(() {
                            ageGroupDropDown = newValue;
                          });
                        },
                        /// Age groups displayed
                        items: <String>[
                          '7-12 Years',
                          '13-18 Years',
                          '19-25 Years',
                          '25-35 Years'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: fees,
                    validator: (fees) {
                      tFormat= false;
                      if (fees.isEmpty) {
                        /// error message
                        return 'Compulsory field cannot be empty';
                      }
                      try {
                        /// checking for correct denomination representations
                        if (int.parse(fees) is int || (int.parse(fees)*100) is int) {
                          tFormat = true;
                          return null;
                        }
                        /// error message
                        return 'Please only input numbers.';
                      } catch (e) {
                        /// error message
                        return 'Please only input numbers.';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Course fees:',
                    ),
                  ),
                  TextFormField(
                    controller: urlImage,
                    toolbarOptions: ToolbarOptions(
                      cut: true,
                      copy: true,
                      selectAll: true,
                      paste: true,
                    ),
                    validator: (urlImage) {
                      tFormat = false;
                      if (urlImage.isEmpty) {
                        /// error message
                        return 'Compulsory field cannot be empty';
                      }
                      try {
                        if (Uri.parse(urlImage).isAbsolute) {
                          tFormat = true;
                          return null;
                        }
                        /// error message
                        return 'Input is not a URL.';
                      } catch (e) {
                        /// error message
                        return 'Input is not a URL.';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Course Image(in url):',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: TextFormField(
                        controller: regDeadline,
                        validator: (string) {
                          dobFormat = false;
                          if (string.isEmpty) {
                            /// error message
                            return 'Compulsory field cannot be empty';
                          }
                          try {
                            dobDT = DateFormat('dd/MM/yyyy').parseStrict(string);
                            dateOfDT = int.parse(DateFormat('yyyy').format(dobDT));
                            if (dateOfDT >= dateNow) {
                              dobFormat = true;
                              return null;
                            }
                            /// error message
                            return 'Wrong date format';
                          } catch (e) {
                            /// error message
                            return 'Wrong date format';
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Registration Deadline(DD/MM/YYYY)",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: TextFormField(
                        controller: courseStartDate,
                        validator: (string) {
                          dobFormat = false;
                          if (string.isEmpty) {
                            /// error message
                            return 'Compulsory field cannot be empty';
                          }
                          try {
                            dobDT = DateFormat('dd/MM/yyyy').parseStrict(string);
                            dateOfDT = int.parse(DateFormat('yyyy').format(dobDT));
                            if (dateOfDT >= dateNow) {
                              dobFormat = true;
                              return null;
                            }
                            /// error message
                            return 'Wrong date format';
                          } catch (e) {
                            /// error message
                            return 'Wrong date format';
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Start Date(DD/MM/YYYY)",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 30,
                      width: 160,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.orange,
                          hoverColor: Colors.orangeAccent,
                          onPressed: () {
                            setState(() {
                              sessionWidget.add(Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: classSize,
                                        validator: (count) {
                                          tFormat = false;
                                          if (count.isEmpty) {
                                            /// error message
                                            return 'Compulsory field cannot be empty';
                                          }
                                          try {
                                            if (int.parse(count) is int) {
                                              tFormat = true;
                                              return null;
                                            }
                                            /// error message
                                            return 'Please only input whole numbers.';
                                          } catch (e) {
                                            /// error message
                                            return 'Please only input whole numbers.';
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Session Class Size(e.g. 20)',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          child: TextFormField(
                                            controller: startDate,
                                            validator: (string) {
                                              sdFormat = false;
                                              if (string.isEmpty) {
                                                /// error message
                                                return 'Compulsory field cannot be empty';
                                              }
                                              try {
                                                sdDT = DateFormat('dd/MM/yyyy')
                                                    .parseStrict(string);
                                                dateOfDT = int.parse(
                                                    DateFormat('yyyy').format(sdDT));
                                                if (dateOfDT >= dateNow) {
                                                  sdFormat = true;
                                                  return null;
                                                }
                                                /// error message
                                                return 'Wrong date format';
                                              } catch (e) {
                                                /// error message
                                                return 'Wrong date format';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                hintText:
                                                "Session Start Date(DD/MM/YYYY)",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(16)),
                                                contentPadding:
                                                EdgeInsets.fromLTRB(10, 0, 0, 20)),
                                          )),
                                      TextFormField(
                                        controller: dateTime,
                                        validator: (count) {
                                          tFormat = false;
                                          if (count.isEmpty) {
                                            /// error message
                                            return 'Compulsory field cannot be empty';
                                          }
                                          try {
                                            i = int.parse(count.split(':')[0]);
                                            j = int.parse(count.split(':')[1]);
                                            if (i <= 23 && j <= 59) {
                                              tFormat = true;
                                              return null;
                                            }
                                            /// error message
                                            return 'Wrong time format';
                                          } catch (e) {
                                            /// error message
                                            return 'Wrong time format';
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Session time(HH:MM)',
                                        ),
                                      ),
                                      RaisedButton(
                                          color: Colors.green,
                                          hoverColor: Colors.lightGreenAccent,
                                          child: Text('Save Session',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                              )),
                                          onPressed: () {
                                            Session session = Session(
                                                startDate.text,
                                                dateTime.text,
                                                int.parse(classSize.text),
                                                int.parse(classSize.text));
                                            setState(() {
                                              sessionEntryData.add(session);
                                            });
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (builder) {
                                                  return AlertDialog(
                                                      backgroundColor: Colors.green,
                                                      title: Text(
                                                        'Session Saved! To create another session, re-enter new session details',
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      content: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            FlatButton(
                                                              child: Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(context, rootNavigator: true).pop();
                                                              },
                                                            ),
                                                          ]));
                                                });
                                          })
                                    ],
                                  )));
                            });
                          },
                          child: Text('Add Session',
                              style:
                              TextStyle(fontSize: 20, color: Colors.white)))),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                      child: Column(
                        children: List.generate(sessionWidget.length, (i) {
                          return sessionWidget[i];
                        }),
                      )),
                  Container(
                    height: 40,
                    width: 250,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.blue,
                        hoverColor: Colors.lightGreenAccent,
                        child: Text('Submit',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                            )),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Course course = Course(
                                title.text,
                                description.text,
                                widget.companyName,
                                0,
                                double.parse(fees.text),
                                urlImage.text,
                                location.text,
                                ageGroupDropDown,
                                widget.nameOfPoc,
                                widget.contactNumberOfPoc,
                                courseStartDate.text,
                                regDeadline.text);
                            String string = 'Course Title: '+
                                /// course details processing
                                course.courseTitle.toString() +
                                '\n' +
                                'Course Description: ' +
                                course.courseDesc.toString() +
                                '\n' +
                                'Location: ' +
                                course.location.toString() +
                                '\n' +
                                'Age Group: ' +
                                course.ageGroup.toString() +
                                '\n' +
                                'Course Fees: \$' +
                                course.price.toString() +
                                '\n' +
                                'Start Date: ' +
                                course.startDate.toString() +
                                '\n' +
                                'Registration Deadline: ' +
                                course.regDeadline.toString() +
                                '\n' +
                                '\n';
                            for (int i = 0; i < sessionEntryData.length; i++) {
                              string += 'Session ' +
                                  (i + 1).toString() +
                                  ": " +
                                  sessionEntryData[i].startDate +
                                  ", " +
                                  sessionEntryData[i].dateTime +
                                  ", " +
                                  'class size: ' +
                                  sessionEntryData[i].classSize.toString() +
                                  "\n";
                            }
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Course Details"),
                                    content: Text("$string"), //add question details
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text("Confirm"),
                                          onPressed: () {
                                            _formKey.currentState.save();
                                            vcontroller.addCourseToDB(
                                                course, sessionEntryData);
                                            Navigator.of(context, rootNavigator: true).pop();
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              4.0)),
                                                      child: Stack(
                                                        overflow: Overflow.visible,
                                                        alignment:
                                                        Alignment.topCenter,
                                                        children: [
                                                          Container(
                                                            height: 450,
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  10,
                                                                  70,
                                                                  10,
                                                                  10),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    /// confirmation message
                                                                    "The following course has been successfully created - ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20),
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                  ),
                                                                  SizedBox(
                                                                      height: 20),
                                                                  Text(
                                                                    title.text,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        30,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                  ),
                                                                  SizedBox(
                                                                      height: 20),
                                                                  RaisedButton(
                                                                    onPressed: () {
                                                                      Navigator.of(
                                                                          context)
                                                                          .pop();
                                                                      Navigator.of(
                                                                          context)
                                                                          .pop();
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  VendorProfile(widget.vendor)));
                                                                    },
                                                                    color:
                                                                    Colors.red,
                                                                    child: Text(
                                                                      'Back to Profile',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                          20),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              top: -40,
                                                              child: CircleAvatar(
                                                                backgroundColor:
                                                                Colors.green,
                                                                radius: 30,
                                                                child: Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 40),
                                                              )),
                                                        ],
                                                      ));
                                                });
                                          }),
                                      FlatButton(
                                        child: Text("Edit"),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      )
                                    ],
                                  );
                                });
                          }
                        }),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

/// This function creates a widget which allows the Vendor to input details about
/// a session
Widget sessionCreate() {
  DateTime sdDT;
  int sd;
  bool sdFormat;
  int yearNow = int.parse(DateFormat('yyyy').format(DateTime.now()));
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController vacancies = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController dateTime = TextEditingController();
  return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            controller: vacancies,
            validator: (count) {
              if (count.isEmpty) {
                /// error message
                return 'Compulsory field cannot be empty';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Session Class Vacancies(e.g. 20)',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              child: TextFormField(
                controller: startDate,
                validator: (string) {
                  sdFormat = false;
                  if (string.isEmpty) {
                    /// error message
                    return 'Compulsory field cannot be empty';
                  }
                  try {
                    sdDT = DateFormat('dd/MM/yyyy').parseStrict(string);
                    sd = int.parse(DateFormat('yyyy').format(sdDT));
                    if (sd >= 1900 && sd < yearNow) {
                      sdFormat = true;
                      return null;
                    }
                    /// error message
                    return 'Wrong date format';
                  } catch (e) {
                    /// error message
                    return 'Wrong date format';
                  }
                },
                decoration: InputDecoration(
                    hintText: "Session Start Date(DD/MM/YYYY)",
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
              )),
          TextFormField(
            controller: dateTime,
            validator: (count) {
              if (count.isEmpty) {
                /// error message
                return 'Compulsory field cannot be empty';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Session time(HH:MM)',
            ),
          ),
          RaisedButton(
              color: Colors.green,
              hoverColor: Colors.lightGreenAccent,
              child: Text('Save Session',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  )),
              onPressed: () {
                if (_formKey2.currentState.validate()) {}
              })
        ],
      ));
}