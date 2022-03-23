import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:powerup/entities/Session.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class DBHelper {

  /// Singleton
  static DBHelper single_instance = null;
  static DBHelper getInstance()
  {
    if (single_instance == null)
      single_instance = new DBHelper();

    return single_instance;
  }

  static Database _db;

  static const String DB_NAME = 'MainDB.db';

  //User Table
  static const String UserTABLE = 'User';
  static const String name = 'name';
  static const String dob = 'DOB';
  static const String emailAddress = 'emailAddress';
  static const String contactNum = 'contactNum';
  static const String passU = 'passwordU';
  static const String NOKname = 'NOKname';
  static const String NOKNum = 'NOKcontactNum';

  //Vendor Table
  static const String VendorTABLE = 'Vendor';
  static const String nameOfPOC = 'nameOfPOC';
  static const String contactNumOfPOC = 'contactNumOfPOC';
  static const String passV = 'passwordV';
  static const String busRegNum = 'busRegNum';
  static const String compName = 'companyName';

  //Course Table
  static const String CourseTABLE = 'Course';
  static const String courseID = 'courseID';
  static const String courseTitle = 'courseTitle';
  static const String courseDesc = 'courseDesc';
  static const String rating = 'rating';
  static const String price = 'price';
  static const String url = 'url';
  static const String location = 'location';
  static const String ageGroup = 'ageGroup';
  static const String startDate = 'startDate';
  static const String regDeadline = 'regDeadline';

  //Fav Table
  static const String FavTABLE = 'Favourite';

  //Session Table
  static const String SessionTABLE = 'Session';
  static const String sessionID = 'sessionID';
  static const String startDateOfSession = 'startDate';
  static const String dateTime = 'dateTime';
  static const String vacancy = 'vacancy';
  static const String classSize = 'classSize';

  //Register
  static const String RegisterTABLE = 'Register';

  /// This function initializes a new database when the current database is null,
  /// and returns the current database when it is not null
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// This function enables foreign key support
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// If the current database is not null, this function executes to retrieve the
  /// current database
  initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "MainDB.db");
    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "MainDB.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    var db = await openDatabase(path, readOnly: false);
    return db;
  }

  /// This function creates all the tables for the database
  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $UserTABLE ($name TEXT,"
        "$dob TEXT,$emailAddress TEXT PRIMARY KEY,$contactNum INTEGER, $passU TEXT,"
        "$NOKname TEXT,$NOKNum INTEGER)");

    await db.execute(
        "CREATE TABLE $VendorTABLE ($emailAddress TEXT PRIMARY KEY, $nameOfPOC TEXT, $contactNumOfPOC INTEGER, $passV TEXT, $busRegNum TEXT, $compName TEXT)");

    await db.execute(
        "CREATE TABLE $CourseTABLE ($courseID INTEGER NOT NULL, $courseTitle TEXT NOT NULL, $courseDesc TEXT, $compName TEXT, $rating REAL, $price REAL, $url TEXT, $location TEXT, $ageGroup TEXT, $nameOfPOC TEXT, $contactNumOfPOC INTEGER, $startDate TEXT, $regDeadline TEXT, PRIMARY KEY(\"courseID\" AUTOINCREMENT))");

    await db.execute(
        "CREATE TABLE $FavTABLE ($emailAddress TEXT NOT NULL, $courseID INTEGER NOT NULL, PRIMARY KEY(\"emailAddress\", \"courseID\"),FOREIGN KEY(\"emailAddress\") REFERENCES \"User\"(\"emailAddress\") ON DELETE CASCADE)");

    await db //Session
        .execute("CREATE TABLE $SessionTABLE ($sessionID INTEGER NOT NULL, "
        "$courseID INTEGER NOT NULL, $startDateOfSession TEXT NOT NULL, $dateTime TEXT NOT NULL, "
        "$vacancy INTEGER NOT NULL, $classSize INTEGER NOT NULL, "
        "PRIMARY KEY($sessionID AUTOINCREMENT),"
        "FOREIGN KEY($courseID) REFERENCES $CourseTABLE($courseID)"
        "ON DELETE CASCADE)");

    await db //Register
        .execute(
        "CREATE TABLE $RegisterTABLE ($emailAddress TEXT NOT NULL, $sessionID INTEGER NOT NULL, $courseID INTEGER NOT NULL,"
            "PRIMARY KEY($emailAddress, $sessionID, $courseID),"
            "FOREIGN KEY($emailAddress) REFERENCES $UserTABLE($emailAddress)"
            "ON DELETE CASCADE,"
            "FOREIGN KEY($sessionID) REFERENCES $SessionTABLE($sessionID)"
            "ON DELETE CASCADE,"
            "FOREIGN KEY($courseID) REFERENCES $CourseTABLE($courseID)"
            "ON DELETE CASCADE)");
  }

  /// This function saves a new course into the Course table
  Future<Course> saveCourse(Course course) async {
    var dbClient = await db;
    await dbClient.insert(CourseTABLE, course.toMap());
    return course;
  }

  /// This function saves a new user into the User table
  Future<User> saveUser(User user) async {
    var dbClient = await db;
    await dbClient.insert(UserTABLE, user.toMap());
    return user;
  }

  /// This function saves a new vendor into the Vendor table
  Future<Vendor> saveVendor(Vendor vendor) async {
    var dbClient = await db;
    await dbClient.insert(VendorTABLE, vendor.toMap());
    return vendor;
  }

  /// This function saves a user's favourite course into the Favourite Table
  Future<bool> saveFavourite(String email, int courseID) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        "INSERT INTO $FavTABLE(emailAddress,courseID) VALUES (?,?)",
        [email, courseID]);
    return true;
  }

  /// This function saves a new session into the Session table
  Future<Session> saveSession(Session session, int courseID) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        "INSERT INTO $SessionTABLE(courseID,startDate,dateTime,vacancy,classSize) VALUES (?, ?, ?, ?, ?)",
        [courseID, session.startDate, session.dateTime, session.vacancy, session.classSize]);
    return session;
  }

  /// This function saves a new registered course and session for a user into the Register table
  Future<bool> saveRegister(
      int courseID, int sessionID, String userEmail) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        "INSERT INTO Register(emailAddress, sessionID, courseID) VALUES(?,?,?)",
        [userEmail, sessionID, courseID]);
    return true;
  }

  /// This function returns a list of all courses from the Course table
  Future<List<Course>> getAllCourses() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $CourseTABLE");
    List<Course> courses = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        courses.add(Course.forHomePage(maps[i]));
      }
    }
    return courses;
  }

  /// This function returns a course object given a courseID from the Course table
  Future<Course> getCourseById(int courseID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .rawQuery("SELECT * FROM $CourseTABLE WHERE courseID = ?", [courseID]);
    List<Course> courses = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        courses.add(Course.forHomePage(maps[i]));
      }
    }
    return courses[0];
  }

  /// This function returns a list of all users from the User table
  Future<List<User>> getAllUsers() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(UserTABLE,
        columns: [name, dob, emailAddress, contactNum, passU, NOKname, NOKNum]);
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  /// This function returns a list of all vendors from the Vendor table
  Future<List<Vendor>> getAllVendors() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(VendorTABLE,
        columns: [emailAddress, nameOfPOC, contactNumOfPOC, passV, busRegNum, compName]);
    List<Vendor> vendors = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        vendors.add(Vendor.fromMap(maps[i]));
      }
    }
    return vendors;
  }

  /// This function returns a list of favourited courses by a user from the Favourite table
  Future<List<Course>> getFavForUser(String email) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT courseID from Favourite WHERE emailAddress = ?", [email]);
    List<Course> courseList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Course course = await getCourseById(maps[i]['courseID']);
        courseList.add(course);
      }
    }
    return courseList;
  }

  /// This function returns a list of sessions from the Session table
  Future<List<Session>> getAllSessions() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(SessionTABLE,
        columns: [sessionID, courseID, startDate, dateTime, vacancy, classSize]);
    List<Session> sessions = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        sessions.add(Session.fromMap(maps[i]));
      }
    }
    return sessions;
  }

  /// This function returns a list of sessions given a courseID from the
  /// Session table
  Future<List<Session>> getSessionsByCourse(int courseID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .rawQuery("SELECT * FROM $SessionTABLE WHERE courseID = ?", [courseID]);
    List<Session> sessions = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        sessions.add(Session.fromMap(maps[i]));
      }
    }
    return sessions;
  }

  /// This function returns a list of email addresses of users registered in a
  /// session from the Register table
  Future<List<String>> getRegisterBySession(int sessionID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT emailAddress FROM Register WHERE sessionID = ?", [sessionID]);
    List<String> register = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        register.add(maps[i]['emailAddress']);
      }
    }
    return register;
  }

  /// This function returns a list of names of users registered for each session for
  /// the particular course that the vendor wants to see
  Future<List<String>> getUserByEmail(List<String> emailAddress) async {
    var dbClient = await db;
    List<Map> maps = [];
    List<String> usernameList = [];
    print(emailAddress.length);
    for (int i = 0; i < emailAddress.length; i++) {
      maps = await dbClient.rawQuery(
          "SELECT name FROM User WHERE emailAddress = ?", [emailAddress[i]]);
      usernameList.add(maps[0]['name']);
    }
    List<String> protectUserEmailAddress = [];
    if (usernameList.length > 0) {
      for (int i = 0; i < usernameList.length; i++) {
        protectUserEmailAddress.add(usernameList[i]);
      }
    }
    return protectUserEmailAddress;
  }

  /// This function returns a list of courses that a user has registered from
  /// the Register table
  Future<List<Course>> getRegisterByUser(String userEmail) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT courseID from Register WHERE emailAddress = ?", [userEmail]);
    List<Course> courseList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Course course = await getCourseById(maps[i]['courseID']);
        courseList.add(course);
      }
    }
    return courseList;
  }

  /// This function returns a list of courses that a vendor has created from the
  /// Course table
  Future<List<Course>> getVendorCourse(int contactNumberPoc) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM Course WHERE contactNumOfPOC = ?", [contactNumberPoc]);
    List<Course> courses = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        courses.add(Course.fromMap(maps[i]));
      }
    }
    return courses;
  }

  /// This function deletes a course from the Course table
  Future<bool> deleteCourse(int courseID) async {
    var dbClient = await db;
    await dbClient
        .delete(CourseTABLE, where: 'courseID = ?', whereArgs: [courseID]);
    return true;
  }

  /// This function deletes a user from the User table
  Future<bool> deleteUser(String emailAddress) async {
    var dbClient = await db;
    await dbClient.delete(UserTABLE,
        where: 'emailAddress = ?', whereArgs: [emailAddress]);
    return true;
  }

  /// This function deletes a vendor from the Vendor table
  Future<bool> deleteVendor(String emailAddress) async {
    var dbClient = await db;
    await dbClient.delete(VendorTABLE,
        where: 'emailAddress = ?', whereArgs: [emailAddress]);
    return true;
  }

  /// This function deletes a course from a user's list of favourited courses from
  /// the Favourite table
  Future<bool> deleteFavCourseByUser(String emailAddress, int courseID) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        "DELETE FROM Favourite WHERE emailAddress = ? AND courseID = ?",
        [emailAddress, courseID]);
    return true;
  }

  /// This function deletes a session from the Session table
  Future<bool> deleteSession(int sessionID, int courseID) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        'DELETE FROM Session WHERE sessionID = ? AND courseID = ?',
        [sessionID, courseID]);
    return true;
  }

  /// This function deletes all the courseID from the Register table when the
  /// course is removed
  Future<bool> deleteRegisterByCourse(int courseID) async {
    var dbClient = await db;
    await dbClient
        .delete(RegisterTABLE, where: 'courseID = ?', whereArgs: [courseID]);
    return true;
  }

  /// This function deletes a user from the Register table when he withdraws
  /// from a course
  Future<bool> deleteRegisterByUser(String userEmail, int courseID) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        "DELETE FROM Register WHERE emailAddress = ? AND courseID = ?",
        [userEmail, courseID]);
    return true;
  }

  /// This function deletes all the sessionID from the Register table when the
  /// session is removed
  Future<bool> deleteRegisterBySession(int sessionID) async {
    var dbClient = await db;
    await dbClient
        .rawDelete("DELETE FROM Register WHERE sessionID = ?", [sessionID]);
    return true;
  }

  /// This function updates an existing course in the Course table
  Future<bool> updateCourse(Course course) async {
    var dbClient = await db;
    await dbClient.update(CourseTABLE, course.toMap(),
        where: 'courseID = ?', whereArgs: [course.courseID]);
    return true;
  }

  /// This function updates an existing user in the User table
  Future<bool> updateUser(User user) async {
    var dbClient = await db;
    await dbClient.update(UserTABLE, user.toMap(),
        where: 'emailAddress = ?', whereArgs: [user.emailAddress]);
    return true;
  }

  /// This function updates an existing vendor in the Vendor table
  Future<bool> updateVendor(Vendor vendor) async {
    var dbClient = await db;
    await dbClient.update(VendorTABLE, vendor.toMap(),
        where: 'emailAddress = ?', whereArgs: [vendor.emailAddress]);
    return true;
  }

  /// This function updates an existing session in the Session table
  Future<bool> updateSession(Session session) async {
    var dbClient = await db;
    await dbClient.update(SessionTABLE, session.toMap(),
        where: 'sessionID = ?', whereArgs: [session.sessionID]);
    return true;
  }

  /// This function updates the Register table when a new user registers for a
  /// course/session
  Future<bool> updateRegister(
      int courseID, int sessionID, String userEmail) async {
    var dbClient = await db;
    await dbClient.rawUpdate(
        'UPDATE Register SET email = ? '
            'WHERE sessionID = ? AND courseID = ?',
        [sessionID, courseID]);
    return true;
  }

  /// This function adds sessions into the Session table and adds a new course
  /// into the Course table
  Future<bool> addCourse(Course course, List<Session> sessions) async {
    await saveCourse(course);
    int courseID = await getLatestCourseID();
    for (int i = 0; i < sessions.length; i++) {
      await saveSession(sessions[i], courseID);
    }
    return true;
  }

  /// This function returns the latest, largest courseID
  Future<int> getLatestCourseID() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery("SELECT MAX(courseID) as latest_id FROM Course;");
    int courseID = maps.first['latest_id'];
    return courseID;
  }

  /// This function gets the email addresses of the participants of a course and sends them a notification
  /// before removing the relevant data from respective tables
  Future<bool> removeCourse(int courseID) async {
    String username = 'studentemailtester2020@gmail.com';
    String password = 'studentemailpassword2020';
    final smtpServer = gmail(username, password);

    List<Session> sessions = await getSessionsByCourse(courseID);
    for (int j = 0; j < sessions.length; j++) {
      List<String> emails = await getRegisterBySession(sessions[j].sessionID);
      for (int k = 0; k < emails.length; k++) {
        // Create message
        final message = Message()
          ..from = Address(username, 'PowerUp!')
          ..recipients.add(emails[k])
          ..subject = 'PowerUp! Course Removal Notification :: ${DateTime.now()}'
          ..text =
              'Apologies. We regret to inform you that the course you have registered for has been removed.\n';
        /// Send email to notify participants
        try {
          final sendReport = await send(message, smtpServer);
          print('Message sent: ' + sendReport.toString());
        } on MailerException catch (e) {
          print('Message not sent.');
          for (var p in e.problems) {
            print('Problem: ${p.code}: ${p.msg}');
          }
        }
      }
    }

    for (int i = 0; i < sessions.length; i++) {
      deleteSession(sessions[i].sessionID, courseID);
    }
    await deleteRegisterByCourse(courseID);
    await deleteCourse(courseID);
    return true;
  }

  /// This function returns a list of courses ordered by their popularity
  Future<List<Course>> getPopularityByCourse(List<Course> list) async {
    var dbClient = await db;
    List<Course> courseList = [];
    List<Map> maps = await dbClient.rawQuery(
        "SELECT courseID FROM Register GROUP BY courseID ORDER BY COUNT(courseID) DESC");
    for (int i = 0; i < maps.length; i++) {
      int i1 = maps[i][courseID];
      for (int j = 0; j < list.length; j++) {
        int i2 = list[j].courseID;
        if (i1 == i2) {
          courseList.add(await getCourseById(i1));
        }
      }
    }
    List<Course> courses = list;
    bool exist = false;
    for (int i = 0; i < courses.length; i++) {
      exist = false;
      for (int j = 0; j < courseList.length; j++) {
        if (courseList[j].courseID == courses[i].courseID) {
          exist = true;
          break;
        }

      }
      if (exist == false) {
        courseList.add(courses[i]);
      }
    }
    return courseList;
  }

  /// This function closes the database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
