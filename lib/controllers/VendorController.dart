import 'dart:core';
import 'package:powerup/entities/Session.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:powerup/entities/Course.dart';
import 'dart:async';
import 'package:powerup/DBHelper.dart';
import '../entities/Vendor.dart';


class VendorController {

  /// Singleton
  static VendorController single_instance = null;
  static VendorController getInstance()
  {
    if (single_instance == null)
      single_instance = new VendorController();

    return single_instance;
  }

  static Vendor vendor;
  DBHelper dbHelper = DBHelper.getInstance();

  ///This function adds a course created by the vendor to the database
  Future<bool> addCourseToDB(Course course, List<Session> sessions) async {
    return  dbHelper.addCourse(course, sessions);
  }

  ///This function removes an existing course from the vendor in the database
  Future<bool> removeCourseFromDB(int courseToRemoveID) async {
    return dbHelper.removeCourse(courseToRemoveID);
  }

  ///This function retrieves from the database and returns the list of participants lists
  ///for all sessions of that course
  Future<List<List<String>>> viewParticipants(int courseID) async {
    List<List<String>> listOfParticipantsList = [];
    List<Session> sessionList = await dbHelper.getSessionsByCourse(courseID);
    for(int i =0;i<sessionList.length;i++){
      List<String> participantsList = [];
      List<String> iterateList = await dbHelper.getRegisterBySession(sessionList[i].sessionID);
      for (int j = 0; j<iterateList.length; j++){
        participantsList.add(iterateList[j]);
      }
      List<String> nameList = await dbHelper.getUserByEmail(participantsList);
      listOfParticipantsList.add(nameList);
    }
    return listOfParticipantsList;
  }

  /// This function retrieves from the database and returns the list of sessions of that course
  Future<List<Session>> getCourseSessions(int courseID) async{
    List<Session> sessions = await dbHelper.getSessionsByCourse(courseID);
    return sessions;
  }

  ///This function retrieves from the database and returns the vacancy of a session of that course
  Future<int> getVacancyOfSession(int courseID, int sessionID) async{
    int vacancy;
    List<Session> sessions = await dbHelper.getSessionsByCourse(courseID);
    for (int i = 0; i < sessions.length; i++) {
      if (sessionID == sessions[i].sessionID) {
        vacancy=sessions[i].vacancy;
      }
    }
    return vacancy;
  }

  /// This functions retrieves from database and returns the list of courses that the vendor has created
  Future<List<Course>> getVendorCreatedCourses(int contactNumberPoc){
    return dbHelper.getVendorCourse(contactNumberPoc);
  }
}