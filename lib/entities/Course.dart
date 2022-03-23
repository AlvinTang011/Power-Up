class Course{
  int _courseID;
  String _courseTitle;
  String _courseDesc;
  String _company;
  double _rating;
  double _price;
  String _url;
  String _location;
  String _ageGroup;
  String _nameOfPOC;
  int _contactNumOfPOC;
  String _startDate;
  String _regDeadline;

  /// Singleton
  static final Course _inst = new Course._internal();

  Course._internal();

  factory Course(
      String _courseTitle,
      String _courseDesc,
      String _company,
      double _rating,
      double _price,
      String _url,
      String _location,
      String _ageGroup,
      String _nameOfPOC,
      int _contactNumOfPOC,
      String _startDate,
      String _regDeadline,
      )
  {
    _inst._courseTitle = _courseTitle;
    _inst._courseDesc = _courseDesc;
    _inst._company = _company;
    _inst._rating = _rating;
    _inst._price = _price;
    _inst._url = _url;
    _inst._location = _location;
    _inst._ageGroup = _ageGroup;
    _inst._nameOfPOC = _nameOfPOC;
    _inst._contactNumOfPOC = _contactNumOfPOC;
    _inst._startDate = _startDate;
    _inst._regDeadline = _regDeadline;

    return _inst;
  }

  Course.fromMap(Map<String,dynamic> map){
    _courseID = map['courseID'];
    _courseTitle = map['courseTitle'];
    _courseDesc = map['courseDesc'];
    _company = map['companyName'];
    _rating = map['rating'];
    _price = map['price'];
    _url = map['url'];
    _location = map['location'];
    _ageGroup = map['ageGroup'];
    _nameOfPOC = map['nameOfPOC'];
    _regDeadline = map['regDeadline'];
  }

  Course.forHomePage(Map<String,dynamic> map){
    _courseID = map['courseID'];
    _courseTitle = map['courseTitle'];
    _courseDesc = map['courseDesc'];
    _company = map['companyName'];
    _rating = map['rating'];
    _price = map['price'];
    _url = map['url'];
    _location = map['location'];
    _ageGroup = map['ageGroup'];
    _nameOfPOC = map['nameOfPOC'];
    _contactNumOfPOC = map['contactNumOfPOC'];
    _startDate = map['startDate'];
    _regDeadline = map['regDeadline'];
  }

  /// This function maps the local variables of a Course instance and returns a map
  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'courseID' : _courseID,
      'courseTitle' : _courseTitle,
      'courseDesc' : _courseDesc,
      'companyName' : _company,
      'rating' : _rating,
      'price' : _price,
      'url' : _url,
      'location' : _location,
      'ageGroup' : _ageGroup,
      'nameOfPOC' : _nameOfPOC,
      'contactNumOfPOC' : _contactNumOfPOC,
      'startDate' : _startDate,
      'regDeadline' : _regDeadline,
    };
    return map;
  }

  /// This function is a getter for the local variable courseID
  int get courseID => _courseID;

  /// This function is a setter for the local variable courseID
  set courseID(int value) {
    _courseID = value;
  }

  /// This function is a getter for the local variable courseTitle
  String get courseTitle => _courseTitle;

  /// This function is a setter for the local variable courseTitle
  set courseTitle(String value) {
    _courseTitle = value;
  }

  /// This function is a getter for the local variable courseDesc
  String get courseDesc => _courseDesc;

  /// This function is a setter for the local variable courseDesc
  set courseDesc(String value) {
    _courseDesc = value;
  }

  /// This function is a getter for the local variable company
  String get company => _company;

  /// This function is a setter for the local variable company
  set company(String value) {
    _company = value;
  }

  /// This function is a getter for the local variable rating
  double get rating => _rating;

  /// This function is a setter for the local variable rating
  set rating(double value) {
    _rating = value;
  }

  /// This function is a getter for the local variable price
  double get price => _price;

  /// This function is a setter for the local variable price
  set price(double value) {
    _price = value;
  }

  /// This function is a getter for the local variable url
  String get url => _url;

  /// This function is a setter for the local variable url
  set url(String value) {
    _url = value;
  }

  /// This function is a getter for the local variable location
  String get location => _location;

  /// This function is a setter for the local variable location
  set location(String value) {
    _location = value;
  }

  /// This function is a getter for the local variable ageGroup
  String get ageGroup => _ageGroup;

  /// This function is a setter for the local variable ageGroup
  set ageGroup(String value) {
    _ageGroup = value;
  }

  /// This function is a getter for the local variable nameOfPOC
  String get nameOfPOC => _nameOfPOC;

  /// This function is a setter for the local variable nameOfPOC
  set nameOfPOC(String value) {
    _nameOfPOC = value;
  }

  /// This function is a getter for the local variable contactNumOfPOC
  int get contactNumOfPOC => _contactNumOfPOC;

  /// This function is a setter for the local variable contactNumOfPOC
  set contactNumOfPOC(int value) {
    _contactNumOfPOC = value;
  }

  /// This function is a getter for the local variable startDate
  String get startDate => _startDate;

  /// This function is a setter for the local variable startDate
  set startDate(String value) {
    _startDate = value;
  }

  /// This function is a getter for the local variable regDeadline
  String get regDeadline => _regDeadline;

  /// This function is a setter for the local variable regDeadline
  set regDeadline(String value) {
    _regDeadline = value;
  }
}