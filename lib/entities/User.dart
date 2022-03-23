class User {
  String _name;
  String _DOB;
  String _emailAddress;
  int _contactNum;
  String _passwordU;
  String _NOKname;
  int _NOKcontactNum;

  /// Singleton
  static final User _inst = new User._internal();

  User._internal();

  factory User(
      String _name,
      String _DOB,
      String _emailAddress,
      int _contactNum,
      String _passwordU,
      String _NOKname,
      int _NOKcontactNum
      )
  {
    _inst._name = _name;
    _inst._DOB = _DOB;
    _inst._emailAddress = _emailAddress;
    _inst._contactNum = _contactNum;
    _inst._passwordU = _passwordU;
    _inst._NOKname = _NOKname;
    _inst._NOKcontactNum = _NOKcontactNum;

    return _inst;
  }

  User.fromMap(Map<String,dynamic> map){
    _name = map['name'];
    _DOB = map['DOB'];
    _emailAddress = map['emailAddress'];
    _contactNum= map['contactNum'];
    _passwordU= map['passwordU'];
    _NOKname= map['NOKname'];
    _NOKcontactNum= map['NOKcontactNum'];
  }

  /// This function maps the local variables of a User instance and returns a map
  Map<String,dynamic> toMap() {
    var map = <String,dynamic>{
      'name':_name,
      'DOB': _DOB,
      'emailAddress': _emailAddress,
      'contactNum': _contactNum,
      'passwordU': _passwordU,
      'NOKname': _NOKname,
      'NOKcontactNum': _NOKcontactNum,
    };
    return map;
  }

  /// This function is a getter for the local variable name
  String get name => _name;

  /// This function is a setter for the local variable name
  set name(String value) {
    _name = value;
  }

  /// This function is a getter for the local variable DOB
  String get DOB => _DOB;

  /// This function is a setter for the local variable DOB
  set DOB(String value) {
    _DOB = value;
  }

  /// This function is a getter for the local variable emailAddress
  String get emailAddress => _emailAddress;

  /// This function is a setter for the local variable emailAddress
  set emailAddress(String value) {
    _emailAddress = value;
  }

  /// This function is a getter for the local variable contactNum
  int get contactNum => _contactNum;

  /// This function is a setter for the local variable contactNum
  set contactNum(int value) {
    _contactNum = value;
  }

  /// This function is a getter for the local variable passwordU
  String get passwordU => _passwordU;

  /// This function is a setter for the local variable passwordU
  set passwordU(String value) {
    _passwordU = value;
  }

  /// This function is a getter for the local variable NOKname
  String get NOKname => _NOKname;

  /// This function is a setter for the local variable NOKname
  set NOKname(String value) {
    _NOKname = value;
  }

  /// This function is a getter for the local variable NOKcontactNum
  int get NOKcontactNum => _NOKcontactNum;

  /// This function is a setter for the local variable NOKcontactNum
  set NOKcontactNum(int value) {
    _NOKcontactNum = value;
  }
}