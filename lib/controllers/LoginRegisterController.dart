import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:powerup/DBHelper.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Vendor.dart';
import '../DBHelper.dart';


class LoginRegisterController{

  /// Singleton
  static LoginRegisterController single_instance = null;
  static LoginRegisterController getInstance()
  {
    if (single_instance == null)
      single_instance = new LoginRegisterController();

    return single_instance;
  }

  DBHelper dbHelper = DBHelper.getInstance();

  /// This function gets the list of User Objects in the database and checks if the user's email address matches
  /// any of the existing email address in the database and returns that user object, else nothings is returned
  Future<User> getUserObj(String emailAddress) async {
    /// Get list of User objects
    var users = await dbHelper.getAllUsers();
        /// check if the id attribute matches
        for (int i = 0; i < users.length; i++) {
          if (users[i].emailAddress == emailAddress)
            /// returns the user object that matches the user's email address
            return users[i];
        }
        /// returns no user object if the user's email address does not match any in the database
        return null;
  }

  /// This function gets the list of Vendor Objects in the database and checks if the vendor's email address matches
  /// any of the existing email address in the database and returns that vendor object, else nothings is returned
  Future<Vendor> getVendorObj(String emailAddress) async {
    /// Get list of Vendor objects
    var vendors = await dbHelper.getAllVendors();
        /// check if the id attribute matches
        for (int i = 0; i < vendors.length; i++) {
          if (vendors[i].emailAddress == emailAddress)
            /// returns the vendor object that matches the vendor's email address
            return vendors[i];
        }
        /// returns no vendor object if the vendor's email address does not match any in the database
        return null;
  }

  /// This function sends the OTP to the valid email
  void sendOtp(String email) async {
    EmailAuth.sessionName = "Power Up";
    await EmailAuth.sendOtp(receiverMail: email);
  }

  /// This function verifies if the input One Time Password (OTP) matches the OTP sent to the email address
  bool verify(String email, String otpController) {
    bool validate;
    validate = EmailAuth.validate(
        receiverMail:email,
        userOTP: otpController);
    return validate;
  }

  /// This function checks if input email address is valid first, then it will check if the email address already exists in the database
  /// If any of the conditions fail, the function will return false, else the function will return true
  Future<bool> isValidEmail(String email) async {
    /// Check if input email address format is valid
    try {
      final bool isValid = EmailValidator.validate(email);
      if (isValid == true) {
        /// If format is okay, check database if any existing email address match
        /// by first getting the list of User objects
        var users = await dbHelper.getAllUsers();
        /// check if the id attribute matches
        for (int i = 0; i < users.length; i++) {
          if (users[i].emailAddress == email)
            /// return false if email address matches in database (match --> email already in use)
            return false;
        }
        /// return true if email address does not exist in database
        return true;
      }
    } catch(e) {
      print(e);
    }
    /// If control flow reaches here ==> caught error
    return false;
  }

  /// This function checks if the user has input the password accordingly to how it should be
  /// If the password matches the pattern, the function will return true, else false will be returned
  bool isValidPassword(String value){
          String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
          RegExp regExp = new RegExp(pattern);
          return regExp.hasMatch(value);
    }


  /// This function checks if the input contact number is in a valid Singapore contact number format
  /// If it is valid, true will be returned, else false will be returned
  bool isValidContactNum(int contactNum) {
    String contactNumStr = contactNum.toString();
    RegExp regExp = new RegExp(r"^[6|8|9]\d{7}$");
    if (!regExp.hasMatch(contactNumStr)) {
      return false;
    }
    else {
      return true;
    }
  }


  /// This function hashes the input password so as to allow for data protection and return the hashed password
  /// If there is an error in the hashing, "Hashing Failed" will be displayed on the screen
  String generateHash(String passwordU) {
    /// return hashed password for storage
    try {
      var bytes = utf8.encode(passwordU);
      var digest = sha256.convert(bytes);
      String output = digest.toString();
      return output;
    } catch(e) {
      print(e);
    }
    /// If control flow reaches here ==> caught error
    return "Hashing Failed.";
  }


  /// This function processes login for users/vendors with accounts in database
  /// return true if user/vendor found AND passwords match
  /// return false if username not found OR username found but password does not match.
  Future<String> login(String username, String password) async {
    /// Perform hashing for comparison with stored password later
    String hashedPassword = generateHash(password);
    try {
      var userAccounts = await dbHelper.getAllUsers();
      var vendorAccounts = await dbHelper.getAllVendors();
      /// Check for users
      for (int i = 0; i < userAccounts.length; i++) {
        if (userAccounts[i].emailAddress == username){
          if (userAccounts[i].passwordU == hashedPassword) {
            return "user";
          }
          if (!(userAccounts[i].passwordU == hashedPassword)) {
            /// User found but passwordU does not match
            return "Login Failed";
          }                 
        }
      }

      /// Check for vendors
      for (int i = 0; i < vendorAccounts.length; i++) {
        if (vendorAccounts[i].emailAddress == username){
          if (vendorAccounts[i].passwordV == hashedPassword) {
            return "vendor";            
          }

          if (!(vendorAccounts[i].passwordV == hashedPassword)) {
            /// Vendor found but passwordV does not match
            return "Login Failed";
          }
            
        }
      }
    } catch (e) {
      print(e);
    }
    /// If control flow reaches here ==> either:
    /// account does not exist (through try block)
    /// caught error (through catch block)
    return "Login Failed";
  }

  /// This function creates a new user to be stored in the database upon successfully registering a user account
  /// If there is an error in the processing of creating the user, null will be returned
  /// Else if the user is successfully created and saved in the database, the user object is returned
  Future<User> createUser(String name, String dob, String email, int contactNum, String passwordU, String nokName, int nokContactNum) async {
    String hashedPassword = "";
    /// Hash password for storage
    try {
      hashedPassword = generateHash(passwordU);
    } catch (e) {
      print(e);
      return null;
    }
    User user;
    User saveResult;
    /// Format data in User object to pass to DB class so that DBHelper can write to DB under one single user
    try {
      user = new User(name, dob, email, contactNum, hashedPassword, nokName, nokContactNum);
      saveResult = await dbHelper.saveUser(user);
    } catch (e) {
      print(e);
      return null;
    }

    if (!(user.emailAddress == saveResult.emailAddress)) {
      return null;
    }
    else {
      return user;
    }
  }

  /// This function creates a new vendor to be stored in the database upon successfully registering a vendor account
  /// If there is an error in the processing of creating the vendor, null will be returned
  /// Else if the vendor is successfully created and saved in the database, the vendor object is returned
  Future<Vendor> createVendor(String emailAddress, String nameOfPOC, int contactNumOfPOC, String passwordV, String busRegNum, String companyName) async {
    String hashedPassword = "";
    /// Hash password for storage
    try {
      hashedPassword = generateHash(passwordV);
    } catch (e) {
      print(e);
      return null;
    }
    Vendor vendor;
    Vendor saveResult;
    /// Format data in Vendor object to pass to DB class so that DBHelper can write to DB under one single vendor
    try {
      vendor = new Vendor(emailAddress, nameOfPOC, contactNumOfPOC, hashedPassword, busRegNum, companyName);
      saveResult = await dbHelper.saveVendor(vendor);
    } catch (e) {
      print(e);
      return null;
    }

    if (!(vendor == saveResult))
      return null;
    else
      return vendor;
  }
}