class Session{
  int _sessionID;
  String _startDate;
  String _dateTime;
  int _vacancy;
  int _classSize;
  List<String> participantList;

  /// Singleton
  static final Session _inst = new Session._internal();

  Session._internal();

  factory Session(
      String _startDate,
      String _dateTime,
      int _vacancy,
      int _classSize,
      )
  {
    _inst._startDate = _startDate;
    _inst._dateTime = _dateTime;
    _inst._vacancy = _vacancy;
    _inst._classSize = _classSize;

    return _inst;
  }

  factory Session.empty(){return _inst;}

  Session.fromMap(Map<String, dynamic> map) {
    _sessionID = map['sessionID'];
    _startDate = map['startDate'];
    _dateTime = map['dateTime'];
    _vacancy = map['vacancy'];
    _classSize = map['classSize'];
  }

  /// This function maps the local variables of a Session instance and returns a map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      "sessionID":_sessionID,
      "startDate":_startDate,
      "dateTime": _dateTime,
      "vacancy":_vacancy,
      "classSize": _classSize,
    };
    return map;
  }

  /// This function is a getter for the local variable sessionID
  int get sessionID => _sessionID;

  /// This function is a setter for the local variable sessionID
  set sessionID(int value) {
    _sessionID = value;
  }

  /// This function is a getter for the local variable startDate
  String get startDate => _startDate;

  /// This function is a setter for the local variable startDate
  set startDate(String value) {
    _startDate = value;
  }

  /// This function is a getter for the local variable dateTime
  String get dateTime => _dateTime;

  /// This function is a setter for the local variable dateTime
  set dateTime(String value) {
    _dateTime = value;
  }

  /// This function is a getter for the local variable vacancy
  int get vacancy => _vacancy;

  /// This function is a setter for the local variable vacancy
  set vacancy(int value) {
    _vacancy = value;
  }

  /// This function is a getter for the local variable classSize
  int get classSize => this._classSize;

  /// This function is a setter for the local variable classSize
  set classSize(int value) {
    _classSize = value;
  }

  /// This function is a getter for the local variable participantList
  List<String> get participantListTotal => this.participantList;

  /// This function is a setter for the local variable participantList
  set participantListTotal(List<String> participantEmail) {
    participantList = participantEmail;
  }

  /// This function adds a new User to a Session's participant list and decreases
  /// the Session's vacancy
  void addToParticipantList(String participantEmail){
    participantList.add(participantEmail);
    _vacancy--;
  }

  /// This function removes an existing User from a Session's participant list and increases
  /// the Session's vacancy
  void removeFromParticipantList(String participantEmail){
    participantList.remove(participantEmail);
    _vacancy++;
  }
}