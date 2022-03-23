import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Course.dart';
import 'dart:async';
import 'package:powerup/DBHelper.dart';
import 'package:powerup/entities/Session.dart';

class UserController {

  static User user;

  /// Singleton
  static UserController single_instance = null;
  static UserController getInstance()
  {
    if (single_instance == null)
      single_instance = new UserController();

    return single_instance;
  }

  DBHelper dbHelper = DBHelper.getInstance();

  /// This function returns a list of courses that a User has registered
  Future<List<Course>> getUserRegisteredCourse(String emailAddress) async {
    return dbHelper.getRegisterByUser(emailAddress);
  }

  /// This function adds a new course and session into a User's list of registered courses
  void addCourseToList(int courseID, int sessionID,
      String emailAddress) {
    dbHelper.saveRegister(courseID, sessionID, emailAddress);
  }

  /// This function removes an existing course and session from a User's list of registered courses
  void withdrawCourseFromList(String emailAddress, int courseID) {
    dbHelper.deleteRegisterByUser(emailAddress, courseID);
  }

  /// This function checks if the course is registered by a User
  Future<bool> containsRegisteredCourse(int courseID,
      String emailAddress) async {
    var dbClient = await dbHelper.db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * from RegisterTABLE WHERE courseID = ? AND email = ?",
        [courseID, emailAddress]);
    if (maps.isEmpty) {
      return false;
    }
    return true;
  }

  /// This function returns a list of courses that a User has favourited
  Future<List<Course>> getUserFavoriteCourses(String emailAddress) async {
    return dbHelper.getFavForUser(emailAddress);
  }

  /// This function adds a new course into a User's list of favourited courses
  void addFavoriteCourseToList(String emailAddress,
      int courseID) {
    dbHelper.saveFavourite(emailAddress, courseID);
  }

  /// This function removes an existing course from a User's list of favourited courses
  void removeFavoriteCourseFromList(String emailAddress,
      int courseID) async {
    dbHelper.deleteFavCourseByUser(emailAddress, courseID);
  }

  /// This function checks if the course is favourited by a User
  Future<bool> containsFavoriteCourse(String emailAddress, int courseID) async {
    var dbClient = await dbHelper.db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * from Favourite WHERE emailAddress = ? AND courseID = ?",
        [emailAddress, courseID]);
    if (maps.isEmpty) {
      return false;
    }
    return true;
  }

  /// This function returns a list of sessions for a course
  Future<List<Session>> getAllSessionByCourse(int courseID) async {
    return await dbHelper.getSessionsByCourse(courseID);
  }

  /// This function returns a list of sessions with vacancy > 0 for a course
  Future<List<Session>> getAvailSessionByCourse(int courseID) async {
    List<Session> sessionList = await dbHelper.getSessionsByCourse(courseID);
    List<Session> vacancyList = [];
    for (int i = 0; i < sessionList.length; i++) {
      if (sessionList[i].vacancy > 0) {
        vacancyList.add(sessionList[i]);
      }
    }
    return vacancyList;
  }

  /// This function checks if a User is registered for a course
  Future<bool> checkUserRegisteredForCourse(String emailAddress,
      int courseID) async {
    List<Course> courseList = await dbHelper.getRegisterByUser(emailAddress);
    for (int i = 0; i < courseList.length; i++) {
      if (courseList[i].courseID == courseID) {
        return true;
      }
    }
    return false;
  }
}