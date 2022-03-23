import 'dart:core';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/DBHelper.dart';

class SearchController {

  /// Singleton
  static SearchController single_instance = null;
  static SearchController getInstance()
  {
    if (single_instance == null)
      single_instance = new SearchController();

    return single_instance;
  }

  DBHelper dbHelper = DBHelper.getInstance();

  /// This maps the 12 months from String to int
  Map<String, int> monthMap = {
    "January": 1,
    "February": 2,
    "March": 3,
    "April": 4,
    "May": 5,
    "June": 6,
    "July": 7,
    "August": 8,
    "September": 9,
    "October": 10,
    "November": 11,
    "December": 12
  };

  /// This function maps the first 2 digits of a postal code to a zone
  String getLocation (String address) {
    /// Lists of postal code prefixes for different zones
    List<int> northZone = [53, 54, 55, 82, 56, 57, 72, 73, 77, 78, 75, 76,
      79, 80];
    List<int> southZone = [09, 10, 14,15, 16];
    List<int> eastZone = [34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
      46, 47, 48, 49, 50, 81, 51, 52];
    List<int> westZone = [11, 12, 13, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67,
      68, 69, 70, 71];
    List<int> centralZone = [01, 02, 03, 04, 05, 06, 07, 08, 17, 18, 19,
      20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33];

    /// Extract first 2 digits of postal code from address
    String postalCode = address.substring(address.length - 6);
    int sector = int.parse(postalCode.substring(0,2));
    String zone = "";

    /// Map the first 2 digits to values in the lists of zones
    if (northZone.contains(sector))
      zone = "North";
    else if (southZone.contains(sector))
      zone = "South";
    else if (eastZone.contains(sector))
      zone = "East";
    else if (westZone.contains(sector))
      zone = "West";
    else if (centralZone.contains(sector))
      zone = "Central";
    else
      zone = "Error in getLocation(). Zone could not be found.";
    return zone;
  }

  /// This function searches through the entire list of courses using the general use search function,
  /// to return a list of courses related to the search term
  Future<List<Course>> searchAllCourses(String searchTerm) async {
    List<Course> searchResults = [];
    dbHelper.getAllCourses().then((List<Course> courses) {
      searchResults = search(searchTerm, courses);
    });
    return searchResults;
  }

  /// This function is a general use search function which searches through the list of courses
  /// passed to it as an argument (either full list of courses or filtered list)
  /// to return a list of courses which contains the search term either within their
  /// course title, description or company name
  List<Course> search(String searchTerm, List<Course> listofCourses) {
    List<Course> searchResults = [];
    for (Course course in listofCourses) {
      if (course.courseTitle.toLowerCase().contains(
          searchTerm.toLowerCase()) ||
          course.courseDesc.toLowerCase().contains(searchTerm.toLowerCase()) ||
          course.company.toLowerCase().contains(searchTerm.toLowerCase()))
        searchResults.add(course);
    }
    return searchResults;
  }

  /// This function filters through the list of courses/search results to return a list of courses which
  /// meet any filter value defined for each criteria (e.g. West OR North) and
  /// multiple filter criteria (e.g. Location = 'West' OR 'North' AND Start Month = 'January')
  List<Course> sFilterLocationAgeGroupStartMonth(List<String> filters,
      List<Course> listOfCourses) {
    List<Course> courseList = listOfCourses;
    List<String> locations = [];
    List<String> ageGroups = [];
    List<String> startMonth = [];
    List<String> startYear = [];
    for (int i = 0; i < filters.length; i++) {
      if (filters[i] == 'North' || filters[i] == 'South' ||
          filters[i] == 'East' || filters[i] == 'West' || filters[i] == 'Central') {
        locations.add(filters[i]);
      }
      if (filters[i] == '7-12' || filters[i] == '13-18' ||
          filters[i] == '19-35' || filters[i] == '36-55' ||
          filters[i] == '56-67') {
        ageGroups.add(filters[i]);
      }
      if (monthMap.containsKey(filters[i])) {
        startMonth.add(filters[i]);
      }
      if (filters[i] == "2021" || filters[i] == "2022") {
        startYear.add(filters[i]);
      }
    }
    if (locations.isNotEmpty) {
      List<Course> filterOne = filterLocation(locations, courseList);
      courseList = filterOne;
    }
    if (ageGroups.isNotEmpty) {
      List<Course> filterTwo = filterAgeGroup(ageGroups, courseList);
      courseList = filterTwo;
    }
    if (startMonth.length > 0) {
      List<Course> filterThree = filterMonth(startMonth, courseList);
      courseList = filterThree;
    }
    if (startYear.isNotEmpty) {
      List<Course> filterFour = filterYear(startYear, courseList);
      courseList = filterFour;
    }
    return courseList;
  }

