import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/controllers/UserController.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/pages/CoursePage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/pages/UserProfile.dart';
import 'package:powerup/controllers/SearchController.dart';

class HomePage extends StatefulWidget {
  @override
  /// This function displays the Home Page
  User user;
  HomePage(this.user);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  bool showOrderBy = false;
  List<Course> courseList = [];
  List<Course> fullList = [];
  List<Course> popularList = [];
  List<bool> selectedOrderBy;
  List<String> orderByCategories;
  SearchController searchController = SearchController.getInstance();
  UserController userController = UserController.getInstance();

  @override
  void initState(){
    super.initState();
    selectedOrderBy = [false, false, false, false];
    orderByCategories = ['PriceUp', 'PriceDown', 'Popularity', 'Ratings'];
    searchController.allCourses().then((value){
      courseList = value;
      fullList = courseList;
      setState(() {
      });
    });

    search.addListener(() {
      if(search.text.length == 0 && FilterChipWidgetState.selectedFilters.isEmpty){
        setState(() {
          searchController.allCourses().then((value){
            courseList = value;
            fullList = courseList;
            setState(() {
            });
          });
        });
      }
      else if(search.text.length > 0){
        setState(() {
          courseList = searchController.search(search.text, fullList);
          courseList = searchController.sFilterLocationAgeGroupStartMonth(
              FilterChipWidgetState.selectedFilters, courseList);
          showOrderBy = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Power Up!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => UserProfile(
                      widget.user
                  )));
            },
            color: Colors.black,
            iconSize: 30,
          ),
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
            Column(

                children: [Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Container(
                      height: 40,
                      width: 250,
                      margin: EdgeInsets.fromLTRB(20, 20, 0, 10),
                      child: TextField(
                          controller: search,
                          textAlignVertical: TextAlignVertical.bottom,
                          enableInteractiveSelection: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Search course",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          )
                      ),
                    ),
                      IconButton(icon: Icon(Icons.search), onPressed: (){
                        setState(() {
                          if(search.text.isNotEmpty) {
                            showOrderBy = true;
                            courseList = searchController.search(
                                search.text, fullList);
                            courseList = searchController.sFilterLocationAgeGroupStartMonth(
                                FilterChipWidgetState.selectedFilters, courseList);
                          }
                          else {
                            showOrderBy = false;
                            courseList = searchController.sFilterLocationAgeGroupStartMonth(
                                FilterChipWidgetState.selectedFilters, fullList);
                          }
                          setState(() {

                          });
                        });
                        FocusManager.instance.primaryFocus.unfocus();
                      }),
                      IconButton(icon: Icon(Icons.filter_list), onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.close),
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    filterWindow(context),
                                  ],
                                ),
                              );
                            });
                      },),
                    ]
                ),
                  SizedBox(height: 5),
                  showOrderBy == true ?
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ToggleButtons(
                          borderRadius: BorderRadius.circular(6),
                          borderColor: Colors.grey,
                          color: Colors.black,
                          fillColor: Colors.orangeAccent,
                          selectedColor: Colors.black,
                          children:[
                            Text('Price ⬆'),
                            Text('Price ⬇'),
                            Text('Popularity'),
                            Text('Ratings'),
                          ],
                          constraints: BoxConstraints(minWidth: 90, maxWidth: 90, minHeight: kMinInteractiveDimension),
                          onPressed: (index){
                            setState(() {
                              courseList = searchController.search(search.text, fullList);
                              courseList = searchController.sFilterLocationAgeGroupStartMonth(
                                  FilterChipWidgetState.selectedFilters, courseList);
                              for (int i = 0; i < selectedOrderBy.length; i++) {
                                selectedOrderBy[i] = i == index;
                                if(selectedOrderBy[i] == true)
                                  index = i;
                              }
                              if(index == 0){
                                courseList = searchController.orderBy(1, courseList);
                              }
                              if(index == 1){
                                courseList = searchController.orderBy(2, courseList);
                              }
                              if(index == 2){
                                searchController.getPopularityForHomePage(courseList).then((value){
                                  setState(() {
                                    courseList = value;
                                  });
                                });
                                courseList = [];
                              }
                              if(index == 3){
                                courseList = searchController.orderBy(4, courseList);
                              }
                            });
                          },
                          isSelected: selectedOrderBy,
                        )
                      ]
                  ) :
                  Text(''),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(

                          itemCount: courseList.length,
                          itemBuilder: (context, index){
                            return courseTemplate(courseList[index]);
                          }
                      ),
                    ),
                  )
                ]),
          ],
        )
    );
  }

  /// This function creates a widget which displays the courses that are being offered by their course title,
  /// company name, course image and ratings, sorted from highest rating to lowest
  Widget courseTemplate(Course course){
    return GestureDetector(
        onTap:(){
          userController.checkUserRegisteredForCourse(widget.user.emailAddress, course.courseID).then((registered){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => CoursePage(
                    registered, course, widget.user
                )));
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colors.grey[300],
              child: Row(
                  children:[
                    Ink(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(course.url),
                          )
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.courseTitle, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 7),
                            Text(course.company),
                            SizedBox(height: 5),
                            RatingBarIndicator(
                              rating: course.rating,
                              itemBuilder: (_, __){
                                return Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                );
                              },
                              itemSize: 20,
                            )
                          ],
                        ),
                      ),
                    )
                  ]
              )
          ),
        )
    );
  }

  /// This widget displays the filter window that has the filter features for location,
  /// age group, start month and start year
  Widget filterWindow(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Location"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                      spacing: 5,
                      runSpacing: -10,
                      children: [
                        FilterChipWidget(chipName: 'North',),
                        FilterChipWidget(chipName: 'South',),
                        FilterChipWidget(chipName: 'East',),
                        FilterChipWidget(chipName: 'West',),
                        FilterChipWidget(chipName: 'Central',),
                      ]
                  )
              ),

            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Age"),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 5,
                        runSpacing: -10,
                        children: [
                          FilterChipWidget(chipName: '7-12',),
                          FilterChipWidget(chipName: '13-18',),
                          FilterChipWidget(chipName: '19-35',),
                          FilterChipWidget(chipName: '36-55',),
                          FilterChipWidget(chipName: '56-67',),
                        ]
                    )
                )
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Month"),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 5,
                        runSpacing: -10,
                        children: [
                          FilterChipWidget(chipName: 'January',),
                          FilterChipWidget(chipName: 'February',),
                          FilterChipWidget(chipName: 'March',),
                          FilterChipWidget(chipName: 'April',),
                          FilterChipWidget(chipName: 'May',),
                          FilterChipWidget(chipName: 'June',),
                          FilterChipWidget(chipName: 'July',),
                          FilterChipWidget(chipName: 'August',),
                          FilterChipWidget(chipName: 'September',),
                          FilterChipWidget(chipName: 'October',),
                          FilterChipWidget(chipName: 'November',),
                          FilterChipWidget(chipName: 'December',),

                        ]
                    )
                )
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Year"),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 5,
                        runSpacing: -10,
                        children: [
                          FilterChipWidget(chipName: '2021',),
                          FilterChipWidget(chipName: '2022',),
                        ]
                    )
                )
            ),
            SizedBox(height: 30),
            RaisedButton(
                color: Colors.grey[350],
                elevation: 0,
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      if(FilterChipWidgetState.selectedFilters.isNotEmpty) {
                        showOrderBy = true;
                        courseList = searchController.search(search.text, fullList);
                        courseList = searchController.sFilterLocationAgeGroupStartMonth(
                            FilterChipWidgetState.selectedFilters, courseList);


                      }
                      else {
                        showOrderBy = false;
                        courseList = searchController.search(search.text, fullList);

                      }
                      Navigator.of(context).pop();
                    });

                  }


                },
                child: Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
            )
          ]
      ),
    );
  }
}

/// This widget is to act as the code for title containers that will display myTitle in this format
Widget _titleContainer(String myTitle){
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  );
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  FilterChipWidget({Key key, this.chipName}) : super(key: key);
  @override
  FilterChipWidgetState createState() => FilterChipWidgetState();
}

class FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;
  static List<String> selectedFilters = new List();
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      selected: selectedFilters.contains(widget.chipName),
      onSelected: (isSelected){
        setState(() {
          _isSelected = isSelected;
          if(_isSelected){
            selectedFilters.add(widget.chipName);
          }
          else{
            selectedFilters.remove(widget.chipName);
          }
        });
      },
      selectedColor: Colors.lightBlue,
    );
  }
}