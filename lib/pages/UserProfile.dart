import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/controllers/UserController.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/pages/CoursePage.dart';

import 'HomePage.dart';
import 'LoginPage.dart';


class UserProfile extends StatefulWidget {

  User user;

  UserProfile(this.user);

  @override
  /// This function displays the User Profile Page
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin {

  List<Course> courseList = [];
  List<Course> favouriteList = [];
  UserController userController = UserController.getInstance();
  User user;
  TabController _controller;
  int length = 0;

  @override
  void initState(){
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    userController.getUserRegisteredCourse(widget.user.emailAddress).then((value) {
      courseList = value;
      setState(() {
      });
    });
    userController.getUserFavoriteCourses(widget.user.emailAddress).then((value) {
      favouriteList = value;
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    String name = widget.user.name;
    String email = widget.user.emailAddress;
    int contactNo = widget.user.contactNum;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      iconSize: 40,
                      onPressed:(){
                        _controller.removeListener(() { });
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HomePage(
                                widget.user
                            )));
                      }
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: ElevatedButton(
                      child: Text('Log Out'),
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            LoginPage()), (Route<dynamic> route) => false);
                      },
                    ),
                  ),

                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Icon(Icons.account_circle, size: 100,),
                  SizedBox(height: 10),
                  Text("Name: " + name, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Email: " + email, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Contact Number: " + contactNo.toString(), style: TextStyle(fontSize: 20),),
                  SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    child: AppBar(
                      backgroundColor: Colors.grey[400],
                      bottom: TabBar(
                        controller: _controller,
                        onTap: (value){
                          if(value == 0){
                            userController.getUserRegisteredCourse(widget.user.emailAddress).then((value) {
                              courseList = value;
                              setState(() {
                              });
                            });
                          }
                          else if(value == 1){
                            userController.getUserFavoriteCourses(widget.user.emailAddress).then((value) {
                              favouriteList = value;
                              setState(() {
                              });
                            });
                          }
                        },
                        tabs: [
                          Tab(
                            icon: Icon(Icons.check, color: Colors.greenAccent[700]),
                          ),
                          Tab(icon: Icon(Icons.favorite, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      children:[
                        Container(
                          child: Column(
                              children:[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  child: Text(
                                    "Registered Courses",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),

                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                    child: Scrollbar(
                                      child: ListView.builder(
                                          itemCount: courseList.length,
                                          itemBuilder: (context, index){
                                            return CourseInProfile(courseList[index]);
                                          }
                                      ),
                                    ),
                                  ),
                                )
                              ]
                          ),

                          color: Colors.grey[350],
                        ),

                        Container(
                          child: Column(
                              children:[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  child: Text(
                                    "Favourited Courses",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                    child: Scrollbar(
                                      child: ListView.builder(
                                          itemCount: favouriteList.length,
                                          itemBuilder: (context, index){
                                            return CourseInProfile(favouriteList[index]);
                                          }
                                      ),
                                    ),
                                  ),
                                )
                              ]
                          ),
                          color: Colors.grey[350],
                        ),
                      ],
                    ),
                  ),
                ],
              ),]
        ),
      ),
    );
  }

  /// This widget is to retrieve the courses that the user has registered/favorite to be displayed
  Widget CourseInProfile(Course course){
    return GestureDetector(
        onTap:(){
          userController.checkUserRegisteredForCourse(widget.user.emailAddress, course.courseID).then((registered){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => CoursePage(
                    registered, course, widget.user
                )));
          });
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(16, 5, 16, 0),
          child: Column(
            children: [
              Text(
                  course.courseTitle,
                  style: TextStyle(
                    fontSize: 18,
                  )
              ),
              SizedBox(height: 6),
              Text(
                course.company,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600]
                ),
              )
            ],

          ),
        )
    );
  }
}