  /// This function filters through the list of courses/search results to return a list of courses which
  /// meet any filter value defined for location criteria (e.g. West OR North)
  List<Course> filterLocation(List<String> locations,
      List<Course> listOfCourses) {
    List<String> zones = [];
    List<Course> filteredCourseList = [];
    for (int i = 0; i < listOfCourses.length; i++) {
      zones.add(getLocation(listOfCourses[i].location));
    }
    for (var i = 0; i < zones.length; i++) {
      for (var j = 0; j < locations.length; j++) {
        if (zones[i].toLowerCase().contains(
            locations[j].toLowerCase())) {
          filteredCourseList.add(listOfCourses[i]);
          break;
        }
        else {
          continue;
        }
      }
    }
    return filteredCourseList;
  }

  /// This function filters through the list of courses/search results to return a list of courses which
  /// meet any filter value defined for age group criteria (e.g. '13-18' OR '19-35')
  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for age group criteria (e.g. '13-18' OR '19-35')
  List<Course> filterAgeGroup(List<String> ageGroups,
      List<Course> listOfCourses) {
    List<Course> filteredCourseList = []; //return variable
    for (int i = 0; i < listOfCourses.length; i++) {
      for (int j = 0; j < ageGroups.length; j++) {
        if (listOfCourses[i].ageGroup == ageGroups[j]) {
          filteredCourseList.add(listOfCourses[i]);
        }
      }
    }
    return filteredCourseList;
  }

  /// This function Filters through the list of courses/search results to return a list of courses which
  /// meet any filter value defined for start month criteria (e.g. 'January' OR 'February')
  List<Course> filterMonth(List<String> startMonth,
      List<Course> listOfCourses) {
    List<int> month = [];
    List<Course> filteredCourseList = [];
    for (int i = 0; i < startMonth.length; i++) {
      month.add(monthMap[startMonth[i]]);
    }

    for (int i = 0; i < listOfCourses.length; i++) {
      for (int j = 0; j < month.length; j++) {
        if (int.parse(listOfCourses[i].startDate.split('/')[1]) == month[j]) {
          filteredCourseList.add(listOfCourses[i]);
        }
      }
    }
    return filteredCourseList;
  }

  /// This function Filters through the list of courses/search results to return a list of courses which
  /// meet any filter value defined for year criteria (e.g. '2021' OR '2022')
  List<Course> filterYear(List<String> startYear, List<Course> listOfCourses) {
    List<int> year = [];
    List<Course> filteredCourseList = [];
    for (int i = 0; i < startYear.length; i++) {
      year.add(int.parse(startYear[i]));
    }
    for (int i = 0; i < listOfCourses.length; i++) {
      for (int j = 0; j < startYear.length; j++) {
        if (int.parse(listOfCourses[i].startDate.split('/')[2]) == year[j]) {
          filteredCourseList.add(listOfCourses[i]);
        }
      }
    }
    return filteredCourseList;
  }

  /// This function orders the list of courses by orderChoice =
  /// 1: price, ascending 2: price, descending 4: popularity
  List<Course> orderBy(int orderChoice, List<Course> listOfCourses) {
    if (orderChoice == 1) {
      listOfCourses.sort((b, a) => a.price.compareTo(b.price));
      return listOfCourses;
    }
    else if (orderChoice == 2) {
      listOfCourses.sort((a, b) => a.price.compareTo(b.price));
      return listOfCourses;
    }
    else if (orderChoice == 4) {
      listOfCourses.sort((b, a) => a.rating.compareTo(b.rating));
      return listOfCourses;
    }
    else {
      return listOfCourses;
    }
  }

  /// This function returns all courses in the database ordered by ratings
  Future<List<Course>> allCourses() async {
    List<Course> topCourses = [];
    topCourses = await dbHelper.getAllCourses();
    topCourses = orderBy(4, topCourses);
    return topCourses;
  }

  /// This function returns a list of courses ordered by popularity (number of
  /// Users who registered for the course)
  Future<List<Course>> getPopularityForHomePage(List<Course> list) async{
    return await dbHelper.getPopularityByCourse(list);
  }
}