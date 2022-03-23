import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/pages/CourseFormPage.dart';
import '../pages/VendorCoursePage.dart';
import '../entities/Vendor.dart';
import '../controllers/VendorController.dart';
import '../pages/CourseFormPage.dart';
import '../pages/LoginPage.dart';

class VendorProfile extends StatefulWidget {

  Vendor vendor;

  VendorProfile(this.vendor);

  @override
  /// This function displays the Vendor Profile Page
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {

  ScrollController scrollController = ScrollController();
  VendorController vcontroller = VendorController.getInstance();
  List<Widget> itemsData = [];

  @override
  void initState() {
    super.initState();
    List<Widget> listItems = [];
    vcontroller
        .getVendorCreatedCourses(widget.vendor.contactNumOfPOC)
        .then((courseList) {
      courseList.forEach((course) {
        listItems.add(Container(
          padding: EdgeInsets.fromLTRB(10,10,10,0),
          height: 60,
          width: double.maxFinite,
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => VendorCoursePage(course, widget.vendor))
                );
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
                child: Column(
                  children: [
                    SizedBox(height:5 ),
                    Text(course.courseTitle,
                      style: TextStyle(
                        fontSize: 22,), textAlign: TextAlign.center,),
                  ],
                ),
              )),
        ));
      });
      setState(() {
        itemsData = listItems;
      });
    });
  }
  /// This widget is to display vendor's details and courses
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Power Up!',
            style: TextStyle(color: Colors.black, fontSize: 28),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ))),
          Column(
            children: <Widget>[
              Row(
                children: [
                  SizedBox(height: 30),
                  Container(
                      height: 30,
                      width: 140,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.blue,
                          hoverColor: Colors.lightBlueAccent,
                          onPressed: () {
                            /// navigates back to login page
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                LoginPage()), (Route<dynamic> route) => false);
                          },
                          child: Text('Log Out',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white))))
                ],
              ),
              Icon(
                Icons.account_circle,
                size: 100,
              ),
              /// vendor's details displayed on profile page
              SizedBox(height: 10),
              Text("Company Name:  ${widget.vendor.companyName}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text("Name of POC: ${widget.vendor.nameOfPOC}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text("Email: ${widget.vendor.emailAddress}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text(
                "Contact Number: ${widget.vendor.contactNumOfPOC}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  child: Column(children: [
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                          child: Text(
                            "My Courses",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 50),
                        Container(
                            height: 30,
                            width: 140,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color: Colors.blue,
                                hoverColor: Colors.lightBlueAccent,
                                onPressed: () {
                                  /// navigates to course form page for vendor to add course
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => CourseFormPage(
                                              widget.vendor.companyName, widget.vendor.nameOfPOC, widget.vendor.contactNumOfPOC, widget.vendor
                                          ))
                                  );
                                },
                                /// add course button
                                child: Text('Add Course',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white))))
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: scrollController,
                            itemCount: itemsData.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return itemsData[index];
                            })),
                  ]),
                  color: Colors.grey[350],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
